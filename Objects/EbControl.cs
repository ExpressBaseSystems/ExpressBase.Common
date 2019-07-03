using ExpressBase.Common.Objects.Attributes;
using ServiceStack;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;
using System.Reflection;
using ExpressBase.Objects;
using Newtonsoft.Json;
using ExpressBase.Common.JsonConverters;
using ExpressBase.Common.Structures;
using ExpressBase.Common.Extensions;
using System.Runtime.Serialization;

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
            if (string.IsNullOrEmpty(this.OnChangeFn.Code) && !string.IsNullOrEmpty(_OnChange.Code))
                this.OnChangeFn = _OnChange;
        }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string EbSid { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string EbSid_CtxId { get { return (!ContextId.IsNullOrEmpty()) ? string.Concat(ContextId, "_", EbSid) : EbSid; } set { } }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string ContextId { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.UserControl)]
        public string DBareHtml { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string ChildOf { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool Unique { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [OnChangeUIFunction("Common.HELP_TEXT")]
        [UIproperty]
        public virtual string HelpText { get; set; }


        [JsonIgnore]
        public virtual string UIchangeFns { get; set; }

        public virtual EbDbTypes EbDbType { get { return EbDbTypes.Decimal; } set { } }

        [Description("Labels")]
        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [UIproperty]
        [Unique]
        [OnChangeUIFunction("Common.LABEL")]
        [PropertyEditor(PropertyEditorType.MultiLanguageKeySelector)]
        public virtual string Label { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.Collection)]
        public virtual List<EbValidator> Validators { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("Visible Expression")]
        public virtual EbScript VisibleExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("Value Expression")]
        public virtual EbScript ValueExpr { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual List<string> DependedValExp { get; set; }

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
        [JsonIgnore]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string BareControlHtml { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool IsDisable { get; set; }

        [EnableInBuilder(BuilderType.BotForm)]
        public virtual bool IsReadOnly { get; set; }

        [EnableInBuilder(BuilderType.BotForm)]
        public virtual bool IsMaintainValue { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string ToolTipText { get; set; }

        [ProtoBuf.ProtoMember(13)]
        [Browsable(false)]
        public virtual int CellPositionRow { get; set; }

        [ProtoBuf.ProtoMember(14)]
        [Browsable(false)]
        public virtual int CellPositionColumn { get; set; }

        [ProtoBuf.ProtoMember(15)]
        [Browsable(false)]
        public virtual int Left { get; set; }

        [ProtoBuf.ProtoMember(16)]
        [Browsable(false)]
        public virtual int Top { get; set; }

        [ProtoBuf.ProtoMember(17)]
        [PropertyGroup("Layout")]
        public virtual int Height { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool Required { get; set; }

        [JsonIgnore]
        public virtual string DesignHtml4Bot { get; set; }

        public virtual bool isFullViewContol { get; set; }

        public virtual bool isSelfCollection { get; set; }

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool DoNotPersist { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual bool IsSysControl { get { return false; } }//is placeholder control

        protected string RequiredString
        {
            get { return (this.Required ? "$('#{0}').focusout(function() { isRequired(this); }); $('#{0}Lbl').html( $('#{0}Lbl').text() + '<sup style=\"color: red\">*</sup>') ".Replace("{0}", this.Name) : string.Empty); }
        }

        protected string UniqueString
        {
            get { return (this.Unique ? "$('#{0}').focusout(function() { isUnique(this); });".Replace("{0}", this.Name) : string.Empty); }
        }

        public static string AttachedLblAddingJS = @"
$('<div id=\'{0}AttaLbl\' class=\'attachedlabel atchdLblL\'>$</div>').insertBefore($('#{0}').parent()); $('#{0}').addClass('numinputL')
$('#{0}AttaLbl').css({'padding':   ( $('#{0}').parent().height()/5 + 1) + 'px' });
$('#{0}AttaLbl').css({'font-size': ($('#{0}').css('font-size')) });
if( $('#{0}').css('font-size').replace('px','') < 10 )
    $('#{0}AttaLbl').css({'height':   ( $('#{0}').parent().height() - ( 10.5 - $('#{0}').css('font-size').replace('px','')) ) + 'px' }); 
else
    $('#{0}AttaLbl').css({'height':   ( $('#{0}').parent().height()) + 'px' }); 
";

        [ProtoBuf.ProtoMember(21)]
        [PropertyGroup("Behavior")]
        public virtual bool ReadOnly { get; set; }

        protected string ReadOnlyString
        {
            get { return (this.ReadOnly ? "background-color: #f0f0f0; border: solid 1px #bbb;' readonly" : "'"); }
        }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup("Behavior")]
        [PropertyPriority(99)]
        public virtual bool Hidden { get; set; }

        [ProtoBuf.ProtoMember(23)]
        public virtual bool SkipPersist { get; set; }

        [ProtoBuf.ProtoMember(24)]
        public virtual string RequiredExpression { get; set; }

        [ProtoBuf.ProtoMember(25)]
        public virtual string UniqueExpression { get; set; }

        [ProtoBuf.ProtoMember(26)]
        public virtual string ReadOnlyExpression { get; set; }

        [ProtoBuf.ProtoMember(27)]
        public virtual string VisibleExpression { get; set; }

        [ProtoBuf.ProtoMember(28)]
        [PropertyGroup("Accessibility")]
        public virtual int TabIndex { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("OnChangeFeb")]
        [HideInPropertyGrid]
        public virtual EbScript _OnChange { get; set; }// ===========================================temporary

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup("Events")]
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("OnChange")]
        public virtual EbScript OnChangeFn { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string DefaultValue { get; set; }

        public virtual string GetToolHtml() { return @"<div eb-type='@toolName' class='tool'>@toolName</div>".Replace("@toolName", this.GetType().Name.Substring(2)); }

        [JsonIgnore]
        public virtual string GetValueJSfn { get { return @"return $('#' + this.EbSid_CtxId).val();"; } set { } }

        [JsonIgnore]
        public virtual string GetDisplayMemberJSfn { get { return @"return this.getValue();"; } set { } }

        [JsonIgnore]
        public virtual string IsRequiredOKJSfn { get { return @"return !this.isInVisibleInUI ? !isNaNOrEmpty(this.getValue()) : true;"; } set { } }

        [JsonIgnore]
        public virtual string SetValueJSfn { get { return @"$('#' + this.EbSid_CtxId).val(p1).trigger('change');"; } set { } }

        [JsonIgnore]
        public virtual string SetDisplayMemberJSfn { get { return @"return this.setValue(p1);"; } set { } }

        [JsonIgnore]
        public virtual string HideJSfn { get { return @"$('#cont_' + this.EbSid_CtxId).hide(300); this.isInVisibleInUI = true;"; } set { } }

        [JsonIgnore]
        public virtual string ShowJSfn { get { return @"$('#cont_' + this.EbSid_CtxId).show(300); this.isInVisibleInUI = false;"; } set { } }

        [JsonIgnore]
        public virtual string EnableJSfn { get { return @"$('#cont_' + this.EbSid_CtxId + ' *').prop('disabled',false).css('pointer-events', 'inherit').find('[ui-inp]').css('background-color', '#fff');"; } set { } }

        [JsonIgnore]
        public virtual string DisableJSfn { get { return @"$('#cont_' + this.EbSid_CtxId + ' *').attr('disabled', 'disabled').css('pointer-events', 'none').find('[ui-inp]').css('background-color', '#f3f3f3');"; } set { } }

        [JsonIgnore]
        public virtual string ResetJSfn { get { return @"$('#' + this.EbSid_CtxId).val('');"; } set { } }

        [JsonIgnore]
        public virtual string RefreshJSfn { get { return @"$('#' + this.EbSid_CtxId).val('');"; } set { } }

        [JsonIgnore]
        public virtual string ClearJSfn { get { return @"$('#' + this.EbSid_CtxId).val('');"; } set { } }

        [JsonIgnore]
        public virtual string OnChangeBindJSFn { get { return @"$('#' + this.EbSid_CtxId).on('change', p1);"; } set { } }

        //methods        
        protected string ReplacePropsInHTML(string Html)
        {
            return Html
.Replace("@barehtml@", this.GetBareHtml())
.Replace("@name@", this.Name)
.Replace("@childOf@", this.ChildOf.IsNullOrEmpty() ? string.Empty : "childOf='" + this.ChildOf + "'")
.Replace("@ebsid@", this.EbSid_CtxId)
.Replace("@isHidden@", this.Hidden.ToString())
.Replace("@helpText@", this.HelpText)
.Replace("@type@", this.ObjType)
.Replace("@Label@ ", (Label ?? ""))
.Replace("@req@ ", (Required ? "<sup style='color: red'>*</sup>" : string.Empty));
        }

        public virtual string GetHead() { return string.Empty; }

        public virtual string GetHtml() { return string.Empty; }

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
            innerHTML = (!ChildObj.isFullViewContol) ? (@"<div class='chat-ctrl-cont'>" + innerHTML + "</div>") : innerHTML.Replace("@style@", "style='width:100%;border:none;'");
            ResHTML = @"
<div class='Eb-ctrlContainer iw-mTrigger' ctype='@type@'  eb-type='TextBox'>
   @LabelHTML@
   @ControlHTML@
</div>"
.Replace("@type@", type)
.Replace("@LabelHTML@", LabelHTML)
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

        [Description("Identity")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [EbRequired]
        [Unique]
        [regexCheck]
        [InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        public string Name { get; set; }

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
}