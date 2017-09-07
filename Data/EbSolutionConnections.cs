using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class EbSolutionConnections
    {
        public string SolutionId { get; set; }

        public EbTiers EbTier { get; set; }

        public EbObjectsDbConnection ObjectsDbConnection { get; set; }

        public EbDataDbConnection DataDbConnection { get; set; }

        public EbFilesDbConnection EbFilesDbConnection { get; set; }

        public EbLogsDbConnection LogsDbConnection { get; set; }

        public SMTPConnection EmailConnection { get; set; }

        public SMSConnection SMSConnection { get; set; }
    }

    public interface ITenantDbFactory { }
}
