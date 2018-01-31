using ExpressBase.Common.Connections;
using ExpressBase.Common.Constants;
using ExpressBase.Common.Data.MongoDB;
using ExpressBase.Common.Messaging;
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

        public ISMSConnection SMSConnection { get; private set; }

        public SMTPConnection SMTPConnection { get; private set; }

        private RedisClient Redis { get; set; }

        private string TenantId { get; set; }

        private ILog Logger { get { return LogManager.GetLogger(GetType()); } }

        private EbConnections _connections = null;
        private EbConnections Connections
        {
            get
            {
                if (_connections == null && !string.IsNullOrEmpty(this.TenantId))
                {
                    if (this.TenantId == CoreConstants.EXPRESSBASE)
                        _connections = InfraConnections;
                    else
                        _connections = this.Redis.Get<EbConnections>(string.Format(CoreConstants.SOLUTION_CONNECTION_REDIS_KEY, this.TenantId));
                }

                return _connections;
            }
        }

        private static EbConnections _infraConnections = null;
        private static EbConnections InfraConnections
        {
            get
            {
                if (_infraConnections == null)
                {
                    _infraConnections = new EbConnections
                    {
                        ObjectsDbConnection = new Connections.EbObjectsDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT))
                        },
                        DataDbConnection = new Connections.EbDataDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT))
                        },
                        LogsDbConnection = new Connections.EbLogsDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT))
                        },
                        FilesDbConnection = new Connections.EbFilesDbConnection
                        {
                            FilesDbVendor = FilesDbVendors.MongoDB,
                            FilesDB_url = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_FILES_DB_URL)
                        }
                        //ADD EMAIL & SMS etc
                    };
                }

                return _infraConnections;
            }
        }

        public EbConnectionFactory(string tenantId, IRedisClient redis)
        {
            this.TenantId = tenantId;
            if (string.IsNullOrEmpty(this.TenantId))
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");

            this.Redis = redis as RedisClient;

            InitDatabases();
        }

        //Call from ServiceStack
        public EbConnectionFactory(Container c)
        {
            this.TenantId = CoreConstants.EXPRESSBASE; // REMOVE DANGER

            if (HostContext.RequestContext.Items.Contains(CoreConstants.SOLUTION_ID)) // check the security issue
                this.TenantId = HostContext.RequestContext.Items[CoreConstants.SOLUTION_ID].ToString();

            if (string.IsNullOrEmpty(this.TenantId))
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");

            this.Redis = c.Resolve<IRedisClientsManager>().GetClient() as RedisClient;

            InitDatabases();
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
                if (Connections.DataDbConnection != null && Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                    DataDBRO = new PGSQLDatabase(Connections.DataDbConnection);
                else if (Connections.DataDbConnection != null && Connections.DataDbConnection.DatabaseVendor == DatabaseVendors.ORACLE)
                    DataDBRO = new OracleDB(Connections.DataDbConnection);

                // LOGS DB
                LogsDB = new PGSQLDatabase(InfraConnections.LogsDbConnection);

                if (Connections.FilesDbConnection != null)
                    FilesDB = new MongoDBDatabase(this.TenantId, Connections.FilesDbConnection);
                else
                    FilesDB = new MongoDBDatabase(this.TenantId, InfraConnections.FilesDbConnection);

                //if (Connections.SMTPConnection != null)
                //    SMTPConnection = new EmailService(Connections.SMTPConnection);

                if (Connections.SMSConnection != null)
                    SMSConnection = new TwilioService(Connections.SMSConnection);
            }
            else
                throw new Exception("Fatal Error :: Solution Id is null or Empty!");
        }
    }
}
