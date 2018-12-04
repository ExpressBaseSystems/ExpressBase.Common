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

    public class AuditTrailEntry
    {
        public string Name { get; set; }

        public string NewVal { get; set; }

        public string OldVal { get; set; }

        public string DataRel { get; set; }

        public AuditTrailEntry() { }
    }

    public class SingleColumn
    {
        public string Name { get; set; }

        public dynamic Value { get; set; }

        public int Type { get; set; }

        public bool AutoIncrement { get; set; }

        public SingleColumn() { }
    }

    public class SingleRow
    {        
        public string RowId { get; set; }

        public bool IsUpdate { get; set; }

        public List<SingleColumn> Columns { get; set; }

        public SingleRow()
        {
            Columns = new List<SingleColumn>();
        }
    }

    public class SingleTable : List<SingleRow>
    {
        public string ParentTable { get; set; }

        public string ParentRowId { get; set; }
    }

    public class WebformData 
    {
        public string Name { set; get; }

        public Dictionary<string, SingleTable> MultipleTables { get; set; }

        public string MasterTable { get; set; }

        public WebformData()
        {
            MultipleTables = new Dictionary<string, SingleTable>();
        }
    }
}
