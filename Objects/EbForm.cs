using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Objects;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Text;

namespace ExpressBase.Common.Objects
{
    [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
    public class EbForm : EbControlContainer, IEBRootObject
    {
        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public override string RefId { get; set; }

        [PropertyGroup("Core")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public override string DisplayName { get; set; }

        [PropertyGroup("Data")]
        [EbRequired]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public override string TableName { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public override string Description { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public override string VersionNumber { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public override string Status { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.Expandable)]
        [PropertyGroup("Appearance")]
        [UIproperty]
        [OnChangeUIFunction("Common.ROOT_OBJ_PADDING")]
        [DefaultPropValue(8, 8, 8, 8)]
        public new  UISides Padding { get; set; }


        public override string HelpText { get; set; }

        public override bool Hidden { get; set; }

        public override string Label { get; set; }

        public override bool Required { get; set; }

        public override string ToolTipText { get; set; }

        public override string UIchangeFns { get; set; }

        public override bool Unique { get; set; }


        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyGroup("Behavior")]
        public override List<EbValidator> Validators { get; set; }

        //UI Properties
        public override string BackColor { get; set; }
        public override string ForeColor { get; set; }
        public override string LabelBackColor { get; set; }
        public override UISides Margin { get; set; }
        public override string LabelForeColor { get; set; }
        //public override string FontFamily { get { return "Label"; } set { } }
        public override float FontSize { get; set; }
    }
}
