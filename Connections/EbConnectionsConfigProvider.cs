using ExpressBase.Common.Data;
using System;
using System.Collections.Generic;
using System.Text;

/// <summary>
/// Author: Suresh Bala
/// Purpose: Provide statuc connection config objects to the factory
/// Comment: CRITICAL!! Please consult with Author
/// </summary>

namespace ExpressBase.Common.Connections
{
    public static class EbConnectionsConfigProvider
    {
        private static EbConnectionsConfig _infraConnections = null;
        public static EbConnectionsConfig InfraConnections
        {
            get
            {
                if (_infraConnections == null)
                {
                    _infraConnections = new EbConnectionsConfig
                    {
                        ObjectsDbConnection = new Connections.EbObjectsDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT)),
                            IsDefault = true
                        },
                        DataDbConnection = new Connections.EbDataDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT)),
                            IsDefault = true
                        },
                        LogsDbConnection = new Connections.EbLogsDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT)),
                            IsDefault = true
                        },
                        FilesDbConnection = new Connections.EbFilesDbConnection
                        {
                            FilesDbVendor = FilesDbVendors.MongoDB,
                            FilesDB_url = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_FILES_DB_URL),
                            IsDefault = true
                        }
                        //ADD EMAIL & SMS etc
                    };
                }

                return _infraConnections;
            }
        }

        // TO CREATE NEW SOLUTION DB IN OUR DATA CENTER AND CREATE DB USERS
        private static EbConnectionsConfig _dcConnections = null;
        public static EbConnectionsConfig DataCenterConnections
        {
            get
            {
                if (_dcConnections == null)
                {
                    _dcConnections = new EbConnectionsConfig
                    {
                        ObjectsDbConnection = new Connections.EbObjectsDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_PORT)),
                            DatabaseName = "postgres", //SET IT BEFORE YOU USE
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_ADMIN_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_ADMIN_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_TIMEOUT)),
                            IsDefault = true
                        },
                        DataDbConnection = new Connections.EbDataDbConnection
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_PORT)),
                            DatabaseName = "postgres", //SET IT BEFORE YOU USE
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_ADMIN_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_ADMIN_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_DATACENTRE_TIMEOUT)),
                            IsDefault = true
                        },
                        LogsDbConnection = new Connections.EbLogsDbConnection //ALWAYS IN INFRA
                        {
                            DatabaseVendor = DatabaseVendors.PGSQL,
                            Server = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_SERVER),
                            Port = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_PORT)),
                            DatabaseName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DBNAME),
                            UserName = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_USER),
                            Password = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_RW_PASSWORD),
                            Timeout = Convert.ToInt16(Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_DB_TIMEOUT)),
                            IsDefault = true
                        },
                        FilesDbConnection = new Connections.EbFilesDbConnection //ALWAYS AS IN INFRA
                        {
                            FilesDbVendor = FilesDbVendors.MongoDB,
                            FilesDB_url = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_INFRA_FILES_DB_URL),
                            IsDefault = true
                        }
                    };
                }

                return _dcConnections;
            }
        }
    }
}
