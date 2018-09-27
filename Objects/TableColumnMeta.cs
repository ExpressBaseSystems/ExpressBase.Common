using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common
{
    public class TableColumnMeta
    {
        public string Name { get; set; }
        public VendorDbType Type { get; set; }
        public string Default { get; set; }
    }
}
