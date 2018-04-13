using ExpressBase.Common.Objects.Attributes;
using System.ComponentModel;

namespace ExpressBase.Common.Objects
{
    public class EbControlUI: EbControl
	{
		[System.ComponentModel.Category("Behavior")]
		[Description("Labels")]
		[EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
		[UIproperty]
		public virtual string HelpText { get; set; }

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

	}
}
