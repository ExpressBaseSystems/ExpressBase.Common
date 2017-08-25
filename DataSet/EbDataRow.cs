using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    public class EbDataRow : List<object>
    {
        internal RowColletion Rows { get; set; }

        private EbDataRow() { }

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
                return (index > -1) ? base[index] : null;
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
