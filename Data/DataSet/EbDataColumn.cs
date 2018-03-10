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

        public EbDataColumn(string columnname, EbDbType type)
        {
            this.ColumnName = columnname;
            this.Type = type;
        }
      
        public EbDataColumn(int index, string columnname, EbDbType type)
        {
            this.ColumnIndex = index;
            this.ColumnName = columnname;
            this.Type = type;
        }

        [ProtoBuf.ProtoMember(1)]
        public int ColumnIndex { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public string ColumnName { get; set; }

        //[ProtoBuf.ProtoMember(3)]
        public EbDbType Type { get; set; }

    }

    [ProtoBuf.ProtoContract(IgnoreListHandling = true)]
    public class ColumnColletion 
    {
        [ProtoMember(1)]
        public List<EbDataColumn> data { get; set; }

        internal EbDataTable Table { get; set; }

        public ColumnColletion()
        {
            data = new List<EbDataColumn>();
        }

        public ColumnColletion(EbDataTable table)
        {
            this.Table = table;
            data = new List<EbDataColumn>();
        }

        public int Count
        {
            get
            {
                return data.Count;
            }
        }

        public EbDataColumn this[int index]
        {
            get
            {
                return data[index];
            }
        }

        public EbDataColumn this[string columnname]
        {
            get
            {
                foreach (EbDataColumn column in data)
                {
                    if (column.ColumnName == columnname)
                        return column;
                }

                return default(EbDataColumn);
            }
        }

        public IEnumerator<EbDataColumn> GetEnumerator()
        {
            return ((IEnumerable<EbDataColumn>)data).GetEnumerator();
        }

        public void Add(EbDataColumn column)
        {
            data.Add(column);
        }

        public void Sort(Comparison<EbDataColumn> comparison)
        {
            data.Sort(comparison);
        }
    }
}
