using ExpressBase.Common.Connections;

namespace ExpressBase.Common.Data
{
    public class EbConnectionsConfig
    {
        public string SolutionId { get; set; }

        public EbTiers EbTier { get; set; }

        public EbObjectsDbConnection ObjectsDbConnection { get; set; }

        public EbDataDbConnection DataDbConnection { get; set; }

        public EbObjectsDbConnection ObjectsDbRWConnection { get; set; }

        public EbDataDbConnection DataDbRWConnection { get; set; }

        public EbObjectsDbConnection ObjectsDbROConnection { get; set; }

        public EbDataDbConnection DataDbROConnection { get; set; }

        public EbFilesDbConnection FilesDbConnection { get; set; }

        public EbLogsDbConnection LogsDbConnection { get; set; }

        public SMTPConnection SMTPConnection { get; set; }

        public SMSConnection SMSConnection { get; set; }

        public ImageManipulateConnection ImageManipulateConnection { get; set; }
    }
}
