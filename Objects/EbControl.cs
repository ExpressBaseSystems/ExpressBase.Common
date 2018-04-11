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

namespace ExpressBase.Common.Objects
{
    public class EbControl : EbObject
    {
        [Description("Labels")]
        [System.ComponentModel.Category("Behavior")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        [UIproperty]
        [Unique]
        public virtual string Label { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        public virtual string EbSid { get; set; }

        [EnableInBuilder(BuilderType.BotForm)]
        [PropertyEditor(PropertyEditorType.JS)]
        public string VisibleIf { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        public virtual string ObjType { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        public virtual string BareControlHtml { get; set; }

        [System.ComponentModel.Category("Behavior")]
        [Description("Labels")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        [UIproperty]
        public virtual string HelpText { get; set; }

        [ProtoBuf.ProtoMember(12)]
        [System.ComponentModel.Category("Behavior")]
        [Description("Labels")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
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
        [System.ComponentModel.Category("Layout")]
        public virtual int Height { get; set; }

        [ProtoBuf.ProtoMember(18)]
        [System.ComponentModel.Category("Layout")]
        public virtual int Width { get; set; }

        [ProtoBuf.ProtoMember(19)]
        [System.ComponentModel.Category("Behavior")]
        public virtual bool Required { get; set; }

        public virtual string DesignHtml4Bot { get; set; }

        public virtual bool isFullViewContol { get; set; }

        public virtual bool isSelfCollection { get; set; }

        protected string RequiredString
        {
            get { return (this.Required ? "$('#{0}').focusout(function() { isRequired(this); }); $('#{0}Lbl').html( $('#{0}Lbl').text() + '<sup style=\"color: red\">*</sup>') ".Replace("{0}", this.Name) : string.Empty); }
        }

        [ProtoBuf.ProtoMember(20)]
        [System.ComponentModel.Category("Behavior")]
        public virtual bool Unique { get; set; }

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
        [System.ComponentModel.Category("Behavior")]
        public virtual bool ReadOnly { get; set; }

        protected string ReadOnlyString
        {
            get { return (this.ReadOnly ? "background-color: #f0f0f0; border: solid 1px #bbb;' readonly" : "'"); }
        }

        [ProtoBuf.ProtoMember(22)]
        [System.ComponentModel.Category("Behavior")]
        public virtual bool Hidden { get; set; }

        protected string HiddenString
        {
            get { return (this.Hidden ? "visibility: hidden;" : string.Empty); }
        }

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
        [System.ComponentModel.Category("Accessibility")]
        public virtual int TabIndex { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm)]
        [PropertyGroup("Appearance")]
        [PropertyEditor(PropertyEditorType.Color)]
        [UIproperty]
        public virtual string BackColor { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm)]
        [PropertyGroup("Appearance")]
        [PropertyEditor(PropertyEditorType.Color)]
        [UIproperty]
        [System.ComponentModel.Category("Accessibility")]
        [Attributes.DefaultPropValue("#333333")]
        public virtual string ForeColor { get; set; }


        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm)]
        [PropertyGroup("Appearance")]
        [PropertyEditor(PropertyEditorType.Color)]
        [UIproperty]
        public virtual string LabelBackColor { get; set; }


        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm)]
        [PropertyGroup("Appearance")]
        [PropertyEditor(PropertyEditorType.Color)]
        [Attributes.DefaultPropValue("#333333")]
        [UIproperty]
        public virtual string LabelForeColor { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm)]
        [PropertyGroup("Appearance")]
        [UIproperty]
        [PropertyEditor(PropertyEditorType.Label)]
        public virtual string FontFamily { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm)]
        [PropertyGroup("Appearance")]
        [UIproperty]
        public virtual float FontSize { get; set; }

        [ProtoBuf.ProtoMember(34)]
        public EbValidatorCollection Validators { get; set; }

        public EbControl()
        {
            this.Validators = new EbValidatorCollection();
        }

        public virtual string GetHead() { return string.Empty; }

        public virtual string GetHtml() { return string.Empty; }

        public virtual string GetWrapedCtrlHtml4bot()
        {
            return '"' + "<div>no GetWrapedCtrlHtml4bot() defined</div>" + '"';
        }

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
         <div class='msg-wraper-bot'>
            @Label@
            <div class='msg-time'>3:44pm</div>
         </div>
      </div>
   </div>",
            ControlHTML = @"
<div class='msg-cont' for='TextBox1' form='LeaveJS'>
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
<div id='TextBox0' class='Eb-ctrlContainer iw-mTrigger' ctype='@type@'  eb-type='TextBox'>
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

        //        public string GetWrapedCtrlHtml4bot(string bareHTML, string type)
        //        {
        //            type = type.Substring(2, this.GetType().Name.Length - 2);
        //            string innerHTML = @" <div class='ctrl-wraper' @style@> @barehtml@ </div>".Replace("@barehtml@", bareHTML);
        //            bool t = true;
        //            if (!(type == "Cards" || type == "Locations" || type == "InputGeoLocation" || type == "Image"))
        //            {
        //                innerHTML = (@"<div class='chat-ctrl-cont'>" + innerHTML + "</div>");
        //                t = false;
        //            }
        //            else
        //                innerHTML = innerHTML.Replace("@style@", "style='width:100%;border:none;'");
        //            string res = @"
        //<div id='TextBox0' class='Eb-ctrlContainer iw-mTrigger' ctype='@type@'  eb-type='TextBox'>
        //   <div class='msg-cont'>
        //      <div class='bot-icon'></div>
        //      <div class='msg-cont-bot'>
        //         <div class='msg-wraper-bot'>
        //            @Label@
        //            <div class='msg-time'>3:44pm</div>
        //         </div>
        //      </div>
        //   </div>
        //   <div class='msg-cont' for='TextBox1' form='LeaveJS'>
        //      <div class='msg-cont-bot'>
        //         <div class='msg-wraper-bot' style='@style@ border: none; background-color: transparent; width: 99%; padding-right: 3px;'>
        //            @innerHTML@
        //         </div>
        //      </div>
        //   </div>
        //</div>"
        //.Replace("@type@", type)
        //.Replace("@innerHTML@", innerHTML)
        //.Replace("@style@", (t ? "margin-left:12px;" : string.Empty))
        //.RemoveCR().DoubleQuoted();
        //            return res;
        //        }

        public override void Init4Redis(IRedisClient redisclient, IServiceClient serviceclient)
        {
            base.Redis = redisclient;
            base.ServiceStackClient = serviceclient;
        }

        public virtual void SetData(object value) { }

        public virtual object GetData() { return null; }
        public virtual string GetToolHtml() { return @"<div eb-type='@toolName' class='tool'>@toolName</div>".Replace("@toolName", this.GetType().Name.Substring(2)); }

        protected string WrapWithDblQuotes(string input)
        {
            return "\"" + input + "\"";
        }
    }


    [ProtoBuf.ProtoContract]
    public class EbValidator
    {
        [Description("WebForm")]
        public string Name { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public bool IsDisabled { get; set; }

        [ProtoBuf.ProtoMember(3)]
        public string JScode { get; set; }

        [ProtoBuf.ProtoMember(4)]
        public string FailureMSG { get; set; }
    }

    [ProtoBuf.ProtoContract]
    public class EbValidatorCollection : List<EbValidator>
    {

    }

    public enum SubType
    {
        WithDecimalPlaces,
        WithTextTransform,
        WithEbDateType
    }
}