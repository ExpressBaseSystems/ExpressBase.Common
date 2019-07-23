using ExpressBase.Common.Connections;
using ExpressBase.Common.Messaging;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    //public class EbConnectionsConfig
    //{
    //    //public EbConnectionsConfig()
    //    //{
    //    //}

    //    //public EbConnectionsConfig(EbConnectionsConfig config)
    //    //{
    //    //    this.SolutionId = config.SolutionId;

    //    //    this.ObjectsDbConnection = config.ObjectsDbConnection;
    //    //    this.ObjectsDbROConnection = config.ObjectsDbROConnection;

    //    //    this.DataDbConnection = config.DataDbConnection;

    //    //    this.DataDbRWConnection = config.DataDbRWConnection;
    //    //    this.DataDbROConnection = config.DataDbROConnection;

    //    //    this.EmailConnections = config.EmailConnections;

    //    //    this.FilesDbConnection = config.FilesDbConnection;

    //    //    this.LogsDbConnection = config.LogsDbConnection;

    //    //    this.SMSConnections = config.SMSConnections;
    //    //}

    //    public string SolutionId { get; set; }

    //    public EbTiers EbTier { get; set; }

    //    public EbObjectsDbConnection ObjectsDbConnection { get; set; }

    //    public EbDataDbConnection DataDbConnection { get; set; }

    //    public EbObjectsDbConnection ObjectsDbRWConnection { get; set; }

    //    public EbDataDbConnection DataDbRWConnection { get; set; }

    //    public EbObjectsDbConnection ObjectsDbROConnection { get; set; }

    //    public EbDataDbConnection DataDbROConnection { get; set; }

    //    public EbFilesDbConnection FilesDbConnection { get; set; }

    //    public EbLogsDbConnection LogsDbConnection { get; set; }

    //    public EbMailConCollection EmailConnections { get; set; }

    //    public EbSmsConCollection SMSConnections { get; set; }

    //    public EbCloudinaryConnection CloudinaryConnection { get; set; }

    //    public EbFTPConnection FTPConnection { get; set; }

    //}
    public class EbConnectionsConfig
    {
        public string SolutionId { get; set; }

        public EbDbConfig ObjectsDbConfig { get; set; }

        public EbDbConfig DataDbConfig { get; set; }

        public FilesConfigCollection FilesDbConfig { get; set; }

        public EbDbConfig LogsDbConfig { get; set; }

        public EmailConfigCollection EmailConfigs { get; set; }

        public SmsConfigCollection SMSConfigs { get; set; }

        public CloudinaryConfigCollection CloudinaryConfigs { get; set; }

        public MapConfigCollection MapConfigs { get; set; }
    }

    public class FilesConfigCollection
    {
        public List<EbIntegrationConf> Integrations { get; set; }

        public int DefaultConId { get; set; }

        public FilesConfigCollection()
        {
            this.Integrations = new List<EbIntegrationConf>();
        }
    }

    public class EmailConfigCollection
    {
        public EbEmailConfig Primary { get; set; }

        public EbEmailConfig FallBack { get; set; }
    }

    public class SmsConfigCollection
    {
        public EbSmsConfig Primary { get; set; }

        public EbSmsConfig FallBack { get; set; }
    }

    public class CloudinaryConfigCollection : List<EbCloudinaryConfig>
    {

    }

    public class MapConfigCollection
    {
        public List<EbMapConfig> Integrations { get; set; }

        public int DefaultConId { get; set; }

        public MapConfigCollection()
        {
            this.Integrations = new List<EbMapConfig>();
        }
    }

}
