using ExpressBase.Common.Objects.Attributes;
using System.ComponentModel;

namespace ExpressBase.Common.Objects
{
    public class EbControlUI: EbControl
	{

		[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
		[PropertyGroup("Appearance")]
		[PropertyEditor(PropertyEditorType.Color)]
		[UIproperty]
        [OnChangeUIFunction("Common.BACKCOLOR")]
		public virtual string BackColor { get; set; }

		[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
		[PropertyGroup("Appearance")]
		[PropertyEditor(PropertyEditorType.Color)]
		[UIproperty]
        [OnChangeUIFunction("Common.FORECOLOR")]
        [System.ComponentModel.Category("Accessibility")]
		[Attributes.DefaultPropValue("#333333")]
		public virtual string ForeColor { get; set; }

		[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
		[PropertyGroup("Appearance")]
		[PropertyEditor(PropertyEditorType.Color)]
		[UIproperty]
        [OnChangeUIFunction("Common.LABEL_BACKCOLOR")]
        public virtual string LabelBackColor { get; set; }

		[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
		[PropertyGroup("Appearance")]
		[PropertyEditor(PropertyEditorType.Color)]
		[Attributes.DefaultPropValue("#333333")]
		[UIproperty]
        [OnChangeUIFunction("Common.LABEL_COLOR")]
        public virtual string LabelForeColor { get; set; }

		[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
		[PropertyGroup("Appearance")]
		[UIproperty]
		[PropertyEditor(PropertyEditorType.Label)]
		public virtual string FontFamily { get { return "Label"; } set { } }

		[EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
		[PropertyGroup("Appearance")]
		[UIproperty]
		public virtual float FontSize { get; set; }

	}
}
