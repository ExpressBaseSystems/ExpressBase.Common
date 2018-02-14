using ExpressBase.Common;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Structures;
using Npgsql;
using Npgsql.Schema;
using System;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.Common;
using System.Data.OracleClient;
using System.Net.Sockets;

namespace ExpressBase.Common
{
    public class PGSQLDatabase : IDatabase
    {
        private const string CONNECTION_STRING_BARE = "Host={0}; Port={1}; Database={2}; Username={3}; Password={4}; SSL Mode=Require; Use SSL Stream=true; Trust Server Certificate=true; Pooling=true; CommandTimeout={5};";
        private string _cstr;
        private EbBaseDbConnection EbBaseDbConnection { get; set; }

        public PGSQLDatabase(EbBaseDbConnection dbconf)
        {
            this.EbBaseDbConnection = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port, this.EbBaseDbConnection.DatabaseName, this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password, this.EbBaseDbConnection.Timeout);
        }

        public DbConnection GetNewConnection(string dbName)
        {
            return new NpgsqlConnection(string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port, dbName, this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password, this.EbBaseDbConnection.Timeout));
        }

        public DbConnection GetNewConnection()
        {
            return new NpgsqlConnection(_cstr);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new NpgsqlCommand(sql, (NpgsqlConnection)con);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql,DbTransaction trans)
        {
            return new NpgsqlCommand(sql, (NpgsqlConnection)con, (NpgsqlTransaction)trans);
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbType type, object value)
        {
            return new NpgsqlParameter(parametername, (NpgsqlTypes.NpgsqlDbType)type.VendorSpecificIntCode(DatabaseVendors.PGSQL)) { Value = value };
        }    

        public T DoQuery<T>(string query, params DbParameter[] parameters)
        {
            T obj = default(T);

            using (var con = GetNewConnection() as NpgsqlConnection)
            {
                try
                {
                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                                obj = (T)reader.GetValue(0);
                        }
                    }
                }
                catch (Npgsql.NpgsqlException) { }
                catch (SocketException) { }
            }

            return obj;
        }

        public EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();

            using (var con = GetNewConnection() as NpgsqlConnection)
            {
                try
                {
                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        using (var reader = cmd.ExecuteReader())
                        {
                            this.AddColumns(dt, reader.GetColumnSchema());

                            PrepareDataTable(reader, dt);
                        }
                    }
                }
                catch (Npgsql.NpgsqlException npgse) { }
                catch(SocketException scket) { }
            }

            return dt;
        }

        public DbDataReader DoQueriesBasic(string query, params DbParameter[] parameters)
        {
            var con = GetNewConnection() as NpgsqlConnection;
            try
            {
                con.Open();
                using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                {
                    if (parameters != null && parameters.Length > 0)
                        cmd.Parameters.AddRange(parameters);

                    return cmd.ExecuteReader(CommandBehavior.CloseConnection);
                }
            }
            catch (Npgsql.NpgsqlException npgse) { }

            return null;
        }

        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();

            try
            {
                using (var reader = this.DoQueriesBasic(query, parameters))
                {
                    do
                    {
                        try
                        {
                            EbDataTable dt = new EbDataTable();
                            this.AddColumns(dt, (reader as NpgsqlDataReader).GetColumnSchema());
                            PrepareDataTable((reader as NpgsqlDataReader), dt);
                            ds.Tables.Add(dt);
                        }
                        catch (Exception ee)
                        {

                        }
                    }
                    while (reader.NextResult());
                }
            }
            catch (Npgsql.NpgsqlException npgse) { }

            return ds;
        }

        public int DoNonQuery(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as NpgsqlConnection)
            {
                try
                {
                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                      return  cmd.ExecuteNonQuery();
                    }
                }
                catch (Npgsql.NpgsqlException npgse) { }

                return 0;
            }
        }

        public void BeginTransaction()
        {
            // This is a place where you will use _mySQLDriver to begin transaction
        }

        public void RollbackTransaction()
        {
            // This is a place where you will use _mySQLDriver to rollback transaction
        }

        public void CommitTransaction()
        {
            // This is a place where you will use _mySQLDriver to commit transaction
        }

        public bool IsInTransaction()
        {
            // This is a place where you will use _mySQLDriver to check, whether you are in a transaction
            return false;
        }

        private void AddColumns(EbDataTable dt, ReadOnlyCollection<NpgsqlDbColumn> schema)
        {
            int pos = 0;
            foreach (NpgsqlDbColumn drow in schema)
            {
                string columnName = System.Convert.ToString(drow["ColumnName"]);
                EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType((Type)(drow["DataType"])));
                column.ColumnIndex = pos++;
                dt.Columns.Add(column);
            }
        }

        private DbType ConvertToDbType(Type _typ)
        {
            if (_typ == typeof(DateTime))
                return DbType.DateTime;
            else if (_typ == typeof(string))
                return DbType.String;
            else if (_typ == typeof(bool))
                return DbType.Boolean;
            else if (_typ == typeof(decimal))
                return DbType.Decimal;
            else if (_typ == typeof(int) || _typ == typeof(Int32))
                return DbType.Int32;
            else if (_typ == typeof(Int64))
                return DbType.Int64;

            return DbType.String;
        }

        private void PrepareDataTable(NpgsqlDataReader reader, EbDataTable dt)
        {
            int _fieldCount = reader.FieldCount;
            while (reader.Read())
            {
                EbDataRow dr = dt.NewDataRow();
                for (int i = 0; i < _fieldCount; i++)
                {
                    var _typ = reader.GetFieldType(i);
                    if (_typ == typeof(DateTime))
                    {
                        dr[i] = reader.IsDBNull(i) ? DateTime.Now: reader.GetDateTime(i);
                        continue;
                    }
                    else if (_typ == typeof(string))
                    {
                        dr[i] = reader.IsDBNull(i) ? string.Empty : reader.GetString(i);
                        continue;
                    }
                    else if (_typ == typeof(bool))
                    {
                        dr[i] = reader.IsDBNull(i) ? false : reader.GetBoolean(i);
                        continue;
                    }
                    else if (_typ == typeof(decimal))
                    {
                        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetDecimal(i);
                        continue;
                    }
                    else if (_typ == typeof(int) || _typ == typeof(Int32))
                    {
                        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetInt32(i);
                        continue;
                    }
                    else if (_typ == typeof(Int64))
                    {
                        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetInt64(i);
                        continue;
                    }
                    else
                    {
                        dr[i] = reader.GetValue(i);
                        continue;
                    }
                }

                dt.Rows.Add(dr);
            }
        }

        //-----------Sql queries

        public string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM eb_authenticate_unified(uname => @uname, password => @pass, wc => @wc);"; } }

        public string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM eb_authenticate_unified(social => @social, wc => @wc);"; } }

        public string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM eb_authenticate_unified(uname => @uname, wc => @wc);"; } }

        
    }
}

