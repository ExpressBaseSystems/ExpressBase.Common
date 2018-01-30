using ExpressBase.Common.Data.MongoDB;
using ExpressBase.Common.Messaging;
using System;

namespace ExpressBase.Common.Data
{
    public class InfraDbFactory : IEbInfraDbFactory
    {
        public IDatabase ObjectsDB { get; private set; }

        public IDatabase DataDB { get; private set; }

        public IDatabase DataDBRO { get; private set; }

        public INoSQLDatabase FilesDB { get; private set; }

        public IDatabase LogsDB { get; private set; }

        public ISMSService SMSService { get; private set; }

        private EbSolutionConnections _config = null;

        private EbSolutionConnections EbSolutionConnections
        {
            get
            {
                if (_config == null)
                {
                    _config = new EbSolutionConnections
                    {
                        DataDbConnection = new Connections.EbDataDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT))
                        },
                        LogsDbConnection = new Connections.EbLogsDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT))
                        },
                        FilesDbConnection = new Connections.EbFilesDbConnection
                        {
                            FilesDbVendor = FilesDbVendors.MongoDB,
                            FilesDB_url = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_FILES_DB_URL)
                        }
                    };
                }

                return _config;
            }
        }

        //Call from ServiceStack
        public InfraDbFactory()
        {
            DataDB = new PGSQLDatabase(this.EbSolutionConnections.DataDbConnection);

            LogsDB = new PGSQLDatabase(this.EbSolutionConnections.LogsDbConnection);

            FilesDB = new MongoDBDatabase(this.EbSolutionConnections.FilesDbConnection);

            //if (_config.SMSConnection != null)
            //    SMSService = new TwilioService(this.EbSolutionConnections.SMSConnection);
        }
    }
}
