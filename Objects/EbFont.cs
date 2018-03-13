using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public class EbFont
    {
        public EbFont() { }

        public string Font { get; set; }
        public int Size { get; set; }
        public FontStyle Style { get; set; }
        public string color { get; set; }
        public bool Caps { get; set; }
        public bool Strikethrough { get; set; }
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
