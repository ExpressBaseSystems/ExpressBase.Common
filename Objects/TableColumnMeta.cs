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

    public class SingleRecordField
    {
        public SingleRecordField() { }

        public string Name { get; set; }

        public dynamic Value { get; set; }

        public int Type { get; set; }

        public bool AutoIncrement { get; set; }
    }
}
