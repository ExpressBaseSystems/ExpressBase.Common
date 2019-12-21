using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.ProductionDBManager
{
    public static class DBIntegrityCollection
    {
        public static readonly DbTypeMap4IntegrityCollection DataTypeCollection = new DbTypeMap4IntegrityCollection
            {
                { "text", new DbTypeMap4Integrity { MySQLType = "text", OracleType = "to_clob({0})", SQLServerType = "text" } },
                { "bytea", new DbTypeMap4Integrity { MySQLType = "blob", OracleType = "to_blob({0})", SQLServerType = "bytea" } },
                { "\"char\"", new DbTypeMap4Integrity { MySQLType = "char", OracleType = "to_single_byte({0})", SQLServerType = "char" } },
                { "timestamp without time zone", new DbTypeMap4Integrity { MySQLType = "datetime", OracleType = "to_date({0})", SQLServerType = "timestamp without time zone" } },
                { "timestamp with time zone", new DbTypeMap4Integrity { MySQLType = "timestamp", OracleType = "to_timestamp({0})", SQLServerType = "timestamp with time zone" } },
                { "decimal", new DbTypeMap4Integrity { MySQLType = "decimal", OracleType = "to_decimal({0})", SQLServerType = "decimal" } },
                { "double precision", new DbTypeMap4Integrity { MySQLType = "double", OracleType = "to_binary_double({0})", SQLServerType = "double precision" } },
                { "smallint", new DbTypeMap4Integrity { MySQLType = "Int16", OracleType = "to_number({})", SQLServerType = "smallint" } },
                { "integer", new DbTypeMap4Integrity { MySQLType = "int", OracleType = "to_number({})", SQLServerType = "integer" } },
                { "bigint", new DbTypeMap4Integrity { MySQLType = "bigint", OracleType = "to_number({})", SQLServerType = "bigint" } },
                { "jsonb", new DbTypeMap4Integrity { MySQLType = "json", OracleType = "to_clob({0})", SQLServerType = "jsonb" } },
                { "time", new DbTypeMap4Integrity { MySQLType = "time", OracleType = "to_timestamp({0})", SQLServerType = "time" } },
                { "numeric", new DbTypeMap4Integrity { MySQLType = "decimal", OracleType = "to_number({})", SQLServerType = "numeric" } },
                { "bool", new DbTypeMap4Integrity { MySQLType = "varchar", OracleType = "to_char({0})", SQLServerType = "bool" } },
                { "character", new DbTypeMap4Integrity { MySQLType = "char", OracleType = "to_single_byte({0})", SQLServerType = "character" } },
                { "boolean", new DbTypeMap4Integrity { MySQLType = "tinyint", OracleType = "to_char({0})", SQLServerType = "boolean" } },
                { "json", new DbTypeMap4Integrity { MySQLType = "json", OracleType = "to_clob({0})", SQLServerType = "json" } },
                { "date", new DbTypeMap4Integrity { MySQLType = "date", OracleType = "", SQLServerType = "" } },
                { "varchar", new DbTypeMap4Integrity { MySQLType = "varchar", OracleType = "", SQLServerType = "" } }
            };

        public static readonly DbColumnDefaultMap4IntegrityCollection ColumnDefaultCollection = new DbColumnDefaultMap4IntegrityCollection
            {
                { "'F'::\"char\"", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "F",MySQLColumnDefault = "F", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "nextval", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "nextval",MySQLColumnDefault = "", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "'0,000.00'::text", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "0,000.00", MySQLColumnDefault = "0,000.00", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "'DD/MM/YYYY'::text", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "DD/MM/YYYY",MySQLColumnDefault = "DD/MM/YYYY", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "'UTC+05:30'::text", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "UTC+05:30",MySQLColumnDefault = "UTC+05:30", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "",MySQLColumnDefault = "", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "'F'::bpchar", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "F",MySQLColumnDefault = "F", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "false", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "false",MySQLColumnDefault = "0", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "0", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "0",MySQLColumnDefault = "0", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "'default'::text", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "default",MySQLColumnDefault = "default", OracleColumnDefault = "", SQLServerColumnDefault = "" } },
                { "1", new DbTypeMap4ColumnDefault { PgSQLColumnDefault = "1",MySQLColumnDefault = "1", OracleColumnDefault = "", SQLServerColumnDefault = "" } }
            };

        public static readonly MySQLKeywordsConvertCollection ColumnName = new MySQLKeywordsConvertCollection
            {
                { "key", "`key`"},
                { "keys", "`keys`"}
            };
    }


}
