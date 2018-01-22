using ExpressBase.Common.Connections;
using Npgsql;
//using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.OracleClient;
using System.Net.Sockets;
using System.Text;

namespace ExpressBase.Common.Data.OracleDB
{
    public class OracleDB : IDatabase
    {
        private const string CONNECTION_STRING_BARE = "Data Source=(DESCRIPTION =" + "(ADDRESS = (PROTOCOL = TCP)(HOST = {0})(PORT = {1}))" + "(CONNECT_DATA =" + "(SERVER = DEDICATED)" + "(SERVICE_NAME = XE)));" + "User Id= {2};Password={3}";
        private string _cstr;
        private EbBaseDbConnection EbBaseDbConnection { get; set; }

        public OracleDB(EbBaseDbConnection dbconf)
        {
            this.EbBaseDbConnection = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port,  this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password);
        }   
        public OracleDB()
        {
        }

        public DbConnection GetNewConnection(string dbName)
        {
            return new OracleConnection(_cstr);
        }

        public DbConnection GetNewConnection()
        {
            return new OracleConnection(_cstr);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new OracleCommand(sql, (OracleConnection)con);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql,DbTransaction trans)
        {
            return new OracleCommand(sql, (OracleConnection)con,(OracleTransaction)trans);
        }

        public DbParameter GetNewParameter(string parametername, NpgsqlTypes.NpgsqlDbType type, object value)
        {
            return null;
        }
        public System.Data.Common.DbParameter GetNewParameter(string parametername, DbType type, object value)
        {
            return new OracleParameter(parametername, type) { Value = value };
        }    

        public System.Data.Common.DbParameter GetNewParameter(string parametername, OracleType type, object value)
        {
            return new OracleParameter(parametername, type) { Value = value };
        }

        public T DoQuery<T>(string query, params DbParameter[] parameters)
        {
            T obj = default(T);

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
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
                catch (OracleException) { }
                catch (SocketException) { }
            }

            return obj;
        }

        public EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        using (var reader = cmd.ExecuteReader())
                        {
                            DataTable schema = reader.GetSchemaTable();
                            this.AddColumns(dt, schema);
                            PrepareDataTable(reader, dt);
                        }
                    }
                }
                catch (OracleException orcl) { }
                catch (SocketException scket) { }
            }

            return dt;
        }

        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        using (var reader = cmd.ExecuteReader())
                        {
                            EbDataTable dt = new EbDataTable();
                            DataTable schema = reader.GetSchemaTable();
                            this.AddColumns(dt, schema);
                            PrepareDataTable(reader, dt);
                            ds.Tables.Add(dt);
                            //do
                            //{
                            //    EbDataTable dt = new EbDataTable();
                            //    this.AddColumns(dt, reader.GetColumnSchema());

                            //    PrepareDataTable(reader, dt);
                            //    ds.Tables.Add(dt);
                            //}
                            //while (reader.NextResult());
                        }
                    }
                }
                catch (OracleException orcl) { }
            }

            return ds;
        }

        public int DoNonQuery(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (OracleException orcl) { }

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

        private void AddColumns(EbDataTable dt, DataTable schema)
        {
            int pos = 0;
            foreach (DataRow row in schema.Rows)
            {
                foreach (DataColumn column in schema.Columns)
                {
                    string columnName = column.ColumnName;
                    EbDataColumn ebcolumn = new EbDataColumn(columnName, ConvertToDbType((Type)(row["DataType"])));
                    ebcolumn.ColumnIndex = pos++;
                    dt.Columns.Add(ebcolumn);
                }
            }
            /*foreach (NpgsqlDbColumn drow in schema)
            {
                string columnName = System.Convert.ToString(drow["ColumnName"]);
                EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType((Type)(drow["DataType"])));
                column.ColumnIndex = pos++;
                dt.Columns.Add(column);
            }*/
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

        private void PrepareDataTable(OracleDataReader reader, EbDataTable dt)
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
                        dr[i] = reader.IsDBNull(i) ? DateTime.Now : reader.GetDateTime(i);
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
