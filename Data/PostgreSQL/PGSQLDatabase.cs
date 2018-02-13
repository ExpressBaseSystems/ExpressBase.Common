using ExpressBase.Common;
using ExpressBase.Common.Connections;
using Npgsql;
using Npgsql.Schema;
using System;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.Common;
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

        public System.Data.Common.DbParameter GetNewParameter(string parametername, DbType type, object value)
        {
            return new NpgsqlParameter(parametername, type) { Value = value };
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, NpgsqlTypes.NpgsqlDbType type, object value)
        {
            return new NpgsqlParameter(parametername, type) { Value = value };
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
                            Type[] typeArray = this.AddColumns(dt, reader.GetColumnSchema());

                            PrepareDataTable(reader, dt, typeArray);
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

                        }
                    }
                    while (reader.NextResult());
                }
            }
            catch (Npgsql.NpgsqlException npgse) { }

            var dtEnd = DateTime.Now;
            var ts = (dtEnd - dtStart).Milliseconds;
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
        //-----------Insert queries
        public string INSERT_EB_ROLES { get { return "INSERT INTO eb_roles (role_name, eb_del) VALUES ('{0}', false) RETURNING id;"; } }
        public string INSERT_EB_OBJECTS { get { return "INSERT INTO eb_objects (object_name) VALUES ('{0}') RETURNING id;"; } }
        public string INSERT_EB_OPERATIONS { get { return "INSERT INTO eb_operations (operation_name) VALUES ('{0}') RETURNING id"; } }
        public string INSERT_EB_PERMISSIONS { get { return "INSERT INTO eb_permissions (object_id, operation_id) VALUES ({0},{1}) RETURNING id ;"; } }
        public string INSERT_EB_USERS { get { return "INSERT INTO eb_users(email, pwd, firstname, lastname, middlename, dob, phnoprimary, phnosecondary, landline, extension, locale, alternateemail,profileimg) VALUES (@uname, @pwd,@fname,@lname,@mname,@dob,@pphno,@sphno,@land,@extension,@locale,@aemail,@imgprofile) RETURNING id;"; } }

        //--------Delete queries

        //--------Object delete
        public string DELETE_OBJ_FROM_EB_OBJECTS { get { return "UPDATE eb_objects SET  eb_del= true WHERE id={0};"; } }
        public string DELETE_OBJ_FROM_EB_PERMISSIONS { get { return "UPDATE eb_permissions SET eb_del=true WHERE object_id={0};"; } }
        public string DELETE_OBJ_FROM_EB_PERMISSION2ROLE { get { return "UPDATE eb_permission2role SET eb_del= true WHERE permission_id IN (SELECT id FROM eb_permissions WHERE object_id= {0});"; } }

        //--------Operation delete
        public string DELETE_OP_FROM_EB_OPERATIONS { get { return "UPDATE eb_operations SET eb_del = true WHERE id = { 0 }; "; } }
        public string DELETE_OP_FROM_EB_PERMISSIONS { get { return "UPDATE eb_permissions SET eb_del=true WHERE operation_id={0};"; } }
        public string DELETE_OP_FROM_EB_PERMISSION2ROLE { get { return "UPDATE eb_permission2role SET eb_del=true WHERE permission_id IN (SELECT id FROM eb_permissions WHERE operation_id={0});"; } }

        //--------Permission delete
        public string DELETE_PER_FROM_EB_PERMISSIONS { get { return "UPDATE eb_permissions SET eb_del=TRUE where id={0};"; } }
        public string DELETE_PER_FROM_EB_PERMISSION2ROLE { get { return "UPDATE eb_permission2role SET eb_del=TRUE where permission_id={0};"; } }

        //--------Roles delete
        public string DELETE_ROLE_FROM_EB_ROLES { get { return "UPDATE eb_roles SET eb_del=true WHERE id={0};"; } }
        public string DELETE_ROLE_FROM_EB_ROLE2ROLE { get { return "UPDATE eb_role2role SET eb_del=true WHERE role1_id={0} OR role2_id={0};"; } }
        public string DELETE_ROLE_FROM_EB_ROLE2USER { get { return " UPDATE eb_role2user SET eb_del = true WHERE role_id = {0} ;"; } }
        public string DELETE_ROLE_FROM_EB_PERMISSION2ROLE { get { return "UPDATE eb_permission2role SET eb_del=true WHERE role_id={0};"; } }

        //--------User delete
        public string DELETE_USER_FROM_EB_USERS { get { return "UPDATE eb_users SET eb_del = true WHERE id = {0};"; } }
        public string DELETE_USER_FROM_EB_ROLE2USER { get { return " UPDATE eb_role2user SET eb_del = true WHERE user_id = {0} ;"; } }

        //--------Renaming Role
        public string RENAME_ROLE_IN_EB_ROLES { get { return "UPDATE eb_roles SET role_name='{0}' WHERE id={1};"; } }

        //-------Loading Queries
        //Loading Roles
        public string LOAD_ROLE_FROM_EB_ROLES { get { return "SELECT id,role_name FROM eb_roles WHERE id IN ( SELECT role2_id FROM eb_role2role WHERE role1_id = {0});"; } }

        //Loading Permission
        public string LOAD_PERMISSION_FROM_EB_PERMISSION { get { return "SELECT id, object_id, operation_id FROM eb_permissions WHERE id in (SELECT permission_id FROM eb_permission2role WHERE role_id = {0});"; } }

        //Loading User's Roles                                
        public string LOAD_USERROLE_FROM_EB_ROLES { get { return " SELECT id, role_name FROM eb_roles WHERE id IN ( SELECT role_id FROM eb_role2user WHERE user_id = ANY (SELECT id FROM eb_users  WHERE email= @uname AND pwd = @pass) );"; } }
        public string LOAD_USERALLPERMISSION_FROM_EB_PERMISSIONS { get { return "SELECT getallPermissions.pid,getallpermissions.oid,getallpermissions.opid FROM getallpermissions(@uname, @pass);"; } }
        public string LOAD_USERALLROLES_FROM_EB_ROLES { get { return "SELECT getallroles.role_id,getallroles.role_name FROM getallroles(@uname,@pass);"; } }

        //Loading user

        public string LOAD_USERALLDETAILS { get { return "SELECT  FROM getuser(@uname,@pass,ur,r,p);FETCH ALL FROM ur; FETCH ALL FROM r;FETCH ALL FROM p; "; } }
    }
}

