using ExpressBase.Common.Constants;
using ExpressBase.Common.Objects.Attributes;
using System.ComponentModel;

namespace ExpressBase.Common.Objects
{
    public class EbControlUI : EbControl
    {

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [PropertyEditor(PropertyEditorType.Color)]
        [UIproperty]
        [OnChangeUIFunction("Common.BACKCOLOR")]
        public virtual string BackColor { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [PropertyEditor(PropertyEditorType.Color)]
        [UIproperty]
        [OnChangeUIFunction("Common.FORECOLOR")]
        [Attributes.DefaultPropValue("#333333")]
        [Alias("Text Color")]
        public virtual string ForeColor { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [PropertyEditor(PropertyEditorType.FontSelector)]
        [UIproperty]
        [OnChangeUIFunction("Common.LABEL_STYLE")]
        public virtual EbFont LabelFontStyle { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [PropertyEditor(PropertyEditorType.Color)]
        [UIproperty]
        [OnChangeUIFunction("Common.LABEL_BACKCOLOR")]
        public virtual string LabelBackColor { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.Expandable)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [UIproperty]
        [OnChangeUIFunction("Common.MARGIN")]
        [DefaultPropValue(4, 4, 4, 4)]
        [PropertyPriority(-1)]
        public virtual UISides Margin { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [PropertyEditor(PropertyEditorType.Color)]
        [Attributes.DefaultPropValue("#6b6a6a")]
        [UIproperty]
        //[OnChangeUIFunction("Common.LABEL_COLOR")]
        [Alias("Label Color")]
        public virtual string LabelForeColor { get; set; }

        //[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        //[PropertyGroup(PGConstants.APPEARANCE)]
        //[UIproperty]
        //[PropertyEditor(PropertyEditorType.Label)]
        //public virtual string FontFamily { get; set; }

        [EnableInBuilder(BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [UIproperty]
        public virtual float FontSize { get; set; }

    }


    [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
    public class UISides
    {
        public UISides() { }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [DefaultPropValue(8)]
        public virtual int Top { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [DefaultPropValue(8)]
        public virtual int Right { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [DefaultPropValue(8)]
        public virtual int Bottom { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [DefaultPropValue(8)]
        public virtual int Left { get; set; }
    }
}
