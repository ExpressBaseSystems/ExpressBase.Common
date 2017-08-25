using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    public class EbDataSet
    {
        [ProtoBuf.ProtoMember(1)]
        public TableColletion Tables { get; set; }

        public EbDataSet()
        {
            this.Tables = new TableColletion(this);
        }
    }
}
