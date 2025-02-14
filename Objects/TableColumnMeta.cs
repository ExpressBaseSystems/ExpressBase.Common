﻿using ExpressBase.Common.Objects;
using ExpressBase.Common.Structures;
using ExpressBase.Objects;
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

        public object Value { get; set; }

        public int Type { get; set; }

        [JsonIgnore]
        public EbControl Control { get; set; }

        //public Dictionary<int, string[]> D { get; set; }//Display members //original
        public Dictionary<int, Dictionary<string, string>> D { get; set; }//Display members //duplicate

        public Dictionary<string, List<object>> R { get; set; }//Rows of ps

        public string ObjType { get; set; }//Object type

        public string F { get; set; }//Formatted text for date, time etc

        public string M { get; set; }//Meta

        public SingleColumn() { }
    }

    public class SingleRow
    {
        public int RowId { get; set; }

        public int LocId { get; set; }

        public string pId { get; set; }//parent row id

        public bool IsUpdate { get; set; }

        public bool IsDelete { get; set; }

        public List<SingleColumn> Columns { get; set; }

        [JsonIgnore]
        public KeyValuePair<string, SingleTable> LinesTable { get; set; }

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

        public bool RemoveColumn(string cname)
        {
            for (int i = 0; i < this.Columns.Count; i++)
            {
                if (this.Columns[i].Name.Equals(cname))
                {
                    this.Columns.RemoveAt(i);
                    return true;
                }
            }
            return false;
        }

        public void SetColumn(string cname, SingleColumn column)
        {
            for (int i = 0; i < this.Columns.Count; i++)
            {
                if (this.Columns[i].Name.Equals(cname))
                {
                    this.Columns[i] = column;
                    return;
                }
            }
            throw new KeyNotFoundException("KeyNotFoundException : Key = " + cname);
        }

        public object this[string name]
        {
            get
            {
                for (int i = 0; i < this.Columns.Count; i++)
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
                throw new KeyNotFoundException("KeyNotFoundException : Key = " + name);
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
            throw new KeyNotFoundException("KeyNotFoundException : Key = " + name);
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
            throw new KeyNotFoundException("KeyNotFoundException : Key = " + name);
        }
    }

    public class SingleTable : List<SingleRow>
    {
        public string ParentTable { get; set; }

        public string ParentRowId { get; set; }

    }

    public class WebformData
    {
        public Dictionary<string, SingleTable> MultipleTables { get; set; }

        public Dictionary<string, SingleTable> ExtendedTables { get; set; }

        public Dictionary<string, SingleRow> DGsRowDataModel { get; set; }

        [JsonIgnore]
        public Dictionary<string, SingleTable> PsDm_Tables { get; set; }

        public Dictionary<string, bool> DisableDelete { get; set; }

        public Dictionary<string, bool> DisableCancel { get; set; }

        public Dictionary<string, bool> DisableEdit { get; set; }

        public string MasterTable { get; set; }

        public int FormVersionId { get; set; }
        public bool IsLocked { get; set; }
        public bool IsCancelled { get; set; }
        public bool IsReadOnly { get; set; } //new
        public string SrcRefId { get; set; }
        public int SrcVerId { get; set; } //new
        public int SrcDataId { get; set; }
        public int CreatedBy { get; set; }
        public string CreatedAt { get; set; }
        public int ModifiedBy { get; set; }
        public string ModifiedAt { get; set; }
        public string CancelReason { get; set; }
        public List<int> LocPermissions { get; set; }
        public bool MultiLocViewAccess { get; set; }
        public bool MultiLocEditAccess { get; set; }
        public WebformDataInfo Info { get; set; }

        public WebformData()
        {
            MultipleTables = new Dictionary<string, SingleTable>();
            ExtendedTables = new Dictionary<string, SingleTable>();
            DGsRowDataModel = new Dictionary<string, SingleRow>();
            PsDm_Tables = new Dictionary<string, SingleTable>();
            DisableDelete = new Dictionary<string, bool>();
            DisableCancel = new Dictionary<string, bool>();
            DisableEdit = new Dictionary<string, bool>();
            LocPermissions = new List<int>();
        }
    }

    public class WebformDataInfo
    {
        public string CreBy { get; set; }
        public string CreAt { get; set; }
        public string CreFrom { get; set; }
        public string ModBy { get; set; }
        public string ModAt { get; set; }
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

        public List<EbControl> ExtendedControls { get; set; }

        public WebFormSchema()
        {
            Tables = new List<TableSchema>();
            ExtendedControls = new List<EbControl>();
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

        public string CustomSelectQuery { get; set; }

        public bool DescOdr { get; set; }//Descending order eb_row_num - datagrid

        //public bool IsDynamic { get; set; }//datagird in dynamic tab

        public bool DoNotPersist { get; set; }//DoNotPersist datagrid

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
        Review
    }
}
