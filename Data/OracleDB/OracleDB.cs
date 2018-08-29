using ExpressBase.Common.Connections;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Structures;
using MongoDB.Bson;
using Npgsql;
using Oracle.ManagedDataAccess.Client;
using Oracle.ManagedDataAccess.Types;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.Common;
using System.Globalization;
using System.Net.Sockets;
using System.Text;
using System.Text.RegularExpressions;

namespace ExpressBase.Common.Data
{
    public class OracleEbDbTypes : IVendorDbTypes
    {
        private Dictionary<EbDbTypes, VendorDbType> InnerDictionary { get; }

        VendorDbType IVendorDbTypes.AnsiString { get { return InnerDictionary[EbDbTypes.AnsiString]; } }
        VendorDbType IVendorDbTypes.Binary { get { return InnerDictionary[EbDbTypes.Binary]; } }
        VendorDbType IVendorDbTypes.Byte { get { return InnerDictionary[EbDbTypes.Byte]; } }
        VendorDbType IVendorDbTypes.Date { get { return InnerDictionary[EbDbTypes.Date]; } }
        VendorDbType IVendorDbTypes.DateTime { get { return InnerDictionary[EbDbTypes.DateTime]; } }
        VendorDbType IVendorDbTypes.Decimal { get { return InnerDictionary[EbDbTypes.Decimal]; } }
        VendorDbType IVendorDbTypes.Double { get { return InnerDictionary[EbDbTypes.Double]; } }
        VendorDbType IVendorDbTypes.Int16 { get { return InnerDictionary[EbDbTypes.Int16]; } }
        VendorDbType IVendorDbTypes.Int32 { get { return InnerDictionary[EbDbTypes.Int32]; } }
        VendorDbType IVendorDbTypes.Int64 { get { return InnerDictionary[EbDbTypes.Int64]; } }
        VendorDbType IVendorDbTypes.Object { get { return InnerDictionary[EbDbTypes.Object]; } }
        VendorDbType IVendorDbTypes.String { get { return InnerDictionary[EbDbTypes.String]; } }
        VendorDbType IVendorDbTypes.Time { get { return InnerDictionary[EbDbTypes.Time]; } }
        VendorDbType IVendorDbTypes.VarNumeric { get { return InnerDictionary[EbDbTypes.VarNumeric]; } }
        VendorDbType IVendorDbTypes.Json { get { return InnerDictionary[EbDbTypes.Json]; } }
        VendorDbType IVendorDbTypes.Bytea { get { return InnerDictionary[EbDbTypes.Bytea]; } }
        VendorDbType IVendorDbTypes.Boolean { get { return InnerDictionary[EbDbTypes.Boolean]; } }


        private OracleEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, OracleDbType.Clob));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, OracleDbType.Blob));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, OracleDbType.Byte));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, OracleDbType.Date));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, OracleDbType.TimeStamp));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, OracleDbType.Decimal));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, OracleDbType.Double));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, OracleDbType.Int16));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, OracleDbType.Int32));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, OracleDbType.Int64));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, OracleDbType.Clob));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, OracleDbType.Clob));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, OracleDbType.TimeStamp));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, OracleDbType.NVarchar2));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, OracleDbType.Clob));
            this.InnerDictionary.Add(EbDbTypes.Bytea, new VendorDbType(EbDbTypes.Bytea, OracleDbType.Blob));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, OracleDbType.Char));
        }

        public static IVendorDbTypes Instance => new OracleEbDbTypes();

        public dynamic GetVendorDbType(EbDbTypes e)
        {
            return this.InnerDictionary[e].VDbType;
        }
    }

    public class OracleDB : IDatabase
    {
        public DatabaseVendors Vendor
        {
            get
            {
                return DatabaseVendors.ORACLE;
            }
        }

        public IVendorDbTypes VendorDbTypes
        {
            get
            {
                return OracleEbDbTypes.Instance;
            }
        }

        private const string CONNECTION_STRING_BARE = "Data Source=(DESCRIPTION =" + "(ADDRESS = (PROTOCOL = TCP)(HOST = {0})(PORT = {1}))" + "(CONNECT_DATA =" + "(SERVER = DEDICATED)" + "(SERVICE_NAME = XE)));" + "User Id= {2};Password={3};Pooling=true;Min Pool Size=1;Connection Lifetime=180;Max Pool Size=50;Incr Pool Size=5";
        private string _cstr;
        private EbBaseDbConnection EbBaseDbConnection { get; set; }

        public OracleDB(EbBaseDbConnection dbconf)
        {
            this.EbBaseDbConnection = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port, this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password);
        }
        public OracleDB()
        {

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

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type, object value)
        {
            if (type == EbDbTypes.DateTime)
                return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(EbDbTypes.DateTime)) { Value = new OracleDate(Convert.ToDateTime(value)) };
            if (type == EbDbTypes.Date || type == EbDbTypes.Time || type == EbDbTypes.DateTime2)
                return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = Convert.ToDateTime(value).Date };
            else
                return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = value };
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
        }

        public System.Data.Common.DbParameter GetNewOutParameter(string parametername, EbDbTypes type)
        {
            return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Output };
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
                            cmd.BindByName = true;     //solved - issue in prameter order
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
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                }
                catch (SocketException orcl)
                {
                    Console.WriteLine(orcl.Message);
                }
            }

            return obj;
        }

        public EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();
            List<DbParameter> dbParameter = new List<DbParameter>();

            foreach (var param in parameters)
            {
                if (Regex.IsMatch(query, ":" + param.ParameterName))
                    dbParameter.Add(param);
            }

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        cmd.BindByName = true;
                        if (Regex.IsMatch(query, @"\:+") && parameters != null && parameters.Length > 0)
                        {
                            cmd.Parameters.AddRange(dbParameter.ToArray());
                        }

                        using (var reader = cmd.ExecuteReader())
                        {
                            DataTable schema = reader.GetSchemaTable();
                            this.AddColumns(dt, schema);
                            PrepareDataTable(reader, dt);
                        }
                    }

                }
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                }
                catch (SocketException scket) { }
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
                        cmd.BindByName = true;
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteReader(CommandBehavior.CloseConnection);
                    }
                }
            }
            catch (OracleException orcl)
            {
                Console.WriteLine(orcl.Message);
            }

            return null;
        }


        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();
            List<DbParameter> dbParameter = new List<DbParameter>();
            //query = Regex.Replace(query, @"\n|\r|\s+", " ");
            query = query.Trim();
            string[] sql_arr = query.Split(";");
            foreach (var param in parameters)
            {
                if (Regex.IsMatch(query, ":" + param.ParameterName))
                    dbParameter.Add(param);
            }

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    //for (int i = 0; i < sql_arr.Length - 1; i++)
                    //for (int i = 0; i < sql_arr.Length && sql_arr[i] != ""; i++)
                    //for (int i = 0; i < sql_arr.Length && sql_arr[i] !=string.Empty && !(Regex.IsMatch(sql_arr[i],@"\t|\n|\r")); i++)
                    for (int i = 0; i < sql_arr.Length && sql_arr[i] != string.Empty && sql_arr[i] != " "; i++)
                    {
                        using (OracleCommand cmd = new OracleCommand(sql_arr[i], con))
                        {
                            cmd.BindByName = true;
                            if (Regex.IsMatch(sql_arr[i], @"\:+") && parameters != null && parameters.Length > 0)
                            {
                                cmd.Parameters.AddRange(dbParameter.ToArray());
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

                catch (Exception orcl)
                {
                    Console.WriteLine(orcl.Message);
                }
            }

            return ds;
        }

        public int DoNonQuery(string query, params DbParameter[] parameters)
        {
            var return_val = 0;
            List<DbParameter> dbParameter = new List<DbParameter>();
            string[] sql_arr = query.Split(";");
            foreach (var param in parameters)
            {
                if (Regex.IsMatch(query, ":" + param.ParameterName))
                    dbParameter.Add(param);
            }

            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    //for (int i = 0; i < sql_arr.Length - 1; i++)
                    for (int i = 0; i < sql_arr.Length && sql_arr[i].Trim() != ""; i++)
                    {
                        using (OracleCommand cmd = new OracleCommand(sql_arr[i], con))
                        {
                            cmd.BindByName = true;
                            if (Regex.IsMatch(sql_arr[i], @"\:+") && parameters != null && parameters.Length > 0)
                            {
                                cmd.Parameters.AddRange(dbParameter.ToArray());
                            }

                            return_val = cmd.ExecuteNonQuery();
                        }
                    }
                    foreach (var param in parameters)
                    {
                        if (ParameterDirection.Output == param.Direction)    //for return id
                        {
                            return_val = Convert.ToInt32(param.Value.ToString());
                        }
                    }
                }
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                }

                return return_val;
            }
        }

        public bool IsTableExists(string query, params DbParameter[] parameters)
        {
            var rslt = false;
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        cmd.BindByName = true;
                        if (Regex.IsMatch(query, @"\:+") && parameters != null && parameters.Length > 0)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }

                        rslt = Convert.ToBoolean(cmd.ExecuteScalar());
                    }
                }
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                    throw orcl;
                }
                catch (SocketException scket) { }
            }

            return rslt;
        }

        public void CreateTable(string query)
        {
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        cmd.BindByName = true;
                        var xx = cmd.ExecuteNonQuery();
                    }
                }
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                    throw orcl;
                }
                catch (SocketException scket) { }
            }

        }

        public int InsertTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        cmd.BindByName = true;

                        if (Regex.IsMatch(query, @"\:+") && parameters != null && parameters.Length > 0)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                    throw orcl;
                }
                catch (SocketException scket) { }
            }

            return 0;
        }

        public int UpdateTable(string query, params DbParameter[] parameters)
        {
            int rslt = 0;
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        cmd.BindByName = true;
                        if (Regex.IsMatch(query, @"\:+") && parameters != null && parameters.Length > 0)
                        {
                            cmd.Parameters.AddRange(parameters);
                        }

                        rslt = cmd.ExecuteNonQuery();
                    }
                }

                catch (Exception orcl)
                {
                    Console.WriteLine(orcl.Message);
                }
            }

            return rslt;
        }

        public ColumnColletion GetColumnSchema(string table)
        {
            ColumnColletion cols = new ColumnColletion();

            var query = "SELECT * FROM USER_TAB_COLS WHERE LOWER(TABLE_NAME)=LOWER('@tbl')".Replace("@tbl", table);
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            cmd.BindByName = true;
                            int pos = 0;
							int _fieldCount = reader.FieldCount;
							while (reader.Read())
							{
								object[] oArray = new object[_fieldCount];
								reader.GetValues(oArray);
								EbDataColumn column = new EbDataColumn(oArray[1].ToString(), ConvertToDbType(oArray[2].ToString()));
								column.ColumnIndex = pos++;
								cols.Add(column);
							}
                        }
                    }
                }
                catch (OracleException orcl)
                {
                    throw orcl;
                }
                catch (SocketException scket) { }
            }
            return cols;
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
            foreach (DataRow dr in schema.Rows)
            {

                string columnName = System.Convert.ToString(dr["ColumnName"]);
                Type type = (Type)(dr["DataType"]);
                EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType(type));
                column.ColumnIndex = pos++;

                dt.Columns.Add(column);

            }
        }

        public EbDbTypes ConvertToDbType(Type _typ)
        {
            if (_typ == typeof(DateTime))
                return EbDbTypes.Date;
            else if (_typ == typeof(string))
                return EbDbTypes.String;
            else if (_typ == typeof(bool))
                return EbDbTypes.Boolean;
            else if (_typ == typeof(decimal))
                return EbDbTypes.Decimal;
            else if (_typ == typeof(int) || _typ == typeof(Int32))
                return EbDbTypes.Int32;
            else if (_typ == typeof(Int64))
                return EbDbTypes.Int64;

            return EbDbTypes.String;
        }

		public EbDbTypes ConvertToDbType(string _typ)
		{
			if (_typ == "DATE")
				return EbDbTypes.Date;
			else if (_typ == "CHAR")
				return EbDbTypes.Boolean;
			else if (_typ == "NUMBER")
				return EbDbTypes.Decimal;
			else if (_typ == "TIMESTAMP(6)")
				return EbDbTypes.DateTime;

			return EbDbTypes.String;
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

                dt.Rows.Add(dr);
            }
        }

        //-----------Sql queries

        public string EB_INITROLE2USER { get { return "INSERT INTO eb_role2user(role_id, user_id, createdat) VALUES (@role_id, @user_id, SYSDATE);"; } }
        public string EB_USER_ROLE_PRIVS { get { return @"SELECT granted_role FROM USER_ROLE_PRIVS WHERE USERNAME='@uname'"; } }
        public string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM table(eb_authenticate_unified(uname => :uname, passwrd => :pass,wc => :wc))"; } }
        public string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM table(eb_authenticate_unified(social => :social, wc => :wc))"; } }
        public string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM table(eb_authenticate_unified(uname => :uname, wc => :wc))"; } }

        public string EB_AUTHENTICATE_ANONYMOUS { get { return "SELECT * FROM table(eb_authenticate_anonymous(@params in_appid => :appid ,in_wc => :wc))"; } }

        public string EB_SIDEBARUSER_REQUEST { get { return @"
                       SELECT id, applicationname
                FROM eb_applications;
                SELECT
                    EO.id, EO.obj_type, EO.obj_name,
                    EOV.version_num, EOV.refid, EO2A.app_id,EO.obj_desc
                FROM
                    eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
                WHERE
                EOV.eb_objects_id = EO.id	
                AND EO.id = ANY(:Ids)                			    
				AND EOS.eb_obj_ver_id = EOV.id 
				AND EO2A.obj_id = EO.id
				AND EO2A.eb_del = 'F'
                AND EOS.status = 3 
				AND EOS.id = ANY( Select MAX(id) from eb_objects_status EOS Where EOS.eb_obj_ver_id = EOV.id );"; } }

        public string EB_SIDEBARDEV_REQUEST
        {
            get { return @"
                            SELECT id, applicationname FROM eb_applications;
                            SELECT 
	                            EO.id, EO.obj_type, EO.obj_name, EO.obj_desc, COALESCE(EO2A.app_id, 0)
                            FROM 
	                            eb_objects EO
                            LEFT JOIN
	                            eb_objects2application EO2A 
                            ON
	                            EO.id = EO2A.obj_id 
                            WHERE
	                            COALESCE(EO2A.eb_del, 'F') = 'F' 
                            ORDER BY 
	                            EO.obj_type;"; }
        }
        public string EB_SIDEBARCHECK { get { return "AND EO.id = ANY(:Ids) "; } }
        public string EB_GETROLESRESPONSE_QUERY
        {
            get
            {
                return @"
                        SELECT R.id,R.role_name,R.description,A.applicationname,
                        (SELECT COUNT(role1_id) FROM eb_role2role WHERE role1_id=R.id AND eb_del='F') AS subrole_count,
						(SELECT COUNT(user_id) FROM eb_role2user WHERE role_id=R.id AND eb_del='F') AS user_count,
						(SELECT COUNT(distinct permissionname) FROM eb_role2permission RP, eb_objects2application OA WHERE role_id = R.id AND app_id=A.id AND RP.obj_id=OA.obj_id AND RP.eb_del = 'F' AND OA.eb_del = 'F') AS permission_count
								FROM eb_roles R, eb_applications A
								WHERE R.applicationid = A.id AND R.role_name LIKE  '%' || :searchtext || '%';";
            }
        }
        public string EB_GETMANAGEROLESRESPONSE_QUERY { get { return @"
                                    SELECT id, applicationname FROM eb_applications where eb_del = 'F' ORDER BY applicationname;
									SELECT DISTINCT EO.id, EO.obj_name, EO.obj_type, EO2A.app_id
										FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
										WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
										AND EOS.id = ANY(SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id)
										AND EO.id = EO2A.obj_id AND EO2A.eb_del = 'F';
									SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> :id ORDER BY to_char(role_name);
									SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';
									SELECT id, longname, shortname FROM eb_locations;"; } }
        public string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get { return @"
                                    SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = :id;
									SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = :id AND eb_del = 'F';
                					SELECT A.applicationname, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = :id AND A.eb_del = 'F';
									SELECT A.id, A.firstname, A.email, B.id FROM eb_users A, eb_role2user B
										WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = :id;
									SELECT locationid FROM eb_role2location WHERE roleid = :id AND eb_del='F';"; } }

        public string EB_SAVEROLES_QUERY { get { return "SELECT eb_create_or_update_rbac_roles(:role_id, :applicationid, :createdby, :role_name, :description, :is_anonym, :users, :dependants, :permission, :locations) FROM dual"; } }


        public string EB_SAVEUSER_QUERY { get { return "SELECT eb_createormodifyuserandroles(:userid, :id, :fullname, :nickname, :email, :pwd, :dob, :sex, :alternateemail, :phprimary, :phsecondary, :phlandphone, :extension, :fbid, :fbname, :roles, :groups, :statusid, :hide, :anonymoususerid, :preference) FROM dual;"; } }

        public string EB_SAVEUSERGROUP_QUERY { get { return "SELECT eb_createormodifyusergroup(:userid,:id,:name,:description,:users) FROM dual;"; } }

        public string EB_MANAGEUSER_FIRST_QUERY
        {
            get
            {
                return @"SELECT id, role_name, description FROM eb_roles ORDER BY to_char(role_name);
                        SELECT id, name,description FROM eb_usergroup ORDER BY name;
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';";
            }
        }

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
                        EOV.eb_objects_id=(SELECT eb_objects_id FROM eb_objects_ver WHERE refid=:refid)
                    ORDER BY
                        EOV.id DESC 
                ";
            }
        }
        public string EB_PARTICULAR_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT
                        obj_json, version_num, status, EO.obj_tags, EO.obj_type
                    FROM
                        eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO
                    WHERE
                        EOV.refid=:refid AND EOS.eb_obj_ver_id = EOV.id AND EO.id=EOV.eb_objects_id
                        AND ROWNUM<=1
                    ORDER BY
	                    EOS.id DESC  
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
                        EO.id = EOV.eb_objects_id AND EOV.refid=:refid
                    ORDER BY
                        EO.obj_type 
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
                            EO.id = EOV.eb_objects_id AND EO.obj_type=:type
                        ORDER BY
                            EO.obj_name 
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
                                                  WHERE dominant=:dominant))
                            AND EOV.refid =ANY(SELECT dependant FROM eb_objects_relations WHERE dominant=:dominant)    
                            AND EO.id =EOV.eb_objects_id  AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17) 
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
                                EO.id = EOV.eb_objects_id  AND EO.obj_type=:type AND COALESCE(EOV.working_mode, 'F') <> 'T'
                            ORDER BY
                                EO.obj_name
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
                    obj_type=:type
                ORDER BY
                    obj_name
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
                            eb_obj_ver_id = EOV.id AND EOV.refid = :refid AND EOV.commit_uid=EU.id
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
                            EO.id = :id AND EOV.eb_objects_id = :id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id
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
        public string EB_GET_TAGGED_OBJECTS
        {
            get
            {
                return "SELECT * FROM TABLE(eb_get_tagged_object(:tags))";
            }
        }

        public string EB_GET_BOT_FORM
        {
            get
            {
                return @"
                            SELECT DISTINCT
		                            EOV.refid, EO.obj_name 
                            FROM
		                            eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EOTA
                            WHERE 
		                            EO.id = EOV.eb_objects_id  AND
		                            EO.id = EOTA.obj_id  AND
		                            EOS.eb_obj_ver_id = EOV.id AND
		                            EO.id =  ANY(@Ids) AND 
		                            EOS.status = 3 AND
		                            ( 	
			                            EO.obj_type = 16 OR
			                            EO.obj_type = 17
			                            OR EO.obj_type = 18
		                            )  AND
		                            EOTA.app_id = @appid AND
                                    EOTA.eb_del = 'F'
                        ";
            }
        }

        public string IS_TABLE_EXIST
        {
            get
            {
                return @"select count(*) from user_tables where table_name = upper(:tbl)";
            }
        }

        //.....OBJECT FUNCTION CALLS
        public string EB_CREATE_NEW_OBJECT
        {
            get
            {
                return "SELECT eb_objects_create_new_object(:obj_name, :obj_desc, :obj_type, :obj_cur_status, :commit_uid, :src_pid, :cur_pid, :relations, :issave, :tags, :app_id,:s_obj_id, :s_ver_id) FROM DUAL";
            }
        }
        public string EB_SAVE_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_save(:id, :obj_name, :obj_desc, :obj_type, :commit_uid,  :relations, :tags, :app_id) FROM DUAL
                ";
            }
        }
        public string EB_COMMIT_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_commit(:id, :obj_name, :obj_desc, :obj_type, :obj_changelog,  :commit_uid,  :relations, :tags, :app_id) FROM DUAL
                ";
            }
        }
        public string EB_EXPLORE_OBJECT
        {
            get
            {
                return @"   
                    SELECT * FROM TABLE(eb_objects_exploreobject(:id))
                ";
            }
        }
        public string EB_MAJOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_major_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations) FROM DUAL
                ";
            }
        }
        public string EB_MINOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_minor_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations) FROM DUAL
                ";
            }
        }
        public string EB_CHANGE_STATUS_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_objects_change_status(:id, :status, :commit_uid, :obj_changelog) FROM DUAL
                ";
            }
        }
        public string EB_PATCH_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_patch_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations) FROM DUAL
                ";
            }
        }
        public string EB_UPDATE_DASHBOARD
        {
            get
            {
                return @"   
                    SELECT * FROM TABLE(eb_objects_update_dashboard(:refid))
                ";
            }
        }
        public string EB_LOCATION_CONFIGURATION
        {
            get
            {
                return @"";
            }
        }
    }

    public class OracleFilesDB : OracleDB, INoSQLDatabase
    {
        public OracleFilesDB(EbBaseDbConnection dbconf) : base(dbconf) { }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory cat)
        {
            throw new NotImplementedException();
        }

        public byte[] DownloadFileByName(string filename, EbFileCategory cat)
        {
            throw new NotImplementedException();
        }

        public string UploadFile(string filename, IDictionary<string, List<string>> MetaDataPair, byte[] bytea, EbFileCategory cat)
        {
            throw new NotImplementedException();
        }
    }
}

// Auto disconnect: https://stackoverflow.com/questions/35352060/odp-net-oracle-manageddataacess-random-ora-12570-errors
