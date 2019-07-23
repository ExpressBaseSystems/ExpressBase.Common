﻿using ExpressBase.Common.Objects.Attributes;
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
            if (this.DefaultValueExpression == null)
                this.DefaultValueExpression = new EbScript();
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
        [PropertyEditor(PropertyEditorType.ScriptEditorJS)]
        [Alias("Value Expression")]
        [PropertyGroup("Behavior")]
        [HelpText("Define how value of this field should be calculated.")]
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

        [PropertyGroup("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Set true if you want to disable this control on form.")]
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

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HelpText("Set default value for the control.")]
        [PropertyGroup("Behavior")]
        [PropertyEditor(PropertyEditorType.Label)]
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