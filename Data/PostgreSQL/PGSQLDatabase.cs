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

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql, DbTransaction trans)
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
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }
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
                            Type[] typeArray = this.AddColumns(dt, reader.GetColumnSchema());

                            PrepareDataTable(reader, dt, typeArray);
                        }
                    }
                }
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }
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
            catch (Npgsql.NpgsqlException npgse)
            {
                throw npgse;
            }
            catch (SocketException scket) { }

            return null;
        }

        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            var dtStart = DateTime.Now;
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
                            Type[] typeArray = this.AddColumns(dt, (reader as NpgsqlDataReader).GetColumnSchema());
                            PrepareDataTable((reader as NpgsqlDataReader), dt, typeArray);
                            ds.Tables.Add(dt);
                        }
                        catch (Exception ee)
                        {
                            throw ee;
                        }
                    }
                    while (reader.NextResult());
                }
            }
            catch (Npgsql.NpgsqlException npgse)
            {
                throw npgse;
            }
            catch (SocketException scket) { }

            var dtEnd = DateTime.Now;
            var ts = (dtEnd - dtStart).TotalMilliseconds;
            Console.WriteLine(string.Format("-------------------------------------> {0}", ts));
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

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }

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

        private Type[] AddColumns(EbDataTable dt, ReadOnlyCollection<NpgsqlDbColumn> schema)
        {
            int pos = 0;
            Type[] typeArray = new Type[schema.Count];
            foreach (NpgsqlDbColumn drow in schema)
            {
                string columnName = System.Convert.ToString(drow["ColumnName"]);
                typeArray[pos] = (Type)(drow["DataType"]);
                EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType(typeArray[pos]));
                column.ColumnIndex = pos++;
                dt.Columns.Add(column);
            }

            return typeArray;
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

        private void PrepareDataTable(NpgsqlDataReader reader, EbDataTable dt, Type[] typeArray)
        {
            int _fieldCount = reader.FieldCount;

            while (reader.Read())
            {
                EbDataRow dr = dt.NewDataRow();
                object[] oArray = new object[_fieldCount];
                reader.GetValues(oArray);
                dr.AddRange(oArray);
                //for (int i = 0; i < _fieldCount; i++)
                //{
                //    //var _typ = reader.GetFieldType(i);

                //    if (typeArray[i] == typeof(DateTime))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? DateTime.Now: reader.GetDateTime(i);
                //        continue;
                //    }
                //    else if (typeArray[i] == typeof(string))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? string.Empty : reader.GetString(i);
                //        continue;
                //    }
                //    else if (typeArray[i] == typeof(bool))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? false : reader.GetBoolean(i);
                //        continue;
                //    }
                //    else if (typeArray[i] == typeof(decimal))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetDecimal(i);
                //        continue;
                //    }
                //    else if (typeArray[i] == typeof(int) || typeArray[i] == typeof(Int32))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetInt32(i);
                //        continue;
                //    }
                //    else if (typeArray[i] == typeof(Int64))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetInt64(i);
                //        continue;
                //    }
                //    else
                //    {
                //        dr[i] = reader.GetValue(i);
                //        continue;
                //    }
                //}

                dt.Rows.Add(dr);
            }

            typeArray = null;
        }

        //-----------Sql queries

        public string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM eb_authenticate_unified(uname => @uname, password => @pass, wc => @wc);"; } }

        public string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM eb_authenticate_unified(social => @social, wc => @wc);"; } }

        public string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM eb_authenticate_unified(uname => @uname, wc => @wc);"; } }

        public string EB_SIDEBARUSER_REQUEST{ get { return @"
                SELECT id, applicationname
                FROM eb_applications;
                SELECT
                    EO.id, EO.obj_type, EO.obj_name,
                    EOV.version_num, EOV.refid, EO2A.app_id,EO.obj_desc
                FROM
                    eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
                WHERE
                    EO.id = EOV.eb_objects_id 
                AND 
                    EOS.eb_obj_ver_id = EOV.id 
                AND 
                    EO.id = ANY('{@Ids}')  
                AND 
                    EOS.status = 3 
                AND EO.id = EO2A.obj_id 
                AND EO2A.eb_del = 'F';"; } }

        public string EB_GETROLESRESPONSE_QUERY
        {
            get
            {
                return
                    @"SELECT R.id,R.role_name,R.description,A.applicationname,
									(SELECT COUNT(role1_id) FROM eb_role2role WHERE role1_id=R.id AND eb_del='F') AS subrole_count,
									(SELECT COUNT(user_id) FROM eb_role2user WHERE role_id=R.id AND eb_del='F') AS user_count,
									(SELECT COUNT(distinct permissionname) FROM eb_role2permission RP, eb_objects2application OA WHERE role_id = R.id AND app_id=A.id AND RP.obj_id=OA.obj_id AND RP.eb_del = 'F' AND OA.eb_del = 'F') AS permission_count
								FROM eb_roles R, eb_applications A
								WHERE R.applicationid = A.id AND R.role_name ~* :searchtext;";
            }
        }
        public string EB_GETMANAGEROLESRESPONSE_QUERY { get { return @"
                                                           SELECT id, applicationname FROM eb_applications where eb_del = 'F' ORDER BY applicationname;

									SELECT DISTINCT EO.id, EO.obj_name, EO.obj_type, EO2A.app_id
									FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
									WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
									AND EO.id = EO2A.obj_id AND EO2A.eb_del = 'F';

									SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> :id ORDER BY role_name;
									SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';"; } }
        public string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get { return @"
                                                       SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = :id;
										SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = :id AND eb_del = 'F';
										SELECT A.applicationname, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = :id AND A.eb_del = 'F';

										SELECT A.id, A.firstname, A.email, B.id FROM eb_users A, eb_role2user B
											WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = :id;"; } }
        public string EB_SAVEROLES_QUERY { get { return "SELECT eb_create_or_update_rbac_manageroles(:role_id, :applicationid, :createdby, :role_name, :description, :is_anonym, :users, :dependants, :permission " +
                    ");"; } }


    }
}

