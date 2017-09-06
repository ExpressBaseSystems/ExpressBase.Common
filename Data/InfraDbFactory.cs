using ExpressBase.Common;
using ExpressBase.Data;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public interface IInfraDbFactory
    {

    }

    public class InfraDbFactory : IInfraDbFactory
    {
        private IEbConf _config;

        private IDatabase _InfraDB = null;
        private IDatabase _LogsDatabase = null;

        public IDatabase InfraDB { get { return _InfraDB; } }

        public IDatabase LogsDB { get { return _LogsDatabase; } }

        public InfraDbFactory(IEbConf config)
        {
            _config = config;
            InitDatabases();
        }

        private void InitDatabases()
        {
            foreach (EbDatabaseConfiguration dbconf in _config.DatabaseConfigurations.Values)
            {
                var databaseType = dbconf.DatabaseVendor;

                switch (databaseType)
                {
                    case DatabaseVendors.PGSQL:
                        if (dbconf.EbDatabaseType == EbConnectionTypes.EbINFRA)
                            _InfraDB = new PGSQLDatabase(dbconf);
                        if (dbconf.EbDatabaseType == EbConnectionTypes.EbINFRA_LOGS)
                            _InfraDB = new PGSQLDatabase(dbconf);
                        break;
                    default:
                        throw new NotImplementedException();
                }
            }
        }
    }
}

