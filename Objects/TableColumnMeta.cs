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

        public Object Control { get; set; }

        public bool AutoIncrement { get; set; }

        public SingleColumn() { }        
    }

    public class SingleRow
    {        
        public string RowId { get; set; }

        public bool IsUpdate { get; set; }

        public bool IsDelete { get; set; }

        public List<SingleColumn> Columns { get; set; }

        public SingleRow()
        {
            Columns = new List<SingleColumn>();
        }
        
        public dynamic this[string name]
        {
            get
            {
                for(int i = 0; i < this.Columns.Count; i++)
                {
                    if (this.Columns[i].Name.Equals(name))
                    {
                        return this.Columns[i].Value;
                    }
                }
                throw new KeyNotFoundException { };
            }
            set
            {
                for (int i = 0; i < this.Columns.Count; i++)
                {
                    if (this.Columns[i].Name.Equals(name))
                    {
                        this.Columns[i].Value = value;
                        return;
                    }
                }
                throw new KeyNotFoundException { };
            }
        }

        public void SetEbDbType(string name, EbDbTypes ebDbType)
        {
            for (int i = 0; i < this.Columns.Count; i++)
            {
                if (this.Columns[i].Name.Equals(name))
                {
                    this.Columns[i].Type = (int)ebDbType;
                    return;
                }
            }
            throw new KeyNotFoundException();
        }

        public void SetControl(string name, Object control)
        {
            for (int i = 0; i < this.Columns.Count; i++)
            {
                if (this.Columns[i].Name.Equals(name))
                {
                    this.Columns[i].Control = control;
                    return;
                }
            }
            throw new KeyNotFoundException();
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

        public Dictionary<string, SingleTable> ExtendedTables { get; set; }

        public string MasterTable { get; set; }

        public string AutoIdText { get; set; }//prefix + suffix 

        public WebformData()
        {
            MultipleTables = new Dictionary<string, SingleTable>();
            ExtendedTables = new Dictionary<string, SingleTable>();
        }
    }

    public class WebFormSchema
    {
        public string FormName { set; get; }

        public List<TableSchema> Tables { set; get; }

        public string MasterTable { set; get; }

        public List<Object> ExtendedControls { get; set; }

        public WebFormSchema()
        {
            Tables = new List<TableSchema>();
            ExtendedControls = new List<Object>();
        }
    }

    public class TableSchema
    {
        public string TableName { set; get; }

        public string ParentTable { get; set; }

        public List<ColumnSchema> Columns { set; get; }

        public TableSchema()
        {
            Columns = new List<ColumnSchema>();
        }
    }

    public class ColumnSchema
    {
        public Object Control { get; set; }

        public string ColumnName { set; get; }

        public int EbDbType { set; get; }
    }
}
