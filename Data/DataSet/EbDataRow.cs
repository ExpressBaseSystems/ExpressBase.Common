﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.Serialization;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    public class EbDataRow : List<object>
    {
        internal RowColletion Rows { get; set; }

        internal EbDataRow() { }

        internal EbDataRow(int size) : base(size)
        {
            for (int i = 0; i < size; i++)
                base.Add(null);
        }

        new public void Add(object o)
        {
            base.Add(o);
        }

        new public object this[int index]
        {
            get
            {
                if (index > -1)
                {
                    if (base[index] == DBNull.Value)
                    {
                        if (this.Rows.Table.Columns[index].Type == System.Data.DbType.String)
                            return string.Empty;
                        else if (this.Rows.Table.Columns[index].Type == System.Data.DbType.Int32)
                            return 0;
                        else if (this.Rows.Table.Columns[index].Type == System.Data.DbType.Int64)
                            return 0;
                        else if (this.Rows.Table.Columns[index].Type == System.Data.DbType.Boolean)
                            return false;
                        else if (this.Rows.Table.Columns[index].Type == System.Data.DbType.Decimal)
                            return 0;
                        else if (this.Rows.Table.Columns[index].Type == System.Data.DbType.DateTime)
                            return DateTime.Now;
                    }
                    else
                        return base[index];
                }
                else
                    return null;
                return (index > -1) ? (base[index]) : null;
            }
            set
            {
                if (index > -1)
                    base[index] = value;
            }
        }

        public object this[string columnname]
        {
            get { return this[this.Rows.Table.Columns[columnname].ColumnIndex]; }
            set { this[this.Rows.Table.Columns[columnname].ColumnIndex] = value; }
        }
    }

    [ProtoBuf.ProtoContract]
    public class RowColletion : List<EbDataRow>
    {
        internal EbDataTable Table { get; set; }

        [OnDeserialized]
        public void OnDeserializedMethod(StreamingContext context)
        {
            foreach (EbDataRow dr in this)
                dr.Rows = this;
        }

        public RowColletion() { }

        public RowColletion(EbDataTable table)
        {
            this.Table = table;
        }

        new public void Add(EbDataRow dr)
        {
            dr.Rows = this;
            base.Add(dr);
        }

        public void Remove(int index)
        {
            base.RemoveAt(index);
        }

        new public void Remove(EbDataRow row)
        {
            base.Remove(row);
        }
    }
}
