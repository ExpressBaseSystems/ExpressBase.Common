using ServiceStack.Text;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    [RuntimeSerializable]
    public class EbDataSet
    {
        [ProtoBuf.ProtoMember(1)]
        public TableColletion Tables { get; set; }

        public DateTime StartTime { get; set; }

        public DateTime EndTime { get; set; }

        public string RowNumbers { get; set; }

        public EbDataSet()
        {
            //if (this.Tables == null) //Hack for deserialization issue Tables nullified by constructor call.. Need neater fix.
                this.Tables = new TableColletion(this);
        }
    }
}
