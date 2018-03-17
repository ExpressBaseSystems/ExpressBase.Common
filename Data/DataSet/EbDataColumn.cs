using ExpressBase.Common.Structures;
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

        public EbDbType Type
        {
            get { return (EbDbType)this.IntType; }
            set { this.IntType = (int)value; }
        }

        [ProtoBuf.ProtoMember(3)]
        public int IntType { get; set; }
    }

    [ProtoBuf.ProtoContract(IgnoreListHandling = true)]
    public class ColumnColletion : List<EbDataColumn>
    {
        internal EbDataTable Table { get; set; }

        public ColumnColletion(){ }

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
       
    }
}
