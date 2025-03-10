﻿using ExpressBase.Common.Structures;
using ProtoBuf;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    public class EbDataColumn
    {
        public EbDataColumn() { }

        public EbDataColumn(string columnname, EbDbTypes type)
        {
            this.ColumnName = columnname;
            this.Type = type;
        }

        public EbDataColumn(int index, string columnname, EbDbTypes type)
        {
            this.ColumnIndex = index;
            this.ColumnName = columnname;
            this.Type = type;
        }

        [ProtoBuf.ProtoMember(1)]
        public int ColumnIndex { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public string ColumnName { get; set; }

        [ProtoBuf.ProtoMember(3)]
        public EbDbTypes Type { get; set; }

        [ProtoBuf.ProtoMember(4)]
        public string TableName { get; set; }

        [ProtoBuf.ProtoMember(5)]
        public string DataTypeName { get; set; }
    }

    [ProtoBuf.ProtoContract(IgnoreListHandling = true)]
    public class ColumnColletion : List<EbDataColumn>
    {
        internal EbDataTable Table { get; set; }

        public ColumnColletion() { }

        public ColumnColletion(EbDataTable table)
        {
            this.Table = table;
        }

        public EbDataColumn this[string columnname]
        {
            get
            {
                foreach (EbDataColumn column in this)
                {
                    if (column.ColumnName == columnname)
                        return column;
                }

                return null;
            }
        }

        new public void Add(EbDataColumn column)
        {
            base.Add(column);

            foreach (EbDataRow row in this.Table.Rows)
                row.Add(null);
        }

        public void BaseAdd(EbDataColumn column)
        {
            base.Add(column);
        }

        public bool Contains(string columnName)
        {
            return this.Any(column => column.ColumnName != null &&
                              columnName != null &&
                              column.ColumnName.Equals(columnName, StringComparison.OrdinalIgnoreCase));             
        }
    }
}
