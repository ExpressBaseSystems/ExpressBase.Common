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

        public EbFilesDbConnection FilesDbConnection { get; set; }

        public EbLogsDbConnection LogsDbConnection { get; set; }

        public SMTPConnection SMTPConnection { get; set; }

        public SMSConnection SMSConnection { get; set; }
    }

    public interface ITenantDbFactory
    {
        IDatabase ObjectsDB { get; }

        IDatabase DataDB { get; }

        IDatabase DataDBRO { get; }

        INoSQLDatabase FilesDB { get; }

        IDatabase LogsDB { get; }
    }
}
