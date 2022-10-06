using ExpressBase.Common.Objects.Attributes;
using ServiceStack;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using ExpressBase.Security;
using ExpressBase.Objects;
using Newtonsoft.Json;
using ExpressBase.Common.Structures;
using ExpressBase.Common.Extensions;
using System.Runtime.Serialization;
using System.Data.Common;
using ExpressBase.Common.LocationNSolution;
using ExpressBase.Common.Constants;

namespace ExpressBase.Common.Objects
{
    public class EbControl : EbObject
    {
        public EbControl()
        {
            this.Validators = new List<EbValidator>();
            this.DependedValExp = new List<string>();
            this.DrDependents = new List<string>();
            this.DisableExpDependants = new List<string>();
            this.HiddenExpDependants = new List<string>();
            this.ValExpParams = new List<string>();
        }

        [OnDeserialized]
        public void OnDeserialized(StreamingContext context)
        {
            if (this.OnChangeFn == null)
                this.OnChangeFn = new EbScript();
            if (this._OnChange == null)
                this._OnChange = new EbScript();
            if (this.ValueExpr == null)
                this.ValueExpr = new EbScript();
            if (this.DefaultValueExpression == null)
                this.DefaultValueExpression = new EbScript();
            if (this.DisableExpr == null)
                this.DisableExpr = new EbScript();
            if (this.HiddenExpr == null)
                this.HiddenExpr = new EbScript();
            if (string.IsNullOrEmpty(this.OnChangeFn.Code) && !string.IsNullOrEmpty(_OnChange.Code))
                this.OnChangeFn = _OnChange;
        }

        public virtual bool IsRenderMode { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool IsNonDataInputControl { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.DashBoard, BuilderType.SurveyControl, BuilderType.DVBuilder)]
        public virtual string EbSid { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.DashBoard, BuilderType.SurveyControl)]
        public virtual string EbSid_CtxId
        {
            get
            {
                return (!ContextId.IsNullOrEmpty()) ? string.Concat(ContextId, "_", EbSid) : EbSid;
            }
            set { }
        }

        [HideInPropertyGrid]
        [JsonIgnore]
        [EnableInBuilder(BuilderType.SurveyControl)]
        public virtual string ToolNameAlias { get { return ObjType; } set { } }

        [HideInPropertyGrid]
        [JsonIgnore]
        public virtual string ToolIconHtml { get; set; }

        [HideInPropertyGrid]
        [JsonIgnore]
        public virtual string ToolHelpText { get { return string.Empty; } set { } }

        private string _ContextId;

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.DashBoard, BuilderType.SurveyControl)]
        public virtual string ContextId
        {
            get { return _ContextId; }

            set
            {
                _ContextId = value;
                EbSid_CtxId = string.Concat(ContextId, "_", EbSid);
            }
        }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.UserControl)]
        public string DBareHtml { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string ChildOf { get; set; }

        [PropertyGroup("Validations")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [HelpText("Set true if want unique value for this control on every form save.")]
        public virtual bool Unique { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [OnChangeUIFunction("Common.HELP_TEXT")]
        [PropertyGroup(PGConstants.HELP)]
        [UIproperty]
        [HelpText("Desciption about the field to show under the control.")]
        public virtual string HelpText { get; set; }

        [JsonIgnore]
        public virtual string UIchangeFns { get; set; }

        [HideInPropertyGrid]
        public virtual EbDbTypes EbDbType { get { return EbDbTypes.Decimal; } set { } }

        [PropertyGroup(PGConstants.HELP)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.UserControl)]
        [PropertyPriority(98)]
        [PropertyEditor(PropertyEditorType.String64)]
        [HelpText("Help information.")]
        [OnChangeExec(@"
        if(this.Info && this.Info.trim() !== ''){
            pg.ShowProperty('InfoIcon');
        }
        else{
            pg.HideProperty('InfoIcon');
        }")]
        public virtual string Info { get; set; }

        [PropertyGroup(PGConstants.HELP)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.UserControl)]
        [PropertyPriority(98)]
        [HelpText("Help information icon.")]
        [PropertyEditor(PropertyEditorType.IconPicker)]
        [DefaultPropValue("fa-question-circle")]
        public virtual string InfoIcon { get; set; }

        [PropertyGroup(PGConstants.CORE)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [UIproperty]
        [Unique]
        [OnChangeUIFunction("Common.LABEL")]
        [PropertyPriority(98)]
        [PropertyEditor(PropertyEditorType.MultiLanguageKeySelector)]
        [HelpText("Label for the control to identify it's purpose.")]
        public virtual string Label { get; set; }

        [PropertyGroup("Validations")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [PropertyEditor(PropertyEditorType.Collection)]
        [HelpText("List of validators to consider before form save.")]
        public virtual List<EbValidator> Validators { get; set; }

        [PropertyGroup(PGConstants.VALUE)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS, PropertyEditorType.ScriptEditorSQ)]
        [HelpText("Define default value of the control.")]
        public virtual EbScript DefaultValueExpression { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("Hide Expression")]
        [HelpText("Define conditions to decide visibility of the control.")]
        public virtual EbScript HiddenExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS, PropertyEditorType.ScriptEditorSQ)]
        [Alias("Value Expression")]
        [PropertyGroup(PGConstants.VALUE)]
        [HelpText("Define how value of this field should be calculated.")]
        public virtual EbScript ValueExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("ReadOnly Expression")]
        [PropertyGroup(PGConstants.BEHAVIOR)]
        [HelpText("Define conditions to decide Disabled/Readonly property of the control.")]
        public virtual EbScript DisableExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm)]
        [PropertyGroup(PGConstants.VALUE)]
        [HelpText("Execute its own value expression.")]
        public virtual bool SelfTrigger { get; set; }

        //ValExp Dependant ctrls list
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> DependedValExp { get; set; }

        //Data reader dependents map
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> DrDependents { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> HiddenExpDependants { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> DisableExpDependants { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> ValExpParams { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> DependedDG { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual string __path { get; set; }

        //to store front end data value of the control  
        public object ValueFE { get; set; }

        //to store back end data value of the control  
        public object ValueBE { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        public virtual string ObjType { get { return this.GetType().Name.Substring(2, this.GetType().Name.Length - 2); } set { } }

        [HideInPropertyGrid]
        [JsonIgnore] //temp // for gitex bot
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string BareControlHtml { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.BotForm)]
        public virtual string BareControlHtml4Bot { get; set; }

        [PropertyGroup(PGConstants.BEHAVIOR)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [Alias("Readonly")]
        [OnChangeExec(@"if(pg.builderType==='BotForm'){
							if (this.IsDisable === true ){
								pg.ShowProperty('ProceedBtnTxt');
							} 
							else {
								pg.HideProperty('ProceedBtnTxt');
							}
						}")]
        [HelpText("Control will be Disabled/Readonly if set to TRUE")]
        public virtual bool IsDisable { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.BotForm)]
        [DefaultPropValue("Ok")]
        [Alias("Proceed Button text")]
        public string ProceedBtnTxt { get; set; }

        [EnableInBuilder(BuilderType.BotForm)]
        [HelpText("Set true if you want to keep previous value in the control on subsequent form entry.")]
        [Alias("Maintain Previous Value ")]
        public virtual bool IsMaintainValue { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Help text which shows when mouse hover the control")]
        [PropertyGroup(PGConstants.HELP)]
        public virtual string ToolTipText { get; set; }

        [PropertyGroup("Layout")]
        [HelpText("Set height for the control.")]
        public virtual int Height { get; set; }

        [PropertyGroup("Validations")]
        [PropertyPriority(10)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [HelpText("Set true if you want to make sure this field is not empty when form save.")]
        public virtual bool Required { get; set; }

        [JsonIgnore]
        public virtual string DesignHtml4Bot { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual bool IsFullViewContol { get; set; }

        [PropertyGroup(PGConstants.DATA)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Set true if you dont want to save value from this field.")]
        public virtual bool DoNotPersist { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool IsSysControl { get; set; }//is placeholder control

        [EnableInBuilder(BuilderType.BotForm)]
        [PropertyGroup("Events")]
        [HelpText("Set true if you want to make this control read only.")]
        public virtual bool IsReadOnly { get; set; }//------------------------------

        //[PropertyGroup("Behavior")]
        //[HelpText("Set true if you want to make this control read only.")]
        //public virtual bool ReadOnly { get; set; }//------------------------------

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup("Behavior")]
        [PropertyPriority(95)]
        [HelpText("Set true if you want to hide the control.")]
        public virtual bool Hidden { get; set; }

        public virtual bool SkipPersist { get; set; }//------------------------------

        public virtual string RequiredExpression { get; set; }

        public virtual string UniqueExpression { get; set; }

        [PropertyGroup("Accessibility")]
        [HelpText("Set tab index for the control.")]
        public virtual int TabIndex { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("OnChangeFeb")]
        [PropertyGroup("Events")]
        [HideInPropertyGrid]
        public virtual EbScript _OnChange { get; set; }// ===========================================temporary

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [PropertyGroup("Events")]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("OnChange")]
        [HelpText("Define onChange function.")]
        public virtual EbScript OnChangeFn { get; set; }

        public virtual bool Index { get; set; }

        //hint: New mode - EbAutoId - DataPusher - Dest Form
        [JsonIgnore]
        public bool BypassParameterization { get; set; }

        public virtual string GetToolHtml()
        {
            return @"
<div eb-type='@toolName@' data-toggle='tooltip' title='@ToolHelpText@' class='tool'>
    <div class='tool-icon-cont'>@toolIconHtml@</div>@toolNameAlias@
</div>"
.Replace("@toolName@", this.GetType().Name.Substring(2))
.Replace("@toolNameAlias@", this.ToolNameAlias.IsNullOrEmpty() ? this.GetType().Name.Substring(2) : this.ToolNameAlias)
.Replace("@toolIconHtml@", this.ToolIconHtml)
.Replace("@ToolHelpText@", this.ToolHelpText);
        }

        [JsonIgnore]
        public virtual string GetValueJSfn { get { return @"return this.DataVals.Value;"; } set { } }

        [JsonIgnore]
        public virtual string GetPreviousValueJSfn { get { return @"return this.DataVals.PrevValue;"; } set { } }

        [JsonIgnore]
        public virtual string GetValueFromDOMJSfn { get { return @"return $('#' + this.EbSid_CtxId).val();"; } set { } }

        [JsonIgnore]
        public virtual string GetDisplayMemberFromDOMJSfn { get { return GetValueFromDOMJSfn; } set { } }

        [JsonIgnore]
        public virtual string GetDisplayMemberJSfn { get { return @"return this.getValue();"; } set { } }

        [JsonIgnore]
        public virtual string IsRequiredOKJSfn { get { return JSFnsConstants.Ctrl_IsRequiredOKJSfn; } set { } }

        [JsonIgnore]
        public virtual string SetValueJSfn { get { return SetDisplayMemberJSfn + @";$('#' + this.EbSid_CtxId).trigger('change');"; } set { } }

        [JsonIgnore]
        public virtual string SetDisplayMemberJSfn { get { return @"$('#' + this.EbSid_CtxId).val(p1)"; } set { } }//------------------

        [JsonIgnore]
        public virtual string JustSetValueJSfn
        {
            get { return @"
                this.___isNotUpdateValExpDepCtrls = true;
                this.setValue(p1);
"; }
            set { }
        }

        [JsonIgnore]
        public virtual string IsEmptyJSfn
        {
            get { return @" let val = this.getValue(); 
                 return (isNaNOrEmpty(val) || (typeof val === 'number' && val === 0) || val === undefined || val === null);"; }
            set { }
        }

        [JsonIgnore]
        public virtual string HideJSfn { get { return @"$('#cont_' + this.EbSid_CtxId).hide(300); this.isInVisibleInUI = true;"; } set { } }

        [JsonIgnore]
        public virtual string ShowJSfn { get { return @"$('#cont_' + this.EbSid_CtxId).show(300); this.isInVisibleInUI = false;"; } set { } }

        [JsonIgnore]
        public virtual string EnableJSfn { get { return JSFnsConstants.Ctrl_EnableJSfn; } set { } }

        [JsonIgnore]
        public virtual string DisableJSfn { get { return JSFnsConstants.Ctrl_DisableJSfn; } set { } }

        [JsonIgnore]
        public virtual string ResetJSfn { get { return @"this.clear(); this.setValue(p1);"; } set { } }

        [JsonIgnore]
        public virtual string RefreshJSfn { get { return @"$('#' + this.EbSid_CtxId).val('');"; } set { } }

        [JsonIgnore]
        public virtual string ClearJSfn { get { return @"this.setValue('');"; } set { } }

        [JsonIgnore]
        public virtual string OnChangeBindJSFn { get { return @"$('#' + this.EbSid_CtxId).on('change', p1);"; } set { } }

        [JsonIgnore]
        public virtual string AddInvalidStyleJSFn { get { return @"EbAddInvalidStyle.bind(this)(p1, p2, p3);"; } set { } }

        [JsonIgnore]
        public virtual string RemoveInvalidStyleJSFn { get { return @"EbRemoveInvalidStyle.bind(this)(p1, p2);"; } set { } }

        [JsonIgnore]
        public virtual string GetColumnJSfn { get { return @""; } set { } }

        [JsonIgnore]
        public virtual string StyleJSFn { get { return @"EbAddInvalidStyle.bind(this)(p1, p2);"; } set { } }

        //methods        
        protected string ReplacePropsInHTML(string Html)
        {
            return Html
.Replace("@barehtml@", this.GetBareHtml())
.Replace("@name@", this.Name)
.Replace("@LblInfo@", (Info.IsNullOrEmpty() ? String.Empty : HtmlConstants.LabelInfoContHTML))
.Replace("@childOf@", this.ChildOf.IsNullOrEmpty() ? string.Empty : "childOf='" + this.ChildOf + "'")
.Replace("@ebsid@", this.EbSid_CtxId)
.Replace("@isHidden@", this.Hidden.ToString().ToLower())
.Replace("@isReadonly@", ((this.ObjType == "TVcontrol") ? false : this.IsDisable).ToString().ToLower())
.Replace("@helpText@", this.HelpText)
.Replace("@type@", this.ObjType)
.Replace("@Label@", (Label ?? ""))
.Replace("@req@ ", (Required ? "<sup style='color: red'>*</sup>" : string.Empty));
        }

        //temporary for KSUM survey control        
        protected string ReplacePropsInHTML(string Html, string BareHtml)
        {
            return Html
.Replace("@barehtml@", BareHtml)
.Replace("@name@", this.Name)
.Replace("@childOf@", this.ChildOf.IsNullOrEmpty() ? string.Empty : "childOf='" + this.ChildOf + "'")
.Replace("@ebsid@", this.EbSid_CtxId)
.Replace("@isHidden@", this.Hidden.ToString().ToLower())
.Replace("@isReadonly@", ((this.ObjType == "TVcontrol") ? false : this.IsDisable).ToString().ToLower())
.Replace("@helpText@", this.HelpText)
.Replace("@type@", this.ObjType)
.Replace("@Label@", (Label ?? ""))
.Replace("@req@ ", (Required ? "<sup style='color: red'>*</sup>" : string.Empty));
        }

        public virtual string GetHead() { return string.Empty; }

        public virtual string GetHtml()
        {
            return ReplacePropsInHTML(HtmlConstants.CONTROL_WRAPER_HTML4WEB);
        }

        public virtual string GetHtml4Bot()
        {
            return ReplacePropsInHTML((HtmlConstants.CONTROL_WRAPER_HTML4BOT).Replace("@barehtml@", DesignHtml4Bot));
        }

        public virtual string GetWrapedCtrlHtml4bot()
        {
            return '"' + "<div>no GetWrapedCtrlHtml4bot() defined</div>" + '"';
        }

        public virtual VendorDbType GetvDbType(IVendorDbTypes vDbTypes) { return vDbTypes.String; }

        public virtual string GetWrapedCtrlHtml4bot(ref EbControl ChildObj)// for builder side JS contructor
        {
            string bareHTML = ChildObj.DesignHtml4Bot ?? ChildObj.GetBareHtml(),
            innerHTML = @" <div class='ctrl-wraper' @style@> @barehtml@ </div>".Replace("@barehtml@", bareHTML),
            ResHTML = string.Empty,
            type = ChildObj.GetType().Name.Substring(2, ChildObj.GetType().Name.Length - 2),
            LabelHTML = @"
						<div class='msg-cont'>
						  <div class='bot-icon'></div>
						  <div class='msg-cont-bot'>
							 <div ui-label class='msg-wraper-bot'>
								@Label@
								<div class='msg-time'>3:44pm</div>
							 </div>
						  </div>
					   </div>",
            ControlHTML = @"
							<div class='msg-cont'>
									<div class='msg-cont-bot'>
										<div class='msg-wraper-bot' style='@style@ border: none; background-color: transparent; width: 99%; padding-right: 3px;'>
										@innerHTML@
										</div>
									</div>
								</div>";
            if (type == "Labels")
            {
                ControlHTML = string.Empty;
                LabelHTML = bareHTML;
            }
            if (type == "Label")
            {
                ControlHTML = string.Empty;
            }
            innerHTML = (!ChildObj.IsFullViewContol) ? (@"<div class='chat-ctrl-cont'>" + innerHTML + "</div>") : innerHTML.Replace("@style@", "style='width:100%;border:none;'");
            ResHTML = @"
<div class='Eb-ctrlContainer iw-mTrigger' ctype='@type@'  eb-type='@type@' ebsid='@ebsid@'>
   @LabelHTML@
   @ControlHTML@
</div>"
.Replace("@type@", type)
.Replace("@LabelHTML@", LabelHTML)
.Replace("@ebsid@", this.EbSid_CtxId)
.Replace("@ControlHTML@", ControlHTML)
.Replace("@innerHTML@", innerHTML)
.Replace("@style@", (ChildObj.IsFullViewContol ? "margin-left:12px;" : string.Empty)).RemoveCR();
            return ResHTML;
        }

        public override void Init4Redis(IRedisClient redisclient, IServiceClient serviceclient)
        {
            base.Redis = redisclient;
            base.ServiceStackClient = serviceclient;
        }

        public virtual void SetData(object value) { }

        public virtual object GetData() { return null; }

        //tbl -> master table name, ins -> is insert, _col -> cols/colvals, _extqry -> extended query, ocF -> old column field
        public virtual bool ParameterizeControl(ParameterizeCtrl_Params args, string crudContext)
        {
            if (this.BypassParameterization && args.cField.Value == null)
                throw new Exception($"Unable to proceed/bypass with value '{args.cField.Value}' for {this.Name}");

            string paramName = args.cField.Name + crudContext;
            if (args.cField.Value == null || (this.EbDbType == EbDbTypes.Decimal && Convert.ToString(args.cField.Value) == string.Empty))
            {
                var p = args.DataDB.GetNewParameter(paramName, (EbDbTypes)args.cField.Type);
                p.Value = DBNull.Value;
                args.param.Add(p);
            }
            else if (!this.BypassParameterization)
            {
                EbDbTypes _t = (EbDbTypes)args.cField.Type;
                if (_t == EbDbTypes.Decimal || _t == EbDbTypes.Int32)
                {
                    if (!double.TryParse(Convert.ToString(args.cField.Value), out double temp))
                        throw new Exception($"Unable to proceed with value '{args.cField.Value}' for {this.Name}");
                }
                args.param.Add(args.DataDB.GetNewParameter(paramName, (EbDbTypes)args.cField.Type, args.cField.Value));
            }

            if (args.ins)
            {
                args._cols += args.cField.Name + CharConstants.COMMA + CharConstants.SPACE;
                if (this.BypassParameterization)
                    args._vals += Convert.ToString(args.cField.Value) + CharConstants.COMMA + CharConstants.SPACE;
                else
                    args._vals += CharConstants.AT + paramName + CharConstants.COMMA + CharConstants.SPACE;
            }
            else
            {
                if (this.BypassParameterization)
                    args._colvals += args.cField.Name + CharConstants.EQUALS + Convert.ToString(args.cField.Value) + CharConstants.COMMA + CharConstants.SPACE;
                else
                    args._colvals += args.cField.Name + CharConstants.EQUALS + CharConstants.AT + paramName + CharConstants.COMMA + CharConstants.SPACE;
            }
            args.i++;
            return true;
        }

        //get data model of the control(formatted) // Value = null => to get default SingleColumn
        public virtual SingleColumn GetSingleColumn(User UserObj, Eb_Solution SoluObj, object Value, bool Default)
        {
            return EbControl.GetSingleColumn(this, UserObj, SoluObj, Value);
        }

        public static SingleColumn GetSingleColumn(EbControl _this, User UserObj, Eb_Solution SoluObj, object Value)
        {
            object _formattedData = Value;
            string _displayMember = Value == null ? string.Empty : Value.ToString();

            if (_this.EbDbType == EbDbTypes.Decimal || _this.EbDbType == EbDbTypes.Int32)
            {
                if (Value == null)
                {
                    _formattedData = 0;
                    _displayMember = "0";
                }
                else
                {
                    _displayMember = Convert.ToString(Value);
                    if (double.TryParse(_displayMember, out double _t))
                        _formattedData = _t;
                    else
                        throw new Exception($"Invalid numeric value({_displayMember}) for '{_this.Name}'");
                }
            }
            else if (_this.EbDbType == EbDbTypes.String && _formattedData != null)
            {
                _formattedData = Convert.ToString(_formattedData);
            }

            return new SingleColumn()
            {
                Name = _this.Name,
                Type = (int)_this.EbDbType,
                Value = _formattedData,
                Control = _this,
                ObjType = _this.ObjType,
                F = _displayMember
            };
        }
    }

    [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
    [HideInToolBox]
    [UsedWithTopObjectParent(typeof(EbObject))]
    public class EbValidator
    {
        [Alias("Validator")]
        public EbValidator() { }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        public string EbSid { get; set; }

        [PropertyGroup(PGConstants.CORE)]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [EbRequired]
        [Unique]
        [regexCheck]
        [InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        public string Name { get; set; }

        //[PropertyGroup("Behavior")]
        //[EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        //public string MaskPattern { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        public virtual bool IsDisabled { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        public virtual bool IsWarningOnly { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        public virtual EbScript Script { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [Alias("Failure message")]
        public virtual string FailureMSG { get; set; }
    }

    //tbl -> master table name, ins -> is insert, _col -> cols/colvals, _extqry -> extended query, ocF -> old column field
    public class ParameterizeCtrl_Params
    {
        public ParameterizeCtrl_Params(IDatabase DataDB, List<DbParameter> param, int i, string _extqry)
        {
            this.DataDB = DataDB;
            this.param = param;
            this.i = i;
            this._extqry = _extqry;
        }

        //for simple parameterization
        public ParameterizeCtrl_Params(IDatabase DataDB, List<DbParameter> param, SingleColumn cField, int i, User usr)
        {
            this.DataDB = DataDB;
            this.param = param;
            this.cField = cField;
            this.i = i;
            this.usr = usr;

            this.ins = true;
            this._cols = string.Empty;
            this._vals = string.Empty;
            this._colvals = string.Empty;
        }

        public void SetFormRelated(string tbl, User usr, EbControl webForm)
        {
            this.tbl = tbl;
            this.usr = usr;
            this.webForm = webForm;
        }

        public void ResetColVals()
        {
            this._colvals = string.Empty;
        }

        public void ResetColsAndVals()
        {
            this._cols = string.Empty;
            this._vals = string.Empty;
        }

        public void InsertSet(SingleColumn cField)
        {
            this.ins = true;
            this.cField = cField;
            this.ocF = null;
        }

        public void UpdateSet(SingleColumn cField, SingleColumn ocF = null)
        {
            this.ins = false;
            this.cField = cField;
            this.ocF = ocF;
        }

        public void CopyBack(ref string _extqry, ref int i)
        {
            _extqry = this._extqry;
            i = this.i;
        }

        public IDatabase DataDB { get; private set; }

        public List<DbParameter> param { get; private set; }

        public string tbl { get; private set; }

        public SingleColumn cField { get; private set; }

        public bool ins { get; private set; }

        public int i { get; set; }

        public string _colvals { get; set; }

        public string _cols { get; set; }

        public string _vals { get; set; }

        public string _extqry { get; set; }

        public User usr { get; private set; }

        public SingleColumn ocF { get; private set; }

        public EbControl webForm { get; private set; }
    }

    public interface IEbPlaceHolderControl { }
    public interface IEbSpecialContainer { }
    public interface IEbComponent { }
}