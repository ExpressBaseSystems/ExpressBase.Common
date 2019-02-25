using ExpressBase.Common.Objects;
using ExpressBase.Common.Objects.Attributes;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
    public class EbFont
    {
        public EbFont() { }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public string FontName { get; set; } = "Times-Roman";

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public int Size { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public FontStyle Style { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public string color { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public bool Caps { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public bool Strikethrough { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.Report)]
        public bool Underline { get; set; }
    }
    //JS OBJ:  {"Font":"Abhaya Libre","Fontsize":"16","Fontstyle":"normal","FontWeight":"bold","Fontcolor":"#000000","Caps":"none","Strikethrough":"line-through","Underline":"none"}

    public enum FontStyle
    {
        NORMAL = 0,
        ITALIC = 2,
        BOLD = 1,
        BOLDITALIC = 3
    }
}
