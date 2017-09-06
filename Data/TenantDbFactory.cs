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
    public interface ITenantDbFactory { }

    public class TenantDbFactory : ITenantDbFactory
    {
        private IDatabase _ObjectsDB = null;
        private IDatabase _DataDatabase = null;
        private IDatabase _DataDatabase_RO = null;
        private INoSQLDatabase _FilesDatabase = null;

        public IDatabase ObjectsDB { get { return _ObjectsDB; } }

        public IDatabase DataDB { get { return _DataDatabase; } }

        public INoSQLDatabase FilesDB { get { return _FilesDatabase; } }

        public IDatabase DataDBRO { get { return _DataDatabase_RO; } }

        private EbClientConf _config { get; set; }

        private RedisClient Redis { get; set; }

        private InfraDbFactory InfraFactory { get; set; }

        //Call from ServiceStack
        public TenantDbFactory(Container c)
        {
            this.Redis = c.Resolve<IRedisClientsManager>().GetClient() as RedisClient;
            this.InfraFactory = c.Resolve<IInfraDbFactory>() as InfraDbFactory;

            var tenantId = HostContext.RequestContext.Items["TenantAccountId"];

            if (tenantId != null)
            {
                //throw new Exception("TenantAccountId is NOT set!");

                using (this.Redis)
                {
                    string key = string.Format("EbClientConf_{0}", tenantId);

                    _config = this.Redis.Get<EbClientConf>(key);
                    if (_config == null)
                    {
                        var bytea = this.InfraFactory.InfraDB.DoQuery<byte[]>(string.Format("SELECT config FROM eb_tenantaccount WHERE cid='{0}'", tenantId));
                        if (bytea != null)
                        {
                            _config = EbSerializers.ProtoBuf_DeSerialize<EbClientConf>(bytea);
                            this.Redis.Set<EbClientConf>(key, _config);
                        }
                    }
                }

                InitDatabases();
            }
            else
            {

            }
        }

        // Dummy to remove later
        public TenantDbFactory(EbClientConf c) { }

        private void InitDatabases()
        {
            foreach (EbDatabaseConfiguration dbconf in _config.DatabaseConfigurations.Values)
            {
                var databaseType = dbconf.DatabaseVendor;

                switch (databaseType)
                {
                    case DatabaseVendors.PGSQL:
                        if (dbconf.EbDatabaseType == EbConnectionTypes.EbOBJECTS)
                            _ObjectsDB = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbConnectionTypes.EbDATA)
                            _DataDatabase = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbConnectionTypes.EbDATA_RO)
                            _DataDatabase_RO = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbConnectionTypes.EbFILES)
                            _FilesDatabase = new MongoDBDatabase(dbconf);
                        break;
                    default:
                        throw new NotImplementedException();
                }
            }
        }
    }
}
