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
    public interface IMultiTenantDbFactory { }

    public class MultiTenantDbFactory : IMultiTenantDbFactory
    {
        private IDatabase _ObjectsDB = null;
        private IDatabase _DataDatabase = null;
        private IDatabase _LogsDatabase = null;
        private IDatabase _FilesDatabase = null;
        private IDatabase _ObjectsDB_RO = null;
        private IDatabase _DataDatabase_RO = null;
        private IDatabase _LogsDatabase_RO = null;
        private IDatabase _FilesDatabase_RO = null;

        public IDatabase ObjectsDB { get { return _ObjectsDB; } }

        public IDatabase DataDB { get { return _DataDatabase; } }

        public IDatabase LogsDB { get { return _LogsDatabase; } }

        public IDatabase FilesDB { get { return _FilesDatabase; } }

        public IDatabase ObjectsDBRO { get { return _ObjectsDB_RO; } }

        public IDatabase DataDBRO { get { return _DataDatabase_RO; } }

        public IDatabase LogsDBRO { get { return _LogsDatabase_RO; } }

        public IDatabase FilesDBRO { get { return _FilesDatabase_RO; } }

        private EbClientConf _config { get; set; }

        private RedisClient Redis { get; set; }

        private InfraDbFactory InfraFactory { get; set; }

        public MultiTenantDbFactory(Container c)
        {
            this.Redis = c.Resolve<IRedisClientsManager>().GetClient() as RedisClient;
            this.InfraFactory = c.Resolve<IDatabaseFactory>() as InfraDbFactory;

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
                        var bytea = this.InfraFactory.InfraDB_RO.DoQuery<byte[]>(string.Format("SELECT config FROM eb_tenantaccount WHERE cid='{0}'", tenantId));
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

        private void InitDatabases()
        {
            foreach (EbDatabaseConfiguration dbconf in _config.DatabaseConfigurations.Values)
            {
                var databaseType = dbconf.DatabaseVendor;

                switch (databaseType)
                {
                    case DatabaseVendors.PGSQL:
                        if (dbconf.EbDatabaseType == EbDatabaseTypes.EbOBJECTS)
                            _ObjectsDB = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbDATA)
                            _DataDatabase = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbLOGS)
                            _LogsDatabase = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbFILES)
                            _FilesDatabase = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbOBJECTS_RO)
                            _ObjectsDB_RO = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbDATA_RO)
                            _DataDatabase_RO = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbLOGS_RO)
                            _LogsDatabase_RO = new PGSQLDatabase(dbconf);
                        else if (dbconf.EbDatabaseType == EbDatabaseTypes.EbFILES_RO)
                            _FilesDatabase_RO = new PGSQLDatabase(dbconf);
                        break;
                    default:
                        throw new NotImplementedException();
                }
            }
        }
    }
}
