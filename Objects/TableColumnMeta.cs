using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Text;
namespace ExpressBase.Common
{
    public class TableColumnMeta
    {
        public string Name { get; set; }
        public VendorDbType Type
        {
            get { return Type; }
            set
            {
                Type = Type;
            }
        }
        public string Default { get; set; }
    }

    public class TableColumnMetaS
    {
        public TableColumnMetaS() { }

        public string Name { get; set; }

        public dynamic Value { get; set; }

        public int Type { get; set; }

        public bool AutoIncrement { get; set; }
    }

    public class TableColumnMetaSColl : List<TableColumnMetaS>
    {
        public TableColumnMetaSColl() { }
    }
}
