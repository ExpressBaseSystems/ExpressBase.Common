using ExpressBase.Common.Connections;
using ExpressBase.Common.Messaging;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public class EbConnectionsConfig
    {
        //public EbConnectionsConfig()
        //{
        //}

        //public EbConnectionsConfig(EbConnectionsConfig config)
        //{
        //    this.SolutionId = config.SolutionId;

        //    this.ObjectsDbConnection = config.ObjectsDbConnection;
        //    this.ObjectsDbROConnection = config.ObjectsDbROConnection;

        //    this.DataDbConnection = config.DataDbConnection;

        //    this.DataDbRWConnection = config.DataDbRWConnection;
        //    this.DataDbROConnection = config.DataDbROConnection;

        //    this.EmailConnections = config.EmailConnections;

        //    this.FilesDbConnection = config.FilesDbConnection;

        //    this.LogsDbConnection = config.LogsDbConnection;

        //    this.SMSConnections = config.SMSConnections;
        //}

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

        public EbMailConCollection EmailConnections { get; set; }

        public EbSmsConCollection SMSConnections { get; set; }

        public EbCloudinaryConnection CloudinaryConnection { get; set; }

        public EbFTPConnection FTPConnection { get; set; }

    }
}
