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

    public class SinglColumn
    {
        public string Name { get; set; }

        public dynamic Value { get; set; }

        public dynamic OldValue { get; set; }

        public int Type { get; set; }

        public bool AutoIncrement { get; set; }

        public SinglColumn() { }
    }

    public class SingleRow
    {        
        public string RowId { get; set; }

        public bool IsUpdate { get; set; }

        public List<SinglColumn> Columns { get; set; }

        public SingleRow()
        {
            Columns = new List<SinglColumn>();
        }
    }

    public class MultipleRows 
    {
        public List<SingleRow> Rows { get; set; }

        public MultipleRows()
        {
            Rows = new List<SingleRow>();
        }
    }

    public class WebformData 
    {
        public Dictionary<string, MultipleRows> Tables { get; set; }

        public string MasterTable { get; set; }

        public WebformData()
        {
            Tables = new Dictionary<string, MultipleRows>();
        }
    }
}
