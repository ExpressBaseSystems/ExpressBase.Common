﻿using ExpressBase.Common.Connections;
using ExpressBase.Common.Structures;
using Npgsql;
//using Oracle.ManagedDataAccess.Client;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.OracleClient;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;

namespace ExpressBase.Common.Data
{
    public class OracleDB : IDatabase
    {
        private const string CONNECTION_STRING_BARE = "Data Source=(DESCRIPTION =" + "(ADDRESS = (PROTOCOL = TCP)(HOST = {0})(PORT = {1}))" + "(CONNECT_DATA =" + "(SERVER = DEDICATED)" + "(SERVICE_NAME = XE)));" + "User Id= {2};Password={3}";
        private string _cstr;
        private EbBaseDbConnection EbBaseDbConnection { get; set; }

        public OracleDB(EbBaseDbConnection dbconf)
        {
            this.EbBaseDbConnection = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port, this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password);
        }
        public OracleDB()
        {
            _cstr = "Data Source=(DESCRIPTION =" + "(ADDRESS = (PROTOCOL = TCP)(HOST = 35.200.241.84)(PORT = 1521))" + "(CONNECT_DATA =" + "(SERVER = DEDICATED)" + "(SERVICE_NAME = XE)));" + "User Id= MASTERTEX;Password=master";
            //_cstr = "Data Source = RHEL5; User ID = TEST; Password = Passw0rd1 ";
        }

        public DbConnection GetNewConnection(string dbName)
        {
            //System.Data.Common.DbConnection con = new OracleConnection();
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

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql, DbTransaction trans)
        {
            return new OracleCommand(sql, (OracleConnection)con, (OracleTransaction)trans);
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbType type, object value)
        {
            return new OracleParameter(parametername, (OracleType)type.VendorSpecificIntCode(DatabaseVendors.ORACLE)) { Value = value };
        }

        public T DoQuery<T>(string query, params DbParameter[] parameters)
        {
            T obj = default(T);

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    string[] sql_arr = query.Split(";");
                    con.Open();
                    for (int i = 0; i < sql_arr.Length - 1; i++)
                    {
                        using (OracleCommand cmd = new OracleCommand(sql_arr[i], con))
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
                }
                catch (OracleException e) { Console.WriteLine("Exception:" + e.ToString()); }
                catch (SocketException e) { Console.WriteLine("Exception:" + e.ToString()); }
            }

            return obj;
        }

        public EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();
            string[] sql_arr = query.Split(";");

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    for (int i = 0; i < sql_arr.Length - 1; i++)
                    {
                        using (OracleCommand cmd = new OracleCommand(sql_arr[i], con))
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
                }
                catch (OracleException orcl) { Console.WriteLine("Exception:" + orcl.ToString()); }
                catch (SocketException scket) { Console.WriteLine("Exception:" + scket.ToString()); }
            }

            return dt;
        }

        public DbDataReader DoQueriesBasic(string query, params DbParameter[] parameters)
        {
            var con = GetNewConnection() as OracleConnection;
            try
            {
                con.Open();
                string[] sql_arr = query.Split(";");
                for (int i = 0; i < sql_arr.Length - 1; i++)
                {
                    using (OracleCommand cmd = new OracleCommand(sql_arr[i], con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteReader(CommandBehavior.CloseConnection);
                    }
                }
            }
            catch (OracleException ex) { Console.WriteLine("Exception:" + ex.ToString()); }

            return null;
        }


        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();
            string[] sql_arr = query.Split(";");

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {                   
                    con.Open();
                    for (int i = 0; i < sql_arr.Length - 1; i++)
                    {
                        using (OracleCommand cmd = new OracleCommand(sql_arr[i], con))
                        {
                           
                            if ( Regex.IsMatch(sql_arr[i], @"\:+") && parameters != null && parameters.Length > 0)
                            {
                                cmd.Parameters.AddRange(parameters);                                
                            }
                            
                            using (var reader = cmd.ExecuteReader())
                            {
                                EbDataTable dt = new EbDataTable();
                                DataTable schema = reader.GetSchemaTable();

                                this.AddColumns(dt, schema);
                                PrepareDataTable(reader, dt);
                                ds.Tables.Add(dt);

                            }
                            cmd.Parameters.Clear();
                        }
                    }
                }
                catch (OracleException orcl) { Console.WriteLine("Exception:" + orcl.ToString()); }
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
                catch (OracleException orcl) { Console.WriteLine("Exception:" + orcl.ToString()); }

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

        public bool IsTableExists(string query, params DbParameter[] parameters)
        {
            return false;
        }

        public void CreateTable(string query)
        {
            
        }

        public int InsertTable(string query, params DbParameter[] parameters)
        {
            return 0;
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
                object[] oArray = new object[_fieldCount];
                reader.GetValues(oArray);
                dr.AddRange(oArray);
                //for (int i = 0; i < _fieldCount; i++)
                //{
                //    var _typ = reader.GetFieldType(i);
                //    if (_typ == typeof(DateTime))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? DateTime.Now : reader.GetDateTime(i);
                //        continue;
                //    }
                //    else if (_typ == typeof(string))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? string.Empty : reader.GetString(i);
                //        continue;
                //    }
                //    else if (_typ == typeof(bool))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? false : reader.GetBoolean(i);
                //        continue;
                //    }
                //    else if (_typ == typeof(decimal))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetDecimal(i);
                //        continue;
                //    }
                //    else if (_typ == typeof(int) || _typ == typeof(Int32))
                //    {
                //        dr[i] = reader.IsDBNull(i) ? 0 : reader.GetInt32(i);
                //        continue;
                //    }
                //    else if (_typ == typeof(Int64))
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
        }

        //-----------Sql queries

        public string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM table(eb_authenticate_unified(uname => :uname, passwrd => :pass,wc => :wc));"; } }
        public string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM table(eb_authenticate_unified(social => :social, wc => :wc));"; } }
        public string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM table(eb_authenticate_unified(uname => :uname, wc => :wc));"; } }

        public string EB_SIDEBARUSER_REQUEST { get { return @"
                        SELECT id, application_name
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
                            EO.id = ANY(@Ids)  
                        AND 
                            EOS.status = 3 
                        AND EO.id = EO2A.obj_id 
                        AND EO2A.eb_del = 'F';"; } }
        public string EB_GETROLESRESPONSE_QUERY
        {
            get
            {
                return
@"SELECT R.id,R.role_name,R.description,A.application_name,
                        (SELECT COUNT(role1_id) FROM eb_role2role WHERE role1_id=R.id AND eb_del='F') AS subrole_count,
						(SELECT COUNT(user_id) FROM eb_role2user WHERE role_id=R.id AND eb_del='F') AS user_count,
						(SELECT COUNT(distinct permissionname) FROM eb_role2permission RP, eb_objects2application OA WHERE role_id = R.id AND app_id=A.id AND RP.obj_id=OA.obj_id AND RP.eb_del = 'F' AND OA.eb_del = 'F') AS permission_count
								FROM eb_roles R, eb_applications A
								WHERE R.applicationid = A.id AND R.role_name LIKE  '%' || :searchtext || '%';";
            }
        }
        public string EB_GETMANAGEROLESRESPONSE_QUERY { get { return @"
                                                           SELECT id, application_name FROM eb_applications where eb_del = 'F' ORDER BY application_name;
									SELECT DISTINCT EO.id, EO.obj_name, EO.obj_type, EO2A.app_id
									FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
									WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
									AND EO.id = EO2A.obj_id AND EO2A.eb_del = 'F';

									SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> :id ORDER BY role_name;
									SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';"; } }
        public string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get { return @"
                                                        SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = :id;
										                SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = :id AND eb_del = 'F';
                										SELECT A.application_name, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = :id AND A.eb_del = 'F';
										                SELECT A.id, A.firstname, A.email, B.id FROM eb_users A, eb_role2user B
											                WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = :id;"; } }

        public string EB_SAVEROLES_QUERY { get { return "SELECT eb_create_or_update_rbac_roles(:role_id, :applicationid, :createdby, :role_name, :description, :is_anonym, :users, :dependants, :permission) FROM dual;"; } }



        //.......OBJECTS QUERIES.....
        public string EB_FETCH_ALL_VERSIONS_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                        EOV.id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.commit_uid, EU.firstname
                    FROM 
                        eb_objects_ver EOV, eb_users EU
                    WHERE
                        EOV.commit_uid = EU.id AND
                        EOV.eb_objects_id=(SELECT eb_objects_id FROM eb_objects_ver WHERE refid=@refid)
                    ORDER BY
                        EOV.id DESC; 
                ";
            }
        }

        public string EB_PARTICULAR_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT
                        obj_json, version_num, status, EO.obj_tags
                    FROM
                        eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO
                    WHERE
                        EOV.refid=@refid AND EOS.eb_obj_ver_id = EOV.id AND EO.id=EOV.eb_objects_id
                        AND ROWNUM<=1
                    ORDER BY
	                    EOS.id DESC ; 
                ";
            }
        }

        public string EB_LATEST_COMMITTED_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                        EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status, EO.obj_desc,
                        EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.obj_json, EOV.refid
                    FROM 
                        eb_objects EO, eb_objects_ver EOV
                    WHERE
                        EO.id = EOV.eb_objects_id AND EOV.refid=@refid
                    ORDER BY
                        EO.obj_type; 
                ";
            }
        }
        public string EB_ALL_LATEST_COMMITTED_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog,EOV.commit_ts, EOV.commit_uid, EOV.refid,
                            EU.firstname
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid=EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id AND EO.obj_type=@type
                        ORDER BY
                            EO.obj_name; 
                ";
            }
        }

        public string EB_GET_LIVE_OBJ_RELATIONS
        {
            get
            {
                return @"SELECT 
	                        EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status
                        FROM 
	                        eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS
                        WHERE 
	                        EO.id = ANY (SELECT eb_objects_id FROM eb_objects_ver WHERE refid IN(SELECT dependant FROM eb_objects_relations
                                                  WHERE dominant=@dominant))
                            AND EOV.refid =ANY(SELECT dependant FROM eb_objects_relations WHERE dominant=@dominant)    
                            AND EO.id =EOV.eb_objects_id  AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17); 
                ";
            }
        }
        public string EB_GET_ALL_COMMITTED_VERSION_LIST
        {
            get
            {
                return @"SELECT 
                                EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                                EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.refid,
                                EU.firstname
                            FROM 
                                eb_objects EO, eb_objects_ver EOV
                            LEFT JOIN
	                            eb_users EU
                            ON 
	                            EOV.commit_uid=EU.id
                            WHERE
                                EO.id = EOV.eb_objects_id  AND EO.obj_type=@type AND COALESCE(EOV.working_mode, 'F') <> 'T'
                            ORDER BY
                                EO.obj_name;
                ";
            }
        }

        public string EB_GET_OBJ_LIST_FROM_EBOBJECTS
        {
            get
            {
                return @"SELECT 
                    id, obj_name, obj_type, obj_cur_status, obj_desc  
                FROM 
                    eb_objects
                WHERE
                    obj_type=@type
                ORDER BY
                    obj_name;
                ";
            }
        }

        public string EB_GET_OBJ_STATUS_HISTORY
        {
            get
            {
                return @"SELECT 
                            EOS.eb_obj_ver_id, EOS.status, EU.firstname, EOS.ts, EOS.changelog, EOV.commit_uid   
                        FROM
                            eb_objects_status EOS, eb_objects_ver EOV, eb_users EU
                        WHERE
                            eb_obj_ver_id = EOV.id AND EOV.refid = @refid AND EOV.commit_uid=EU.id
                        ORDER BY 
                        EOS.id DESC
                ";
            }
        }

        public string EB_LIVE_VERSION_OF_OBJS
        {
            get
            {
                return @"SELECT
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.obj_json, EOV.refid, EOS.status
                        FROM
                            eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO
                        WHERE
                            EO.id = @id AND EOV.eb_objects_id = @id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id
                ";
            }
        }
        public string EB_GET_ALL_TAGS
        {
            get
            {
                return @"WITH obj_tags AS (SELECT LISTAGG(obj_tags,',')WITHIN GROUP(ORDER BY obj_tags) tags FROM eb_objects)SELECT DISTINCT  
                         REGEXP_SUBSTR (tags, '[^,]+', 1, LEVEL) DISTINCT_TAGS  FROM obj_tags 
                         CONNECT BY LEVEL <= (SELECT LENGTH (REPLACE (tags, ',', NULL)) FROM obj_tags)
                ";
            }
        }
    }
}
