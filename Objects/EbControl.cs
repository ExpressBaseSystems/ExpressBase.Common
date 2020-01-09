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

namespace ExpressBase.Common.Objects
{
    public class EbControl : EbObject
    {
        public EbControl()
        {
            this.Validators = new List<EbValidator>();
            this.DependedValExp = new List<string>();
        }

        [OnDeserialized]
        public void OnDeserialized(StreamingContext context)
        {
            if (this.OnChangeFn == null)
                this.OnChangeFn = new EbScript();
            if (this._OnChange == null)
                this._OnChange = new EbScript();
            if (this.DefaultValueExpression == null)
                this.DefaultValueExpression = new EbScript();
            if (string.IsNullOrEmpty(this.OnChangeFn.Code) && !string.IsNullOrEmpty(_OnChange.Code))
                this.OnChangeFn = _OnChange;
        }

        public virtual bool IsRenderMode { get; set; }

        public virtual bool IsDynamicTabChild { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string EbSid { get; set; }

        [HideInPropertyGrid]
        [JsonIgnore]
        public virtual string ToolNameAlias { get; set; }

        [HideInPropertyGrid]
        [JsonIgnore]
        public virtual string ToolIconHtml { get; set; }

        [HideInPropertyGrid]
        [JsonIgnore]
        public virtual string ToolHelpText { get { return string.Empty; } set { } }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string EbSid_CtxId { get { return (!ContextId.IsNullOrEmpty()) ? string.Concat(ContextId, "_", EbSid) : EbSid; } set { } }

        private string _ContextId;

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
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

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Set true if want unique value for this control on every form save.")]
        public virtual bool Unique { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [OnChangeUIFunction("Common.HELP_TEXT")]
        [PropertyGroup("Identity")]
        [UIproperty]
        [HelpText("Desciption about the field to show under the control.")]
        public virtual string HelpText { get; set; }

        [JsonIgnore]
        public virtual string UIchangeFns { get; set; }

        [HideInPropertyGrid]
        public virtual EbDbTypes EbDbType { get { return EbDbTypes.Decimal; } set { } }

        [PropertyGroup("Identity")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [UIproperty]
        [Unique]
        [OnChangeUIFunction("Common.LABEL")]
        [PropertyEditor(PropertyEditorType.MultiLanguageKeySelector)]
        [HelpText("Label for the control to identify it's purpose.")]
        public virtual string Label { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.Collection)]
        [HelpText("List of validators to consider before form save.")]
        public virtual List<EbValidator> Validators { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [HelpText("Define default value of the control.")]
        public virtual EbScript DefaultValueExpression { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("Visible Expression")]
        [HelpText("Define conditions to decide visibility of the control.")]
        public virtual EbScript VisibleExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS, PropertyEditorType.ScriptEditorSQ)]
        [Alias("Value Expression")]
        [PropertyGroup("Behavior")]
        [HelpText("Define how value of this field should be calculated.")]
        public virtual EbScript ValueExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> DependedValExp { get; set; }

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
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string ObjType { get { return this.GetType().Name.Substring(2, this.GetType().Name.Length - 2); } set { } }

        [HideInPropertyGrid]
        [JsonIgnore] //temp // for gitex bot
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string BareControlHtml { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.BotForm)]
        public virtual string BareControlHtml4Bot { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [Alias("Readonly")]
        [HelpText("Control will be Disabled/Readonly if set to TRUE")]
        public virtual bool IsDisable { get; set; }

        [EnableInBuilder(BuilderType.BotForm)]
        [HelpText("Set true if you want to keep previous value in the control on subsequent form entry.")]
        [Alias("Maintain Previous Value ")]
        public virtual bool IsMaintainValue { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Help text which shows when mouse hover the control")]
        [PropertyGroup("Identity")]
        public virtual string ToolTipText { get; set; }

        [PropertyGroup("Layout")]
        [HelpText("Set height for the control.")]
        public virtual int Height { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Set true if you want to make sure this field is not empty when form save.")]
        public virtual bool Required { get; set; }

        [JsonIgnore]
        public virtual string DesignHtml4Bot { get; set; }

        public virtual bool isFullViewContol { get; set; }

        [PropertyGroup("Behavior")]
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

        [PropertyGroup("Behavior")]
        [HelpText("Set true if you want to make this control read only.")]
        public virtual bool ReadOnly { get; set; }//------------------------------

        protected string ReadOnlyString//------------------------------
        {
            get { return (this.ReadOnly ? "background-color: #f0f0f0; border: solid 1px #bbb;' readonly" : "'"); }
        }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup("Behavior")]
        [PropertyPriority(99)]
        [HelpText("Set true if you want to hide the control.")]
        public virtual bool Hidden { get; set; }

        public virtual bool SkipPersist { get; set; }//------------------------------

        public virtual string RequiredExpression { get; set; }

        public virtual string UniqueExpression { get; set; }

        public virtual string ReadOnlyExpression { get; set; }

        [PropertyGroup("Accessibility")]
        [HelpText("Set tab index for the control.")]
        public virtual int TabIndex { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("OnChangeFeb")]
        [PropertyGroup("Events")]
        [HideInPropertyGrid]
        public virtual EbScript _OnChange { get; set; }// ===========================================temporary

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup("Events")]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("OnChange")]
        [HelpText("Define onChange function.")]
        public virtual EbScript OnChangeFn { get; set; }

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
        public virtual string GetValueJSfn { get { return @"return this.DataVals.Value"; } set { } }

        [JsonIgnore]
        public virtual string GetValueFromDOMJSfn { get { return @"return $('#' + this.EbSid_CtxId).val();"; } set { } }

        [JsonIgnore]
        public virtual string GetDisplayMemberFromDOMJSfn { get { return GetValueFromDOMJSfn; } set { } }

        [JsonIgnore]
        public virtual string GetDisplayMemberJSfn { get { return @"return this.getValue();"; } set { } }

        [JsonIgnore]
		public virtual string IsRequiredOKJSfn { get { return JSFnsConstants.Ctrl_IsRequiredOKJSfn; } set { } }

		[JsonIgnore]
        public virtual string SetValueJSfn { get { return @"$('#' + this.EbSid_CtxId).val(p1).trigger('change');"; } set { } }

		[JsonIgnore]
        public virtual string JustSetValueJSfn { get { return @"$('#' + this.EbSid_CtxId).val(p1)"; } set { } }

        [JsonIgnore]
        public virtual string SetDisplayMemberJSfn { get { return @"return this.setValue(p1);"; } set { } }

        [JsonIgnore]
        public virtual string IsEmptyJSfn { get { return @" let val = this.getValue(); 
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
.Replace("@childOf@", this.ChildOf.IsNullOrEmpty() ? string.Empty : "childOf='" + this.ChildOf + "'")
.Replace("@ebsid@", this.IsRenderMode && this.IsDynamicTabChild ? "@" + this.EbSid_CtxId + "_ebsid@" : this.EbSid_CtxId)
.Replace("@isHidden@", this.Hidden.ToString().ToLower())
.Replace("@isReadonly@", this.IsDisable.ToString().ToLower())
.Replace("@helpText@", this.HelpText)
.Replace("@type@", this.ObjType)
.Replace("@Label@", (Label ?? ""))
.Replace("@req@ ", (Required ? "<sup style='color: red'>*</sup>" : string.Empty));
        }

        public virtual string GetHead() { return string.Empty; }

        public virtual string GetHtml() { return string.Empty; }

        public virtual string GetHtml4Bot() { return string.Empty; }

        public virtual string GetWrapedCtrlHtml4bot()
        {
            return '"' + "<div>no GetWrapedCtrlHtml4bot() defined</div>" + '"';
        }

        public virtual VendorDbType GetvDbType(IVendorDbTypes vDbTypes) { return vDbTypes.String; }

        public virtual string GetWrapedCtrlHtml4bot(ref EbControl ChildObj)
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
			innerHTML = (!ChildObj.isFullViewContol) ? (@"<div class='chat-ctrl-cont' 777777777>" + innerHTML + "</div>") : innerHTML.Replace("@style@", "style='width:100%;border:none;'");
            ResHTML = @"
<div class='Eb-ctrlContainer iw-mTrigger' ctype='@type@'  eb-type='@type@' ebsid='@ebsid@' JKLJKLJKL>
   @LabelHTML@
   @ControlHTML@
</div>"
.Replace("@type@", type)
.Replace("@LabelHTML@", LabelHTML)
.Replace("@ebsid@", this.EbSid_CtxId)
.Replace("@ControlHTML@", ControlHTML)
.Replace("@innerHTML@", innerHTML)
.Replace("@style@", (ChildObj.isFullViewContol ? "margin-left:12px;" : string.Empty)).RemoveCR();
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
        public virtual bool ParameterizeControl(IDatabase DataDB, List<DbParameter> param, string tbl, SingleColumn cField, bool ins, ref int i, ref string _col, ref string _val, ref string _extqry, User usr, SingleColumn ocF)
        {
            if (cField.Value == null || (this.EbDbType == EbDbTypes.Decimal && cField.Value == string.Empty))
            {
                var p = DataDB.GetNewParameter(cField.Name + "_" + i, (EbDbTypes)cField.Type);
                p.Value = DBNull.Value;
                param.Add(p);
            }
            else
                param.Add(DataDB.GetNewParameter(cField.Name + "_" + i, (EbDbTypes)cField.Type, cField.Value));

            if (ins)
            {
                _col += string.Concat(cField.Name, ", ");
                _val += string.Concat("@", cField.Name, "_", i, ", ");
            }
            else
                _col += string.Concat(cField.Name, "=@", cField.Name, "_", i, ", ");
            i++;
            return true;
        }

        //get data model of the control(formatted) // Value = null => to get default SingleColumn
        public virtual SingleColumn GetSingleColumn(User UserObj, Eb_Solution SoluObj, object Value)
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
                    _displayMember = "0.00";
                }
                else
                {
                    _formattedData = Convert.ToDouble(Value);
                    _displayMember = string.Format("{0:0.00}", _formattedData);
                }
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

    [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
    [HideInToolBox]
    [UsedWithTopObjectParent(typeof(EbObject))]
    public class EbValidator
    {
        [Alias("Validator")]
        public EbValidator() { }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public string EbSid { get; set; }

        [PropertyGroup("Identity")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [EbRequired]
        [Unique]
        [regexCheck]
        [InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        public string Name { get; set; }

        //[PropertyGroup("Behavior")]
        //[EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        //public string MaskPattern { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool IsDisabled { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool IsWarningOnly { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        public virtual EbScript Script { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [Alias("Failure message")]
        public virtual string FailureMSG { get; set; }
    }

    public interface IEbPlaceHolderControl { }
    public interface IEbSpecialContainer { }
}