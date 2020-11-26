using ExpressBase.Common.Connections;
using ExpressBase.Common.Constants;
using ExpressBase.Common.Data.FTP;
using ExpressBase.Common.Data.MongoDB;
using ExpressBase.Common.Data.MSSQLServer;
using ExpressBase.Common.Integrations;
using ExpressBase.Common.LocationNSolution;
using ExpressBase.Common.Messaging;
using ExpressBase.Common.Messaging.Slack;
//using ExpressBase.Common.Messaging.ExpertTexting;
//using ExpressBase.Common.Messaging.Twilio;
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

        public Dictionary<int, IDatabase> SupportingDataDB { get; private set; }

        public IDatabase ObjectsDB { get; private set; }

        public IDatabase ObjectsDBRO { get; private set; }

        public IDatabase ObjectsDBRW { get; private set; }

        public FilesCollection FilesDB { get; private set; }

        public IDatabase LogsDB { get; private set; }

        public EbMailConCollection EmailConnection { get; private set; }

        public EbSmsConCollection SMSConnection { get; private set; }

        public List<IImageManipulate> ImageManipulate { get; private set; }

        public ChatConCollection ChatConnection { get; private set; }

        public EbMapConCollection MapConnection { get; private set; }

        public MobileAppConnection MobileAppConnection { get; private set; }

        public IFTP FTP { get; private set; }

        private RedisManagerPool RedisManager { get; set; }

        private RedisClient Redis { get; set; }

        private string SolutionId { get; set; }

        private SolutionType SolutionType { get; set; }

        private string RouterSolution { get; set; }

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
                    {
                        if (this.Redis == null && RedisManager != null)
                            using (this.Redis = this.RedisManager.GetClient() as RedisClient)
                            {
                                _connections = this.Redis.Get<EbConnectionsConfig>(string.Format(CoreConstants.SOLUTION_INTEGRATION_REDIS_KEY, this.SolutionId));
                            }
                        else
                        {
                            _connections = this.Redis.Get<EbConnectionsConfig>(string.Format(CoreConstants.SOLUTION_INTEGRATION_REDIS_KEY, this.SolutionId));
                        }
                    }

                }

                return _connections;
            }

            set
            {
                _connections = value;
            }
        }

        private EbMasterConnectionsConfig _masterConnections = null;
        private EbMasterConnectionsConfig MasterConnections
        {
            get
            {
                if (_masterConnections == null && !string.IsNullOrEmpty(this.SolutionId))
                {
                    try
                    {
                        if (this.Redis == null && RedisManager != null)
                            this.Redis = this.RedisManager.GetClient() as RedisClient;

                        //  Eb_Solution s_obj = this.Redis.Get<Eb_Solution>(String.Format("solution_{0}", this.SolutionId));
                        if (this.SolutionType == SolutionType.REPLICA && !string.IsNullOrEmpty(this.RouterSolution))
                        {
                            Console.WriteLine("Replica solution" + this.SolutionId + " of " + this.RouterSolution + " found.");
                            EbConnectionsConfig master = this.Redis.Get<EbConnectionsConfig>(string.Format(CoreConstants.SOLUTION_INTEGRATION_REDIS_KEY, this.RouterSolution));
                            _masterConnections = new EbMasterConnectionsConfig(master);
                        }
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message + e.StackTrace);
                    }
                }
                return _masterConnections;
            }

            set
            {
                _masterConnections = value;
            }
        }

        //ProductionDB
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
                    //string _userName = Connections.DataDbConfig.UserName;
                    //string _passWord = Connections.DataDbConfig.Password;

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
            {
                this.SolutionId = HostContext.RequestContext.Items[CoreConstants.SOLUTION_ID].ToString();
                Console.WriteLine("*** HostContext - SOLUTION_ID : " + HostContext.RequestContext.Items[CoreConstants.SOLUTION_ID].ToString());
            }

            if (string.IsNullOrEmpty(this.SolutionId))
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");

            this.RedisManager = c.Resolve<IRedisClientsManager>() as RedisManagerPool;
            this.Redis = this.RedisManager.GetClient() as RedisClient;
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
            this.SupportingDataDB = null;
            this.FilesDB = null;
            this.LogsDB = null;
            this.ChatConnection = null;
            this.SMSConnection = null;
            this.EmailConnection = null;
            this.ImageManipulate = null;
            this.MapConnection = null;
            this._connections = null;
            this.Connections = null;
            this._masterConnections = null;
            this.MasterConnections = null;
            this.SolutionId = null;
            this.MobileAppConnection = null;
        }

        private void InitDatabases()
        {
            Console.WriteLine("Initialising Connections");

            // the code that you want to measure comes here

            if (this.Redis != null)
            {
                Eb_Solution s_obj = this.Redis.Get<Eb_Solution>(String.Format("solution_{0}", this.SolutionId));
                if (s_obj != null)
                {
                    this.SolutionType = s_obj.SolutionType;
                    this.RouterSolution = s_obj.PrimarySolution;
                }
            }
            if (this.Connections != null)
            {
                string _userName = string.Empty;
                string _passWord = string.Empty;

                // DATA DB 
                if (Connections.DataDbConfig != null)
                {
                    _userName = Connections.DataDbConfig.UserName;
                    _passWord = Connections.DataDbConfig.Password;

                    if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        DataDB = new PGSQLDatabase(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        DataDB = new OracleDB(Connections.DataDbConfig);
                    else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        DataDB = new MySqlDB(Connections.DataDbConfig);
                    DataDB.ConId = Connections.DataDbConfig.Id;
                    // DATA DB RO
                    if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadOnlyUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadOnlyPassword)))
                    {
                        Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadOnlyUserName;
                        Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadOnlyPassword;
                        if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                            DataDBRO = new PGSQLDatabase(Connections.DataDbConfig);
                        else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                            DataDBRO = new OracleDB(Connections.DataDbConfig);
                        else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                            DataDBRO = new MySqlDB(Connections.DataDbConfig);
                    }
                    else if (DataDBRO == null)
                        DataDBRO = DataDB;

                    // DATA DB RW
                    if (!(string.IsNullOrEmpty(Connections.DataDbConfig.ReadWriteUserName) || string.IsNullOrEmpty(Connections.DataDbConfig.ReadWritePassword)))
                    {
                        Connections.DataDbConfig.UserName = Connections.DataDbConfig.ReadWriteUserName;
                        Connections.DataDbConfig.Password = Connections.DataDbConfig.ReadWritePassword;
                        if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                            DataDBRW = new PGSQLDatabase(Connections.DataDbConfig);
                        else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                            DataDBRW = new OracleDB(Connections.DataDbConfig);
                        else if (Connections.DataDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                            DataDBRW = new MySqlDB(Connections.DataDbConfig);
                    }
                    else if (DataDBRW == null)
                        DataDBRW = DataDB;

                    if (Connections.ObjectsDbConfig == null)
                    {
                        Connections.DataDbConfig.UserName = _userName;
                        Connections.DataDbConfig.Password = _passWord;
                        Connections.ObjectsDbConfig = Connections.DataDbConfig;
                    }
                }
                else
                {
                    throw new Exception("No Data DB Integrated!");
                }

                //Supporting DataDB
                if (Connections.SupportingDataDbConfig != null && Connections.SupportingDataDbConfig.Count > 0)
                {
                    if (SupportingDataDB == null)
                        SupportingDataDB = new Dictionary<int, IDatabase>();
                    for (int i = 0; i < Connections.SupportingDataDbConfig.Count; i++)
                    {
                        if (Connections.SupportingDataDbConfig[i].DatabaseVendor == DatabaseVendors.PGSQL)
                            SupportingDataDB.Add(Connections.SupportingDataDbConfig[i].Id, new PGSQLDatabase(Connections.SupportingDataDbConfig[i]));
                        else if (Connections.SupportingDataDbConfig[i].DatabaseVendor == DatabaseVendors.ORACLE)
                            SupportingDataDB.Add(Connections.SupportingDataDbConfig[i].Id, new OracleDB(Connections.SupportingDataDbConfig[i]));
                        else if (Connections.SupportingDataDbConfig[i].DatabaseVendor == DatabaseVendors.MYSQL)
                            SupportingDataDB.Add(Connections.SupportingDataDbConfig[i].Id, new MySqlDB(Connections.SupportingDataDbConfig[i]));
                        else if (Connections.SupportingDataDbConfig[i].DatabaseVendor == DatabaseVendors.MSSQL)
                            SupportingDataDB.Add(Connections.SupportingDataDbConfig[i].Id, new MSSQLDatabase(Connections.SupportingDataDbConfig[i]));
                    }
                }

                //OBJECTS DB

                if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                    ObjectsDB = new PGSQLDatabase(Connections.ObjectsDbConfig);
                else if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                    ObjectsDB = new OracleDB(Connections.ObjectsDbConfig);
                else if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                    ObjectsDB = new MySqlDB(Connections.ObjectsDbConfig);

                // OBJECTS DB RO
                if (!(string.IsNullOrEmpty(Connections.ObjectsDbConfig.ReadOnlyUserName) || string.IsNullOrEmpty(Connections.ObjectsDbConfig.ReadOnlyPassword)))
                {
                    Connections.ObjectsDbConfig.UserName = Connections.ObjectsDbConfig.ReadOnlyUserName;
                    Connections.ObjectsDbConfig.Password = Connections.ObjectsDbConfig.ReadOnlyPassword;
                    if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        ObjectsDBRO = new PGSQLDatabase(Connections.ObjectsDbConfig);
                    else if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        ObjectsDBRO = new OracleDB(Connections.ObjectsDbConfig);
                    else if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        ObjectsDBRO = new MySqlDB(Connections.ObjectsDbConfig);
                }
                else if (ObjectsDBRO == null)
                    ObjectsDBRO = ObjectsDB;

                // OBJECTS DB RW
                if (!(string.IsNullOrEmpty(Connections.ObjectsDbConfig.ReadWriteUserName) || string.IsNullOrEmpty(Connections.ObjectsDbConfig.ReadWritePassword)))
                {
                    Connections.ObjectsDbConfig.UserName = Connections.ObjectsDbConfig.ReadWriteUserName;
                    Connections.ObjectsDbConfig.Password = Connections.ObjectsDbConfig.ReadWritePassword;
                    if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.PGSQL)
                        ObjectsDBRW = new PGSQLDatabase(Connections.ObjectsDbConfig);
                    else if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.ORACLE)
                        ObjectsDBRW = new OracleDB(Connections.ObjectsDbConfig);
                    else if (Connections.ObjectsDbConfig.DatabaseVendor == DatabaseVendors.MYSQL)
                        ObjectsDBRW = new MySqlDB(Connections.ObjectsDbConfig);
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
                    Console.WriteLine("No files Db. set :" + Connections.DataDbConfig.DatabaseName);
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
                        {
                            FilesDB.Add(new PGSQLFileDatabase(Connections.FilesDbConfig.Integrations[i] as PostgresConfig));
                            Console.WriteLine("Postgres Files Db found:" + (Connections.FilesDbConfig.Integrations[i] as PostgresConfig).DatabaseName);
                        }
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.ORACLE)
                            FilesDB.Add(new OracleFilesDB(Connections.FilesDbConfig.Integrations[i] as OracleConfig));
                        else if (Connections.FilesDbConfig.Integrations[i].Type == EbIntegrations.MYSQL)
                            FilesDB.Add(new MySQLFilesDB(Connections.FilesDbConfig.Integrations[i] as MySqlConfig));
                        if (Connections.FilesDbConfig.DefaultConId == Connections.FilesDbConfig.Integrations[i].Id)
                            IsDefaultConIdCorrect = true;
                        Console.WriteLine("Files Db. set :" + Connections.FilesDbConfig.Integrations[i].Type + Connections.FilesDbConfig.Integrations[i].NickName);
                    }
                    if (IsDefaultConIdCorrect)
                        FilesDB.DefaultConId = Connections.FilesDbConfig.DefaultConId;
                    else
                        throw new Exception("DefaultConId doesn't found in the files-config list..!!");
                }
                Console.WriteLine("Files DB Collection Count(Init DB) : " + FilesDB.Count);

                ChatConnection = new ChatConCollection();
                //if (Connections.ChatConfigs == null)
                //    Connections.ChatConfigs = new ChatConfigCollection();
                if (Connections.ChatConfigs != null)
                {
                    ChatConnection.Default = new EbSlack(Connections.ChatConfigs.Default as EbSlackConfig);
                    for (int i = 0; i < Connections.ChatConfigs.Fallback.Count; i++)
                    {
                        if (Connections.ChatConfigs.Fallback[i].Type == EbIntegrations.Slack)
                            ChatConnection.Add(new EbSlack(Connections.ChatConfigs.Fallback[i] as EbSlackConfig));
                        if (Connections.ChatConfigs.Default.Id == Connections.ChatConfigs.Fallback[i].Id)
                            IsDefaultConIdCorrect = true;
                    }
                    if (IsDefaultConIdCorrect)
                        ChatConnection.Default = new EbSlack(Connections.ChatConfigs.Default as EbSlackConfig);
                    else
                        throw new Exception("DefaultConId doesn't found in the files-config list..!!");
                }
                Console.WriteLine("Chat connection Collection Count(Init DB) : " + ChatConnection.Count);


                //EmailConfigs
                if (Connections.EmailConfigs != null)
                {
                    EmailConnection = new EbMailConCollection(Connections.EmailConfigs);
                }
                else if (this.SolutionType == SolutionType.REPLICA && MasterConnections != null && MasterConnections.EmailConfigs != null)
                {
                    EmailConnection = new EbMailConCollection(MasterConnections.EmailConfigs);
                }

                //SmsConfigs
                if (Connections.SMSConfigs != null)
                {
                    SMSConnection = new EbSmsConCollection(Connections.SMSConfigs);
                }
                else if (this.SolutionType == SolutionType.REPLICA && MasterConnections != null && MasterConnections.SMSConfigs != null)
                {
                    SMSConnection = new EbSmsConCollection(MasterConnections.SMSConfigs);
                }


                //if (Connections.ChatConfigs != null)
                //{
                //    ChatConnection = new ChatCollection(Connections.ChatConfigs);
                //}

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

                if (Connections.MobileConfig != null)
                {
                    MobileAppConnection = new MobileAppConnection(Connections.MobileConfig);
                }
                else if (this.SolutionType == SolutionType.REPLICA && MasterConnections != null && MasterConnections.MobileConfig != null)
                {
                    MobileAppConnection = new MobileAppConnection(MasterConnections.MobileConfig);
                }

                //if (Connections.FTPConnection != null)
                //    FTP = new EbFTP(Connections.FTPConnection);

            }
            else
                throw new Exception("Fatal Error :: Connection is null or Empty! . Solnname = " + SolutionId);

            Console.WriteLine("Connections Initialised Successfully");
        }
    }
}
