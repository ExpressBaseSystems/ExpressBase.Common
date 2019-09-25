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
using System.Diagnostics;
using static ExpressBase.Common.MySqlDB;

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

        public FilesCollection FilesDB { get; private set; }

        public IDatabase LogsDB { get; private set; }

        public EbMailConCollection EmailConnection { get; private set; }

        public EbSmsConCollection SMSConnection { get; private set; }

        public List<IImageManipulate> ImageManipulate { get; private set; }


        public EbMapConCollection MapConnection { get; private set; }

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
                    if (this.SolutionId == CoreConstants.EXPRESSBASE || this.SolutionId == CoreConstants.ADMIN)
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

        public EbConnectionFactory(string tenantId, IRedisClient redis, bool IsDataOnly)
        {
            if (IsDataOnly)
            {
                this.SolutionId = tenantId;
                if (string.IsNullOrEmpty(this.SolutionId))
                    throw new Exception("Fatal Error :: Solution Id is null or Empty!");

                this.Redis = redis as RedisClient;
                if (this.Connections != null)
                {
                    string _userName = Connections.DataDbConfig.UserName;
                    string _passWord = Connections.DataDbConfig.Password;

                    // DATA DB 
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDB = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDB = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDB = new MySqlDB(Connections.DataDbConfig);
                }
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

            //if(SolutionId != CoreConstants.EXPRESSBASE) 
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
            this.EmailConnection = null;
            this.ImageManipulate = null;
            this.MapConnection = null;
            this._connections = null;
            this.SolutionId = null;
        }

        private void InitDatabases()
        {
            Console.WriteLine("Initialising Connections");

            Stopwatch watch = Stopwatch.StartNew();
            // the code that you want to measure comes here

            if (this.Connections != null)
            {
                string _userName = Connections.DataDbConfig.UserName;
                string _passWord = Connections.DataDbConfig.Password;

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
                else if (DataDBRO == null)
                    DataDBRO = DataDB;

                // DATA DB RW
                if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadWriteUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadWritePassword)))
                {
                    Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadWriteUserName;
                    Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadWritePassword;
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDBRW = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDBRW = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDBRW = new MySqlDB(Connections.DataDbConfig);
                }
                else if (DataDBRW == null)
                    DataDBRW = DataDB;

                //OBJECTS DB
                if (Connections.ObjectsDbConfig == null)
                {
                    Connections.DataDbConfig.UserName = _userName;
                    Connections.DataDbConfig.Password = _passWord;
                    Connections.ObjectsDbConfig = Connections.DataDbConfig;
                }
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
                        ObjectsDBRO = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        ObjectsDBRO = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        ObjectsDBRO = new MySqlDB(Connections.DataDbConfig);
                }
                else if (ObjectsDBRO == null)
                    ObjectsDBRO = ObjectsDB;

                // OBJECTS DB RW
                if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadWriteUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadWritePassword)))
                {
                    Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadWriteUserName;
                    Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadWritePassword;
                    if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        ObjectsDBRW = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        ObjectsDBRW = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig != null && Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        ObjectsDBRW = new MySqlDB(Connections.DataDbConfig);
                }
                else if (ObjectsDBRW == null)
                    ObjectsDBRW = ObjectsDB;

                // LOGS DB
                LogsDB = new PGSQLDatabase(EbConnectionsConfigProvider.InfraConnections.LogsDbConfig);


                //Files DB
                FilesDB = new FilesCollection();
                bool IsDefaultConIdCorrect = false;
                if (Connections.FilesDbConfig == null)
                    Connections.FilesDbConfig = new FilesConfigCollection();
                if (Connections.FilesDbConfig.Integrations.Count == 0)
                {
                    Connections.DataDbConfig.UserName = _userName;
                    Connections.DataDbConfig.Password = _passWord;
                    if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        FilesDB.Add(new PGSQLFileDatabase(Connections.DataDbConfig));
                    else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        FilesDB.Add(new OracleFilesDB(Connections.DataDbConfig));
                    else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        FilesDB.Add(new MySQLFilesDB(Connections.DataDbConfig));
                    FilesDB.DefaultConId = Connections.DataDbConfig.Id;
                }
                else
                {
                    for (int i = 0; i < Connections.FilesDbConfig.Integrations.Count; i++)
                    {
                        if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.MongoDB)
                            FilesDB.Add(new MongoDBDatabase(this.SolutionId, Connections.FilesDbConfig.Integrations[i] as EbMongoConfig));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.DropBox)
                            FilesDB.Add(new DropBox.DropBoxDatabase(Connections.FilesDbConfig.Integrations[i] as EbDropBoxConfig));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.AWSS3)
                            FilesDB.Add(new AWSS3.AWSS3(Connections.FilesDbConfig.Integrations[i] as EbAWSS3Config));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.GoogleDrive)
                            FilesDB.Add(new GoogleDrive.GoogleDriveDatabase(Connections.FilesDbConfig.Integrations[i] as EbGoogleDriveConfig));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.PGSQL)
                            FilesDB.Add(new PGSQLFileDatabase(Connections.FilesDbConfig.Integrations[i] as PostgresConfig));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.ORACLE)
                            FilesDB.Add(new OracleFilesDB(Connections.FilesDbConfig.Integrations[i] as OracleConfig));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.MYSQL)
                            FilesDB.Add(new MySQLFilesDB(Connections.FilesDbConfig.Integrations[i] as MySqlConfig));
                        if (Connections.FilesDbConfig.DefaultConId == Connections.FilesDbConfig.Integrations[i].Id)
                            IsDefaultConIdCorrect = true;
                    }
                    if (IsDefaultConIdCorrect)
                        FilesDB.DefaultConId = Connections.FilesDbConfig.DefaultConId;
                    else
                        throw new Exception("DefaultConId doesn't found in the files-config list..!!");
                }
                Console.WriteLine("Files DB Collection Count(Init DB) : " + FilesDB.Count);

                //EmailConfigs
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

                if (Connections.MapConfigs != null && Connections.MapConfigs.Integrations.Count > 0)
                {
                    MapConnection = new EbMapConCollection();
                    for (int i = 0; i < Connections.MapConfigs.Integrations.Count; i++)
                    {
                        if (Connections.MapConfigs.Integrations[i].Type == EbIntegrations.GoogleMap)
                            MapConnection.Add(new EbGoogleMap(Connections.MapConfigs.Integrations[i]));
                    }
                    MapConnection.DefaultConId = Connections.MapConfigs.DefaultConId;
                }
                //if (Connections.FTPConnection != null)
                //    FTP = new EbFTP(Connections.FTPConnection);

            }
            else
                throw new Exception("Fatal Error :: Connection is null or Empty! . Solnname = " + SolutionId);

            watch.Stop();
            Console.WriteLine(string.Format("Connections Initialised in {0} MilliSeconds", watch.ElapsedMilliseconds));
        }
    }
}
