using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Data
{
    [ProtoBuf.ProtoContract]
    public class EbDataColumn
    {
        public EbDataColumn() { }

        public EbDataColumn(string columnname, Type type)
        {
            this.ColumnName = columnname;
            this.Type = type;
        }

        public EbDataColumn(int index, string columnname, Type type)
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
        public Type Type { get; set; }
    }

    [ProtoBuf.ProtoContract]
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
    }
}
