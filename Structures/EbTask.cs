using ExpressBase.Common;
using ExpressBase.Common.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Scheduler.Jobs
{
    public class EbTask
    {
        public string Expression { get; set; }

        public JobTypes JobType { get; set; }

        public int ObjId { get; set; }

        public List<Param> Params { get; set; }

        public string SolnId { get; set; }
    }
}
