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

namespace ExpressBase.Common.Data
{
    public class EbConnectionFactory : IEbConnectionFactory
    {
        public IDatabase ObjectsDB { get; private set; }

        public IDatabase DataDB { get; private set; }

        public IDatabase DataDBRO { get; private set; }

        public INoSQLDatabase FilesDB { get; private set; }

        public IDatabase LogsDB { get; private set; }

        public EbSmtp Smtp { get; private set; }

        public EbSmsConCollection SMSConnection { get; private set; }

        public IImageManipulate ImageManipulate { get; private set; }

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
                        _connections = this.Redis.Get<EbConnectionsConfig>(string.Format(CoreConstants.SOLUTION_CONNECTION_REDIS_KEY, this.SolutionId));
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
                //OBJECTS DB
                if (Connections.ObjectsDbConnection != null && Connections.ObjectsDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                    ObjectsDB = new PGSQLDatabase(Connections.ObjectsDbConnection);
                else if (Connections.ObjectsDbConnection != null && Connections.ObjectsDbConnection.DatabaseVendor == DatabaseVendors.ORACLE)
                    ObjectsDB = new OracleDB(Connections.ObjectsDbConnection);

                // DATA DB 
                if (Connections.DataDbConnection != null && Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                    DataDB = new PGSQLDatabase(Connections.DataDbConnection);
                else if (Connections.DataDbConnection != null && Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.ORACLE)
                    DataDB = new OracleDB(Connections.DataDbConnection);

                // DATA DB RO
                if (Connections.DataDbROConnection != null && Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                    DataDBRO = new PGSQLDatabase(Connections.DataDbConnection);
                else if (Connections.DataDbROConnection != null && Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.ORACLE)
                    DataDBRO = new OracleDB(Connections.DataDbConnection);

                // LOGS DB
                LogsDB = new PGSQLDatabase(EbConnectionsConfigProvider.InfraConnections.LogsDbConnection);


                //Files DB
                //if (Connections.FilesDbConnection != null)
                //{
                //    if (Connections.FilesDbConnection.FilesDbVendor == FilesDbVendors.MongoDB)
                //        FilesDB = new MongoDBDatabase(this.SolutionId, Connections.FilesDbConnection);
                //    else if (Connections.FilesDbConnection.FilesDbVendor == FilesDbVendors.PGSQL)
                //        FilesDB = new PGSQLFileDatabase(Connections.FilesDbConnection);
                //    else if (Connections.FilesDbConnection.FilesDbVendor == FilesDbVendors.ORACLE)
                //        FilesDB = new OracleFilesDB(Connections.FilesDbConnection);
                //}
                //else
                //{
                if (Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                    FilesDB = new PGSQLFileDatabase(Connections.DataDbConnection);
                else if (Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.ORACLE)
                    FilesDB = new OracleFilesDB(Connections.DataDbConnection);
                //}
                if (Connections.SMTPConnection != null)
                    Smtp = new EbSmtp(Connections.SMTPConnection);

                if (Connections.SMSConnections != null)
                {
                    Connections.SMSConnections.Process();
                    SMSConnection = Connections.SMSConnections;
                }


                if (Connections.CloudinaryConnection != null)
                    ImageManipulate = new EbCloudinary(Connections.CloudinaryConnection);

                if (Connections.FTPConnection != null)
                    FTP = new EbFTP(Connections.FTPConnection);

            }
            else
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");
        }
    }
}
