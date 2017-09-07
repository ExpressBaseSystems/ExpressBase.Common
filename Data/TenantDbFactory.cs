using ExpressBase.Common.Connections;
using ExpressBase.Common.Data;
using ExpressBase.Common.Data.MongoDB;
using ExpressBase.Data;
using Funq;
using ServiceStack;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public class EbSolutionConnections
    {
        public string SolutionId { get; set; }

        public EbTiers EbTier { get; set; }

        public EbObjectsDbConnection ObjectsDbConnection { get; set; }

        public EbDataDbConnection DataDbConnection { get; set; }

        public EbFilesDbConnection EbFilesDbConnection { get; set; }

        public EbLogsDbConnection LogsDbConnection { get; set; }

        public EmailConnection EmailConnection { get; set; }

        public SMSConnection SMSConnection { get; set; }
    }

    public interface ITenantDbFactory { }

    public class TenantDbFactory : ITenantDbFactory
    {
        public IDatabase ObjectsDB { get; private set; }

        public IDatabase DataDB { get; private set; }

        public IDatabase DataDBRO { get; private set; }

        public INoSQLDatabase FilesDB { get; private set; }

        public IDatabase LogsDB { get; private set; }

        private EbSolutionConnections _config { get; set; }

        private RedisClient Redis { get; set; }

        //Call from ServiceStack
        public TenantDbFactory(Container c)
        {
            this.Redis = c.Resolve<IRedisClientsManager>().GetClient() as RedisClient;

            var tenantId = HostContext.RequestContext.Items["TenantAccountId"];

            if (tenantId != null)
            {
                _config = this.Redis.Get<EbSolutionConnections>(string.Format("EbSolutionConnections_{0}", tenantId));

                InitDatabases();
            }
        }

        private void InitDatabases()
        {
            // CHECK IF CONNECTION IS LIVE

            if (_config.ObjectsDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                ObjectsDB = new PGSQLDatabase(_config.ObjectsDbConnection);

            if (_config.DataDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                DataDB = new PGSQLDatabase(_config.DataDbConnection);

            //To be Done
            if (_config.DataDbConnection.DatabaseVendor == DatabaseVendors.PGSQL)
                DataDBRO = new PGSQLDatabase(_config.DataDbConnection);

            FilesDB = new MongoDBDatabase(_config.EbFilesDbConnection);

            LogsDB = new PGSQLDatabase(_config.LogsDbConnection);
        }
    }
}
