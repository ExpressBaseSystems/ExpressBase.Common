using System;
using System.Collections.Generic;
using ExpressBase.Common;
using ExpressBase.Common.ProductionDBManager;

public class DbTypeMap4Integrity
{
    public string PgSQLType { get; set; }

    public string MySQLType { get; set; }

    public string SQLServerType { get; set; }

    public string OracleType { get; set; }
}


public class DbTypeMap4IntegrityCollection : Dictionary<string, DbTypeMap4Integrity>
{
    public string GetDbType(DatabaseVendors vendor, string pgsqlDbType)
    {        
        if (vendor == DatabaseVendors.MYSQL)
            return this[pgsqlDbType].MySQLType;

        if (vendor == DatabaseVendors.MSSQL)
            return this[pgsqlDbType].SQLServerType;

        if (vendor == DatabaseVendors.ORACLE)
            return this[pgsqlDbType].OracleType;

        return pgsqlDbType;
    }
}

public class DbTypeMap4ColumnDefault
{
    public string PgSQLColumnDefault { get; set; }

    public string MySQLColumnDefault { get; set; }

    public string SQLServerColumnDefault { get; set; }

    public string OracleColumnDefault { get; set; }
}

public class DbColumnDefaultMap4IntegrityCollection : Dictionary<string, DbTypeMap4ColumnDefault>
{
    public string GetColumnDefault(DatabaseVendors vendor, string pgsqlColumnDefault)
    {
        if (vendor == DatabaseVendors.PGSQL)
            return this[pgsqlColumnDefault].PgSQLColumnDefault;

        if (vendor == DatabaseVendors.MYSQL)
            return this[pgsqlColumnDefault].MySQLColumnDefault;

        if (vendor == DatabaseVendors.MSSQL)
            return this[pgsqlColumnDefault].SQLServerColumnDefault;

        if (vendor == DatabaseVendors.ORACLE)
            return this[pgsqlColumnDefault].OracleColumnDefault;

        return pgsqlColumnDefault;
    }
}

public class MySQLKeywordsConvertCollection : Dictionary<string, string>
{
    public string GetColumnName(string ColumnName)
    {
        return this[ColumnName];
    }
}