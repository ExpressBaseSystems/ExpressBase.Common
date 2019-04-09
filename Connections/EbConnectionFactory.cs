using ExpressBase.Common.Connections;
using ExpressBase.Common.Constants;
using ExpressBase.Common.Data.FTP;
using ExpressBase.Common.Data.MongoDB;
using ExpressBase.Common.Integrations;
using ExpressBase.Common.Messaging;
using ExpressBase.Common.Messaging.ExpertTexting;
using ExpressBase.Common.Messaging.Twilio;
using Funq;
using ServiceStack;
using ServiceStack.Logging;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public class EbConnectionFactory : IEbConnectionFactory
    {
        public IDatabase DataDB { get; private set; }

        public IDatabase DataDBRO { get; private set; }

        public IDatabase DataDBRW { get; private set; }

        public IDatabase ObjectsDB { get; private set; }

        public IDatabase ObjectsDBRO { get; private set; }

        public IDatabase ObjectsDBRW { get; private set; }

        public List<INoSQLDatabase> FilesDB { get; private set; }

        public IDatabase LogsDB { get; private set; }

        public EbMailConCollection EmailConnection { get; private set; }

        public EbSmsConCollection SMSConnection { get; private set; }

        public List<IImageManipulate> ImageManipulate { get; private set; }

        public IFTP FTP { get; private set; }

        private RedisClient Redis { get; set; }

        private string SolutionId { get; set; }

        private ILog Logger
        {
            get { return LogManager.GetLogger(GetType()); }
        }

        private EbConnectionsConfig _connections = null;
        private EbConnectionsConfig Connections
        {
            get
            {
                if (_connections == null && !string.IsNullOrEmpty(this.SolutionId))
                {
                    if (this.SolutionId == CoreConstants.EXPRESSBASE)
                        _connections = EbConnectionsConfigProvider.InfraConnections;
                    else
                        _connections = this.Redis.Get<EbConnectionsConfig>(string.Format(CoreConstants.SOLUTION_INTEGRATION_REDIS_KEY, this.SolutionId));
                }

                return _connections;
            }

            set
            {
                _connections = value;
            }
        }

        // RETURN EITHER INFA FAC OR SOLUTION FAC
        public EbConnectionFactory(string tenantId, IRedisClient redis)
        {
            this.SolutionId = tenantId;
            if (string.IsNullOrEmpty(this.SolutionId))
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");

            this.Redis = redis as RedisClient;

            InitDatabases();
        }

        //Call from ServiceStack
        public EbConnectionFactory(Container c)
        {
            this.SolutionId = CoreConstants.EXPRESSBASE; // REMOVE DANGER

            if (HostContext.RequestContext.Items.Contains(CoreConstants.SOLUTION_ID)) // check the security issue
                this.SolutionId = HostContext.RequestContext.Items[CoreConstants.SOLUTION_ID].ToString();

            if (string.IsNullOrEmpty(this.SolutionId))
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");

            this.Redis = c.Resolve<IRedisClientsManager>().GetClient() as RedisClient;

            InitDatabases();
        }

        // TO CREATE NEW SOLUTION DB IN DATA CENTER
        public EbConnectionFactory(EbConnectionsConfig config, string solutionId)
        {
            this.SolutionId = solutionId;
            this.Connections = config;

            InitDatabases();
        }

        ~EbConnectionFactory()
        {
            this.ObjectsDB = null;
            this.DataDB = null;
            this.DataDBRO = null;
            this.FilesDB = null;
            this.LogsDB = null;
            this.SMSConnection = null;
            this.SolutionId = null;
            this.ImageManipulate = null;
            this._connections = null;
        }

        private void InitDatabases()
        {
            if (this.Connections != null)
            {

                // DATA DB 
                if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                    DataDB = new PGSQLDatabase(Connections.DataDbConfig);
                else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                    DataDB = new OracleDB(Connections.DataDbConfig);
                else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                    DataDB = new MySqlDB(Connections.DataDbConfig);

                // DATA DB RO
                if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadOnlyUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadOnlyPassword)))
                {
                    Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadOnlyUserName;
                    Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadOnlyPassword;
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDBRO = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDBRO = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDBRO = new MySqlDB(Connections.DataDbConfig);
                }


                // DATA DB RW
                if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadWriteUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadWritePassword)))
                {
                    Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadWriteUserName;
                    Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadWritePassword;
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDBRO = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDBRO = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDBRO = new MySqlDB(Connections.DataDbConfig);
                }

                //OBJECTS DB
                if (Connections.ObjectsDbConfig == null)
                    Connections.ObjectsDbConfig = Connections.DataDbConfig;

                if (Connections.ObjectsDbConfig != null && Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                    ObjectsDB = new PGSQLDatabase(Connections.ObjectsDbConfig);
                else if (Connections.ObjectsDbConfig != null && Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                    ObjectsDB = new OracleDB(Connections.ObjectsDbConfig);
                else if (Connections.ObjectsDbConfig != null && Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                    ObjectsDB = new MySqlDB(Connections.ObjectsDbConfig);

                // OBJECTS DB RO
                if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadOnlyUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadOnlyPassword)))
                {
                    Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadOnlyUserName;
                    Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadOnlyPassword;
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDBRO = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDBRO = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDBRO = new MySqlDB(Connections.DataDbConfig);
                }


                // OBJECTS DB RW
                if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadWriteUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadWritePassword)))
                {
                    Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadWriteUserName;
                    Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadWritePassword;
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDBRO = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDBRO = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDBRO = new MySqlDB(Connections.DataDbConfig);
                }



                // LOGS DB
                LogsDB = new PGSQLDatabase(EbConnectionsConfigProvider.InfraConnections.LogsDbConnection);


                //Files DB
                FilesDB = new List<INoSQLDatabase>();

                if (Connections.FilesDbConfig == null)
                    Connections.FilesDbConfig = new FilesConfigCollection();
                if (Connections.FilesDbConfig.Count == 0)
                    Connections.FilesDbConfig.Add(Connections.DataDbConfig);
                for (int i = 0; i < Connections.FilesDbConfig.Count; i++)
                {
                    if (Connections.FilesDbConfig[i].Type == EbIntegrations.MongoDB)
                        FilesDB.Add(new MongoDBDatabase(this.SolutionId, Connections.FilesDbConfig[i] as EbMongoConfig));
                    else if (Connections.FilesDbConfig[i].Type == EbIntegrations.PGSQL)
                        FilesDB.Add(new PGSQLFileDatabase(Connections.FilesDbConfig[i] as PostgresConfig));
                    else if (Connections.FilesDbConfig[i].Type == EbIntegrations.ORACLE)
                        FilesDB.Add(new OracleFilesDB(Connections.FilesDbConfig[i] as OracleConfig));
                    //else if (Connections.FilesDbConfig[i].Type == EbIntegrations.MYSQL)
                    //    FilesDB.Add(new MySQLFilesDB(Connections.FilesDbConfig[i] as MySqlConfig));
                }

                if (Connections.EmailConfigs != null)
                {
                    EmailConnection = new EbMailConCollection(Connections.EmailConfigs);
                }
                if (Connections.SMSConfigs != null)
                {                    
                    SMSConnection = new EbSmsConCollection(Connections.SMSConfigs);
                }

                if (Connections.CloudinaryConfigs != null && Connections.CloudinaryConfigs.Count > 0)
                {
                    if (ImageManipulate == null)
                        ImageManipulate = new List<IImageManipulate>();
                    for (int i = 0; i < Connections.CloudinaryConfigs.Count; i++)
                        ImageManipulate.Add(new EbCloudinary(Connections.CloudinaryConfigs[i]));
                }
                //if (Connections.FTPConnection != null)
                //    FTP = new EbFTP(Connections.FTPConnection);

            }
            else
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");
        }
    }
}
