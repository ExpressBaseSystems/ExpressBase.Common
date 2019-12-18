using ExpressBase.Common.Objects;
using ExpressBase.Common.Structures;
using Newtonsoft.Json;
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

        public bool Unique { get; set; }

        public EbControl Control { get; set; }

        public string Label { get; set; }
    }

    public class AuditTrailEntry
    {
        public string Name { get; set; }

        public string NewVal { get; set; }

        public string OldVal { get; set; }

        public string DataRel { get; set; }

        public string TableName { get; set; }

        public AuditTrailEntry() { }
    }

    public class AuditTrailInsertData
    {
        public string RefId { get; set; }

        public int TableRowId { get; set; }

        public int Action { get; set; }

        public List<AuditTrailEntry> Fields { get; set; }

        public AuditTrailInsertData()
        {
            this.Fields = new List<AuditTrailEntry>();
        }
    }

    public class SingleColumn
    {
        public string Name { get; set; }

        public dynamic Value { get; set; }

        public int Type { get; set; }

        [JsonIgnore]
        public EbControl Control { get; set; }

        //public Dictionary<int, string[]> D { get; set; }//Display members //original
        public Dictionary<int, Dictionary<string, string>> D { get; set; }//Display members //duplicate

        public List<SingleRow> R { get; set; }//Rows of ps

        public string ObjType { get; set; }//Object type

        public string F { get; set; }//Formatted text for date, time etc
        
        public SingleColumn() { }
    }

    public class SingleRow
    {        
        public int RowId { get; set; }

        public int LocId { get; set; }

        public bool IsUpdate { get; set; }

        public bool IsDelete { get; set; }

        public List<SingleColumn> Columns { get; set; }

        public SingleRow()
        {
            Columns = new List<SingleColumn>();
        }
        
        public SingleColumn GetColumn(string cname)
        {
            for (int i = 0; i < this.Columns.Count; i++)
            {
                if (this.Columns[i].Name.Equals(cname))
                {
                    return this.Columns[i];
                }
            }
            return null;
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
                return null;
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

        public void SetControl(string name, EbControl control)
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

        [JsonIgnore]
        public Dictionary<string, SingleTable> PsDm_Tables { get; set; }

        public Dictionary<string, bool> DisableDelete { get; set; }

        public Dictionary<string, bool> DisableCancel { get; set; }

        public string MasterTable { get; set; }

        public int FormVersionId { get; set; }
        public bool IsLocked { get; set; }
        public string DataPushId { get; set; }
        public int SourceId { get; set; }
        
        public WebformData()
        {
            MultipleTables = new Dictionary<string, SingleTable>();
            ExtendedTables = new Dictionary<string, SingleTable>();
            PsDm_Tables = new Dictionary<string, SingleTable>();
            DisableDelete = new Dictionary<string, bool>();
            DisableCancel = new Dictionary<string, bool>();
        }
    }

    public class WebformDataWrapper
    {
        public WebformData FormData { get; set; }

        public int Status { get; set; }

        public string Message { get; set; }

        public string MessageInt { get; set; }

        public string StackTraceInt { get; set; }
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

        public WebFormTableTypes TableType { get; set; }

        public string Title { get; set; }

        public string ContainerName { get; set; }

        public TableSchema()
        {
            Columns = new List<ColumnSchema>();
        }
    }

    public class ColumnSchema
    {
        public EbControl Control { get; set; }

        public string ColumnName { set; get; }

        public int EbDbType { set; get; }
    }

    public enum WebFormTableTypes
    {
        Normal,
        Grid,
        Approval
    }
}
