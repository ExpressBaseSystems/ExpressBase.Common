using ExpressBase.Common;
using ExpressBase.Common.Data;
using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Scheduler.Jobs
{
    public class EbTask
    {
        public string Name { get; set; }

        public string Expression { get; set; }

        public JobTypes JobType { get; set; }

        public EbJobArguments JobArgs { get; set; }

    }

    public class EbSchedule
    {
        public int Id { get; set; }

        public string Name { get; set; }

        public EbTask Task { get; set; }

        public string CreatedBy { get; set; }

        public DateTime CreatedAt { get; set; }

        public string JobKey { get; set; }

        public string TriggerKey { get; set; }

        public ScheduleStatuses Status { get; set; }
    }
}
