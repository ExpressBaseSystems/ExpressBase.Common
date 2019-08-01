using ExpressBase.Common;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Data;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Structures;
using MongoDB.Bson;
using MongoDB.Driver.GridFS;
using Npgsql;
using Npgsql.Schema;
using NpgsqlTypes;
using ProtoBuf;
using System;
using System.Collections.Generic;
using System.Collections.ObjectModel;
using System.Data;
using System.Data.Common;
using System.Net.Sockets;

namespace ExpressBase.Common
{
    public class PGSQLEbDbTypes : IVendorDbTypes
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
        VendorDbType IVendorDbTypes.BooleanOriginal { get { return InnerDictionary[EbDbTypes.BooleanOriginal]; } }

        private PGSQLEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, NpgsqlDbType.Text, "text"));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, NpgsqlDbType.Bytea, "bytea"));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, NpgsqlDbType.Char, "char"));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, NpgsqlDbType.Date, "timestamp without time zone"));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, NpgsqlDbType.Timestamp, "timestamp with time zone"));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, NpgsqlDbType.Numeric, "decimal"));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, NpgsqlDbType.Double, "double precision"));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, NpgsqlDbType.Smallint, "smallint"));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, NpgsqlDbType.Integer, "integer"));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, NpgsqlDbType.Bigint, "bigint"));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, NpgsqlDbType.Json, "jsonb"));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, NpgsqlDbType.Text, "text"));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, NpgsqlDbType.Time, "time"));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, NpgsqlDbType.Numeric, "numeric"));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, NpgsqlDbType.Json, "jsonb"));
            this.InnerDictionary.Add(EbDbTypes.Bytea, new VendorDbType(EbDbTypes.Bytea, NpgsqlDbType.Bytea, "bytea"));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, NpgsqlDbType.Char, "char"));
            this.InnerDictionary.Add(EbDbTypes.BooleanOriginal, new VendorDbType(EbDbTypes.BooleanOriginal, NpgsqlDbType.Boolean, "bool"));
        }

        public static IVendorDbTypes Instance => new PGSQLEbDbTypes();

        public dynamic GetVendorDbType(EbDbTypes e)
        {
            return this.InnerDictionary[e].VDbType;
        }

        public string GetVendorDbText(EbDbTypes e)
        {
            return this.InnerDictionary[e].VDbText;
        }

        public VendorDbType GetVendorDbTypeStruct(EbDbTypes e)
        {
            return this.InnerDictionary[e];
        }
    }

    public class PGSQLDatabase : IDatabase
    {
        public DatabaseVendors Vendor
        {
            get
            {
                return DatabaseVendors.PGSQL;
            }
        }

        public IVendorDbTypes VendorDbTypes
        {
            get
            {
                return PGSQLEbDbTypes.Instance;
            }
        }

        private const string CONNECTION_STRING_BARE_WITHOUT_SSL = "Host={0}; Port={1}; Database={2}; Username={3}; Password={4};  Trust Server Certificate=true; Pooling=true; CommandTimeout={5};";
        private const string CONNECTION_STRING_BARE = "Host={0}; Port={1}; Database={2}; Username={3}; Password={4};  Trust Server Certificate=true; Pooling=true; CommandTimeout={5};SSL Mode=Require; Use SSL Stream=true; ";
        //SSL Mode=Require; Use SSL Stream=true;
        private string _cstr;
        private EbDbConfig DbConfig { get; set; }
        public string DBName { get; }

        public PGSQLDatabase(EbDbConfig dbconf)
        {
            this.DbConfig = dbconf;
            if (dbconf.IsSSL)
                _cstr = string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, this.DbConfig.Port, this.DbConfig.DatabaseName, this.DbConfig.UserName, this.DbConfig.Password, this.DbConfig.Timeout);
            else
                _cstr = string.Format(CONNECTION_STRING_BARE_WITHOUT_SSL, this.DbConfig.Server, this.DbConfig.Port, this.DbConfig.DatabaseName, this.DbConfig.UserName, this.DbConfig.Password, this.DbConfig.Timeout);
            DBName = DbConfig.DatabaseName;
        }

        public DbConnection GetNewConnection(string dbName)
        {
            return new NpgsqlConnection(string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, this.DbConfig.Port, dbName, this.DbConfig.UserName, this.DbConfig.Password, this.DbConfig.Timeout));
        }

        public DbConnection GetNewConnection()
        {
            return new NpgsqlConnection(_cstr);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new NpgsqlCommand(sql, (NpgsqlConnection)con);
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type, object value)
        {
            try
            {
                object val = value;// default string
                if (type == EbDbTypes.Date || type == EbDbTypes.DateTime || type == EbDbTypes.DateTime2)
                    val = Convert.ToDateTime(value);
                else if (type == EbDbTypes.Decimal || type == EbDbTypes.Double)
                    val = Convert.ToDecimal(value);
                else if (type == EbDbTypes.Int32)
                    val = Convert.ToInt32(value);
                else if (type == EbDbTypes.Int64)
                    val = Convert.ToInt64(value);
                else if (type == EbDbTypes.Boolean)
                    val = Convert.ToBoolean(value) ? 'T' : 'F';
                else if (type == EbDbTypes.BooleanOriginal)
                    val = Convert.ToBoolean(value);

                return new NpgsqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = val };
            }
            catch(Exception ex)
            {
                Console.WriteLine(string.Format("Exception in GetNewParameter : Message = {0}\n parametername = {1}\n type = {2} \n value = {3}", ex.Message, parametername, type.ToString(), value.ToString()));
                throw new Exception(ex.Message);
            }
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new NpgsqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
        }

        public System.Data.Common.DbParameter GetNewOutParameter(string parametername, EbDbTypes type)
        {
            return new NpgsqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Output };
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
                    Console.WriteLine("Postgres Exception: " + npgse.Message);
                    throw npgse;
                }
                catch (SocketException scket)
                {
                }
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
                    cmd.Prepare();
                    return cmd.ExecuteReader(CommandBehavior.KeyInfo | CommandBehavior.CloseConnection);
                }
            }
            catch (Npgsql.NpgsqlException npgse)
            {
                throw npgse;
            }
            catch (SocketException scket)
            {
            }

            return null;
        }

        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            var dtStart = DateTime.Now;
            Console.WriteLine(string.Format("DoQueries Start Time : {0}", dtStart));
            EbDataSet ds = new EbDataSet();
            ds.RowNumbers = "";
            try
            {
                using (var reader = this.DoQueriesBasic(query, parameters))
                {
                    var dtExeTime = DateTime.Now;
                    Console.WriteLine(string.Format("DoQueries Execution Time : {0}", dtExeTime));
                    do
                    {
                        try
                        {
                            EbDataTable dt = new EbDataTable();
                            Type[] typeArray = this.AddColumns(dt, (reader as NpgsqlDataReader).GetColumnSchema());
                            PrepareDataTable((reader as NpgsqlDataReader), dt, typeArray);
                            ds.Tables.Add(dt);
                            ds.RowNumbers += dt.Rows.Count.ToString() + ",";
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
            Console.WriteLine(string.Format("DoQueries End Time : {0}", dtEnd));

            var ts = (dtEnd - dtStart).TotalMilliseconds;
            Console.WriteLine(string.Format("DoQueries Execution Time : {0}", ts));            
            ds.RowNumbers = ds.RowNumbers.Substring(0, ds.RowNumbers.Length - 1)/*(ds.RowNumbers.Length>3)?ds.RowNumbers.Substring(0, ds.RowNumbers.Length - 3): ds.RowNumbers*/;
            ds.StartTime = dtStart;
            ds.EndTime = dtEnd;
            return ds;
        }

        public EbDataTable DoProcedure(string query, params DbParameter[] parameters)
        {
            return null;
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
            if (schema.Count > 0)
                dt.TableName = schema[0].BaseTableName;
            return typeArray;
        }

        public EbDbTypes ConvertToDbType(Type _typ)
        {
            if (_typ == typeof(DateTime))
                return EbDbTypes.Date;
            else if (_typ == typeof(string))
                return EbDbTypes.String;
            else if (_typ == typeof(bool))
                return EbDbTypes.Boolean;
            else if (_typ == typeof(decimal) || _typ == typeof(Double) || _typ == typeof(Single))
                return EbDbTypes.Decimal;
            else if (_typ == typeof(int) || _typ == typeof(Int32) || _typ == typeof(Int16) )
                return EbDbTypes.Int32;
            else if (_typ == typeof(Int16))
                return EbDbTypes.Int16;
            else if (_typ == typeof(Int64))
                return EbDbTypes.Int64;
            else if (_typ == typeof(Single))
                return EbDbTypes.Int32;
            else if (_typ == typeof(TimeSpan))
                return EbDbTypes.Time;
            else if (_typ == typeof(Byte[]))
                return EbDbTypes.Bytea;
            return EbDbTypes.String;
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
                dt.Rows.Add(dr);
            }

            typeArray = null;
        }

        public bool IsTableExists(string query, params DbParameter[] parameters)
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

                        return Convert.ToBoolean(cmd.ExecuteScalar());
                    }
                }
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }
            }

            return false;
        }

        public int CreateTable(string query)
        {
            int res = 0;
            using (var con = GetNewConnection() as NpgsqlConnection)
            {
                try
                {
                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                    {
                       res = cmd.ExecuteNonQuery();
                    }
                }
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }
            }
            return res;
        }

        public int InsertTable(string query, params DbParameter[] parameters)
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
            }

            return 0;
        }

        public int UpdateTable(string query, params DbParameter[] parameters)
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
            }

            return 0;
        }

        public int AlterTable(string query, params DbParameter[] parameters)
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
            }

            return 0;
        }

        public int DeleteTable(string query, params DbParameter[] parameters)
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
            }

            return 0;
        }

        public ColumnColletion GetColumnSchema(string table)
        {
            ColumnColletion cols = new ColumnColletion();
            var query = "SELECT * FROM @tbl LIMIT 0".Replace("@tbl", table);
            using (var con = GetNewConnection() as NpgsqlConnection)
            {
                try
                {
                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            int pos = 0;
                            foreach (NpgsqlDbColumn drow in reader.GetColumnSchema())
                            {
                                string columnName = System.Convert.ToString(drow["ColumnName"]);
                                var type = (Type)(drow["DataType"]);//for date and timstamp wihout tz return system.Datetime
                                EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType(type));
                                column.ColumnIndex = pos++;
                                cols.BaseAdd(column);
                            }
                        }
                    }
                }
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }
            }
            return cols;
        }

        //-----------Sql queries

        public string EB_INITROLE2USER { get { return "INSERT INTO eb_role2user(role_id, user_id, createdat) VALUES (@role_id, @user_id, now());"; } }
        public string EB_USER_ROLE_PRIVS { get { return "SELECT DISTINCT privilege_type FROM information_schema.role_table_grants WHERE grantee='@uname';"; } }
        public string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM eb_authenticate_unified(uname := @uname, password := @pass, wc := @wc);"; } }

        public string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM eb_authenticate_unified(social := @social, wc := @wc);"; } }

        public string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM eb_authenticate_unified(uname := @uname, wc := @wc);"; } }

        public string EB_AUTHENTICATE_ANONYMOUS { get { return "SELECT * FROM eb_authenticate_anonymous(@params in_appid := :appid ,in_wc := :wc);"; } }

        public string EB_SIDEBARUSER_REQUEST { get { return @"
SELECT id, applicationname,app_icon
                FROM eb_applications
                WHERE COALESCE(eb_del, 'F') = 'F' ORDER BY applicationname;

                SELECT
                    EO.id, EO.obj_type, EO.obj_name,
                    EOV.version_num, EOV.refid, EO2A.app_id, EO.obj_desc, EOS.status, EOS.id, display_name
                FROM
                    eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
                WHERE
                EOV.eb_objects_id = EO.id	
                AND EO.id = ANY('{:Ids}')               			    
				AND EOS.eb_obj_ver_id = EOV.id 
				AND EO2A.obj_id = EO.id
				AND EO2A.eb_del = 'F'
                AND EOS.status = 3 
                AND COALESCE( EO.eb_del, 'F') = 'F'
				AND EOS.id = ANY( Select MAX(id) from eb_objects_status EOS Where EOS.eb_obj_ver_id = EOV.id );
                SELECT object_id FROM eb_objects_favourites WHERE userid=:user_id AND eb_del='F'"; } }

        public string EB_SIDEBARDEV_REQUEST
        {
            get { return @"
SELECT id, applicationname,app_icon FROM eb_applications
                WHERE COALESCE(eb_del, 'F') = 'F' ORDER BY applicationname;
                            SELECT 
	                            EO.id, EO.obj_type, EO.obj_name, EO.obj_desc, COALESCE(EO2A.app_id, 0),display_name
                            FROM 
	                            eb_objects EO
                            LEFT JOIN
	                            eb_objects2application EO2A 
                            ON
	                            EO.id = EO2A.obj_id 
                            WHERE
	                           COALESCE(EO2A.eb_del, 'F') = 'F' 
                               AND COALESCE( EO.eb_del, 'F') = 'F'
                            ORDER BY 
	                            EO.obj_type;"; }
        }

        public string EB_SIDEBARCHECK { get { return "AND EO.id = ANY('{:Ids}') "; } }

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
								WHERE R.applicationid = A.id AND R.role_name ~* :searchtext AND A.eb_del = 'F';";
            }
        }
        public string EB_GETMANAGEROLESRESPONSE_QUERY { get { return @"
SELECT id, applicationname FROM eb_applications where eb_del = 'F' ORDER BY applicationname;
									SELECT DISTINCT EO.id, EO.display_name, EO.obj_type, EO2A.app_id
										FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
										WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
										AND EOS.id = ANY(SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id)
										AND EO.id = EO2A.obj_id AND EO2A.eb_del = 'F';
									SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> :id ORDER BY role_name;
									SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';
									SELECT id, longname, shortname FROM eb_locations;"; } }
        public string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get { return @"
SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = :id;
									SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = :id AND eb_del = 'F';
									SELECT A.applicationname, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = :id AND A.eb_del = 'F';
									SELECT A.id, A.fullname, A.email, B.id FROM eb_users A, eb_role2user B
										WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = :id;
									SELECT locationid FROM eb_role2location WHERE roleid = :id AND eb_del='F';"; } }
        public string EB_SAVEROLES_QUERY
        {
            get
            {
                return "SELECT eb_create_or_update_rbac_roles(:role_id, :applicationid, :createdby, :role_name, :description, :is_anonym, :users, :dependants, :permission, :locations " +
");";
            }
        }

        public string EB_SAVEUSER_QUERY { get { return "SELECT * FROM eb_security_user(:userid,:id,:fullname,:nickname,:email,:pwd,:dob,:sex,:alternateemail,:phprimary,:phsecondary,:phlandphone,:extension,:fbid,:fbname,:roles,:groups,:statusid,:hide,:anonymoususerid,:preference,:consadd,:consdel);"; } }
        public string EB_SAVEUSERGROUP_QUERY { get { return "SELECT * FROM eb_security_usergroup(:userid,:id,:name,:description,:users,:constraints_add,:constraints_del);"; } }

        public string EB_MANAGEUSER_FIRST_QUERY
        {
            get
            {
                return @"
SELECT id, role_name, description FROM eb_roles ORDER BY role_name;
                        SELECT id, name,description FROM eb_usergroup ORDER BY name;
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';";
            }
        }

        public string EB_GETUSERDETAILS
        {
            get
            {
                return @"
SELECT id,fullname,email 
                    FROM 
                        eb_users 
                    WHERE 
                        LOWER(fullname) LIKE LOWER('%' || :searchtext || '%') AND eb_del = 'F' 
                    ORDER BY fullname ASC;";
            }
        }

        public string EB_CREATEAPPLICATION_DEV
        {
            get
            {
                return @"
INSERT INTO eb_applications (applicationname,application_type, description,app_icon) VALUES (:applicationname,:apptype, :description,:appicon) RETURNING id;";
            }
        }

        public string EB_EDITAPPLICATION_DEV
        {
            get
            {
                return @"UPDATE 
                            eb_applications 
                        SET 
                            applicationname = :applicationname,
                            application_type = :apptype,
                            description = :description,
                            app_icon = :appicon
                        WHERE
                            id = :appid";
            }
        }

        public string EB_GETTABLESCHEMA
        {
            get
            {
                return @"
SELECT ACols.*, BCols.foreign_table_name, BCols.foreign_column_name 
                        FROM
                            (SELECT 
                                TCols.*, CCols.constraint_type 
                             FROM
                                (SELECT
                                    T.table_name, C.column_name, C.data_type
                                FROM 
                                    information_schema.tables T,
                                    information_schema.columns C
                                WHERE
                                    T.table_name = C.table_name AND
                                    T.table_schema='public'
                                ) TCols
                            LEFT JOIN
                                (SELECT 
                                    TC.table_name,TC.constraint_type,KCU.column_name 
                                FROM
                                    information_schema.table_constraints TC,
                                    information_schema.key_column_usage KCU
                                WHERE
                                    TC.constraint_name=KCU.constraint_name AND
                                    (TC.constraint_type = 'PRIMARY KEY' OR TC.constraint_type = 'FOREIGN KEY') AND
                                    TC.table_schema='public'
                                ) CCols
                             ON 
                                CCols.table_name=TCols.table_name AND
                                CCols.column_name=TCols.column_name
                            ) ACols
                        LEFT JOIN
                            (SELECT
                                tc.constraint_name, tc.table_name, kcu.column_name, 
                                ccu.table_name AS foreign_table_name,
                                ccu.column_name AS foreign_column_name 
                            FROM 
                                information_schema.table_constraints AS tc 
                            JOIN 
                                information_schema.key_column_usage AS kcu
                            ON 
                                tc.constraint_name = kcu.constraint_name
                            JOIN  
                                information_schema.constraint_column_usage AS ccu
                            ON 
                                ccu.constraint_name = tc.constraint_name
                            WHERE 
                                constraint_type = 'FOREIGN KEY' AND tc.table_schema='public'
                            ) BCols
                            ON
                                ACols.table_name=BCols.table_name AND  ACols.column_name=BCols.column_name
                        ORDER BY
                            table_name, column_name";
            }
        }

        public string EB_GET_CHART_2_DETAILS
        {
            get
            {
                return @"
SELECT created_at FROM eb_executionlogs WHERE refid = :refid AND created_at::TIMESTAMP::DATE =current_date";
            }
        }

        public string EB_GET_PROFILERS
        {
            get
            {
                return @"
SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = :refid);
                             SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid = :refid);
                             SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = :refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date));
                             SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid = :refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date));
                             SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid= :refid and created_at::date = current_date);
                             SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid= :refid and created_at::date = current_date);
                             SELECT COUNT(*) FROM eb_executionlogs WHERE refid = :refid;
                             SELECT COUNT(*) FROM eb_executionlogs WHERE created_at::date = current_date AND refid = :refid;
                             SELECT COUNT(*) FROM eb_executionlogs WHERE EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date) and refid = :refid;";
            }
        }

        public string EB_GETUSEREMAILS
        {
            get
            {
                return @"
SELECT id, email FROM eb_users WHERE id = ANY
                             (string_to_array(:userids,',')::int[]);
                           SELECT distinct id, email FROM eb_users WHERE id = ANY(SELECT userid FROM eb_user2usergroup WHERE 
                                groupid = ANY(string_to_array(:groupids,',')::int[])) ;";
            }
        }

        public string EB_GETPARTICULARSSURVEY
        {
            get
            {
                return @"
SELECT name,startdate,enddate,status FROM eb_surveys WHERE id = :id;
							SELECT * FROM
								(SELECT UNNEST(string_to_array(S.questions, ',')::int[]) AS q_id FROM eb_surveys S WHERE id = :id) QUES_IDS, 
								(SELECT Q.id, Q.query, Q.q_type FROM eb_survey_queries Q) QUES_ANS,
								(SELECT C.choice,C.score,C.id, C.q_id from eb_query_choices C WHERE eb_del = 'F' ) QUES_QRY
								WHERE QUES_IDS.q_id = QUES_ANS.id
									AND QUES_QRY.q_id = QUES_ANS.id";
            }
        }

        public string EB_SURVEYMASTER
        {
            get
            {
                return @"
INSERT INTO 
                        eb_survey_master(surveyid,userid,anonid,eb_createdate) 
                    VALUES
                        (:sid,:uid,:anid,now()) RETURNING id;";
            }
        }

        public string EB_CURRENT_TIMESTAMP
        {
            get
            {
                return @"CURRENT_TIMESTAMP AT TIME ZONE 'UTC'";
            }
        }

        public string EB_UPDATEAUDITTRAIL
        {
            get
            {
                return @"
INSERT INTO 
                            eb_audit_master(formid, dataid, actiontype, eb_createdby, eb_createdat) 
                        VALUES 
                            (:formid, :dataid, :actiontype, :eb_createdby, CURRENT_TIMESTAMP AT TIME ZONE 'UTC') RETURNING id;";
            }
        }

        public string EB_SAVESURVEY
        {
            get
            {
                return @"
INSERT INTO eb_surveys(name, startdate, enddate, status, questions) VALUES (:name, :start, :end, :status, :questions) RETURNING id;";
            }
        }

        public string EB_PROFILER_QUERY_COLUMN
        {
            get
            {
                return @"SELECT id, rows, exec_time, created_by, created_at FROM eb_executionlogs WHERE refid = :refid; ";
            }
        }

        public string EB_PROFILER_QUERY_DATA
        {
            get
            {
                return @"SELECT COUNT(id) FROM eb_executionlogs WHERE refid = :refid; 
                SELECT EL.id, EL.rows, EL.exec_time, EU.fullname, EL.created_at FROM eb_executionlogs EL, eb_users EU
                WHERE refid = :refid AND EL.created_by = EU.id
                LIMIT :limit OFFSET :offset; ";
            }
        }

        public string EB_GET_CHART_DETAILS
        {
            get
            {
                return @"SELECT rows, exec_time FROM eb_executionlogs WHERE refid = :refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date);";
            }
        }

        public string EB_INSERT_EXECUTION_LOGS
        {
            get
            {
                return @"INSERT INTO eb_executionlogs(rows, exec_time, created_by, created_at, params, refid) 
                                VALUES(:rows, :exec_time, :created_by, :created_at, :params, :refid);";
            }
        }

        // DBClient

        public string EB_GETDBCLIENTTTABLES
        {
            get { return @"
SELECT Q1.table_name, Q1.table_schema, i.indexname FROM 
                (SELECT
                    table_name, table_schema
                FROM
                    information_schema.tables s
                WHERE
                    table_schema != 'pg_catalog'
                    AND table_schema != 'information_schema'
                    AND table_type='BASE TABLE'
                    AND table_name NOT LIKE 'eb_%')Q1
                LEFT JOIN
                    pg_indexes i
                ON
                   Q1.table_name = i.tablename ORDER BY tablename;

                SELECT 
                    table_name, column_name, data_type
                FROM
                    information_schema.columns
                WHERE
                    table_schema != 'pg_catalog' AND
                    table_schema != 'information_schema' AND 
                    table_name NOT LIKE 'eb_%'
                ORDER BY table_name;

               SELECT
                   c.conname AS constraint_name,
                   c.contype AS constraint_type,
                   tbl.relname AS tabless,
                   ARRAY_AGG(col.attname
                   ORDER BY
                   u.attposition)
                   AS columns,
                   pg_get_constraintdef(c.oid) AS definition
               FROM 
                    pg_constraint c
               JOIN 
                    LATERAL UNNEST(c.conkey) WITH
                    ORDINALITY AS u(attnum, attposition) ON TRUE
               JOIN 
                    pg_class tbl ON tbl.oid = c.conrelid
               JOIN 
                    pg_namespace sch ON sch.oid = tbl.relnamespace
               JOIN 
                    pg_attribute col ON(col.attrelid = tbl.oid AND col.attnum = u.attnum)
               WHERE
                    tbl.relname NOT LIKE 'eb_%'
               GROUP BY 
                    constraint_name, constraint_type, tabless, definition
               ORDER BY 
                    tabless;";
            }
        }

       //.......OBJECTS QUERIES.....
        public string EB_FETCH_ALL_VERSIONS_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                        EOV.id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.commit_uid, EU.fullname
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
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
	                        EOS.id DESC 
                        LIMIT 1
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
                        AND COALESCE( EO.eb_del, 'F') = 'F'
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
                            EU.fullname, EO.display_name
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid=EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id AND EO.obj_type=:type
                            AND COALESCE( EO.eb_del, 'F') = 'F'
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
                            AND COALESCE( EO.eb_del, 'F') = 'F'
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
                            EU.fullname, EO.display_name
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid=EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id  AND EO.obj_type=:type AND COALESCE(EOV.working_mode, 'F') <> 'T'
                            AND COALESCE( EO.eb_del, 'F') = 'F'
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
                    AND COALESCE( eb_del, 'F') = 'F'
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
                            EOS.eb_obj_ver_id, EOS.status, EU.fullname, EOS.ts, EOS.changelog, EOV.commit_uid   
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
                            EO.id = :id AND EOV.eb_objects_id = EO.id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY EOV.eb_objects_id	LIMIT 1;";
            }
        }
        public string EB_GET_ALL_TAGS
        {
            get
            {
                return @"SELECT distinct(tags)
                    FROM (SELECT unnest(string_to_array(obj_tags, ',')) AS tags
	                      FROM eb_objects
                          WHERE COALESCE(eb_del, 'F') = 'F')
                    AS tags
                ";
            }
        }

        public string EB_GET_MLSEARCHRESULT
        {
            get
            {
                return @"SELECT count(*) FROM (SELECT * FROM eb_keys WHERE LOWER(key) LIKE LOWER(@KEY)) AS Temp;
											SELECT A.id, A.key, B.id, B.language, C.id, C.value
											FROM (SELECT * FROM eb_keys WHERE LOWER(key) LIKE LOWER(@KEY) ORDER BY key ASC OFFSET @OFFSET LIMIT @LIMIT) A,
													eb_languages B, eb_keyvalue C
											WHERE A.id=C.key_id AND B.id=C.lang_id  
											ORDER BY A.key ASC, B.language ASC;";
            }
        }

        public string EB_MLADDKEY
        {
            get
            {
                return @"INSERT INTO eb_keys (key) VALUES(@KEY) RETURNING id;";
            }
        }
              
        public string EB_GET_TAGGED_OBJECTS
        {
            get
            {
                return "SELECT * FROM eb_get_tagged_object(:tags);";
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
		                            EO.id =  ANY('{@Ids}') AND 
		                            EOS.status = 3 AND
		                            ( 	
			                            EO.obj_type = 16 OR
			                            EO.obj_type = 17
			                            OR EO.obj_type = 18
		                            )  AND
		                            EOTA.app_id = @appid AND
                                    EOTA.eb_del = 'F'
                                    AND COALESCE( EO.eb_del, 'F') = 'F'
                        ";
            }
        }

        public string IS_TABLE_EXIST
        {
            get
            {
                return @"SELECT EXISTS (SELECT 1 FROM   information_schema.tables WHERE  table_schema = 'public' AND table_name = :tbl);";
            }
        }

        public string EB_ALLOBJNVER
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.refid,
                            EU.fullname
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid=EU.id
                        WHERE
                            EO.id = ANY(string_to_array(:ids,',')::int[]) AND
                            EO.id = EOV.eb_objects_id AND COALESCE(EOV.working_mode, 'F') <> 'T'
                        ORDER BY
                            EO.obj_name; ";
            }
        }

        public string EB_CREATELOCATIONCONFIG1Q
        {
            get
            {
                return @"INSERT INTO eb_location_config (keys,isrequired,keytype,eb_del) VALUES(:keys,:isrequired,:type,'F') RETURNING id; ";
            }
        }

        public string EB_CREATELOCATIONCONFIG2Q
        {
            get
            {
                return @"UPDATE eb_location_config SET keys = :keys ,isrequired = :isrequired , keytype = :type WHERE id = :keyid; ";
            }
        }       

        //.....OBJECTS FUNCTION CALL......
        public string EB_CREATE_NEW_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_create_new_object(:obj_name, :obj_desc, :obj_type, :obj_cur_status, :obj_json::json, :commit_uid, :src_pid, :cur_pid, :relations, :issave, :tags, :app_id, :s_obj_id, :s_ver_id, :disp_name)
                ";
            }
        }
        public string EB_SAVE_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_save(:id, :obj_name, :obj_desc, :obj_type, :obj_json, :commit_uid, :relations, :tags, :app_id, :disp_name)
                ";
            }
        }
        public string EB_COMMIT_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_commit(:id, :obj_name, :obj_desc, :obj_type, :obj_json, :obj_changelog,  :commit_uid, :relations, :tags, :app_id, :disp_name)
                ";
            }
        }
        public string EB_EXPLORE_OBJECT
        {
            get
            {
                return @"
                    SELECT * FROM public.eb_objects_exploreobject(:id)                    
                ";
            }
        }
        public string EB_MAJOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_major_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations)
                ";
            }
        }
        public string EB_MINOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_minor_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations)
                ";
            }
        }
        public string EB_CHANGE_STATUS_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_objects_change_status(:id, :status, :commit_uid, :obj_changelog)
                ";
            }
        }
        public string EB_PATCH_VERSION_OF_OBJECT
        {
            get
            {
                return @" 
                    SELECT eb_object_create_patch_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations)
                ";
            }
        }
        public string EB_UPDATE_DASHBOARD
        {
            get
            {
                return @"   
                    SELECT * FROM eb_objects_update_Dashboard(:refid)
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

        public string EB_SAVELOCATION
        {
            get
            {
                return @"INSERT INTO eb_locations(longname,shortname,image,meta_json) VALUES(:lname,:sname,:img,:meta) RETURNING id;";
            }
        }

        public string EB_CREATEBOT
        {
            get
            {
                return @"SELECT * FROM eb_createbot(@solid, @name, @fullname, @url, @welcome_msg, @uid, @botid)";
            }
        }

        //....Files query

        public string EB_IMGREFUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id)
                         VALUES 
                            (:refid, :filestoreid, :length, :imagequality_id, :is_image, :imgmanpserid, :filedb_con_id) RETURNING id";
            }
        }

        public string EB_DPUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id)
                         VALUES 
                             (:refid, :filestoreid, :length, :imagequality_id, :is_image, :imgmanpserid, :filedb_con_id) RETURNING id;
                        UPDATE eb_users SET dprefid = :refid WHERE id=:userid";
            }
        }

        public string EB_LOGOUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id)
                        VALUES 
                            (:refid, :filestoreid, :length, :imagequality_id, :is_image, :imgmanpserid, :filedb_con_id) RETURNING id;
                        UPDATE eb_solutions SET logorefid = :refid WHERE isolution_id = :solnid;";
            }
        }

        public string Eb_MQ_UPLOADFILE
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, is_image, filedb_con_id)
                         VALUES 
                            (:refid, :filestoresid, :length, :is_image, :filedb_con_id) RETURNING id";
            }
        }

        //public string EB_FILEEXISTS
        //{
        //    get
        //    {
        //        return @"UPDATE eb_image_migration_counter 
        //                 SET
        //                    is_exist = @exist
        //                 WHERE
        //                    filename = @fname
        //                    AND customer_id = @cid 
        //                 RETURNING id";
        //    }
        //}

        public string EB_GETFILEREFID
        {
            get
            {
                return @"INSERT INTO
                            eb_files_ref (userid, filename, filetype, tags, filecategory) 
                         VALUES 
                            (@userid, @filename, @filetype, @tags, @filecategory) 
                        RETURNING id;";
            }
        }

        public string EB_UPLOAD_IDFETCHQUERY
        {
            get
            {
                return @"INSERT INTO
                            eb_files_ref (userid, filename, filetype, tags, filecategory, uploadts,context) 
                        VALUES 
                            (@userid, @filename, @filetype, @tags, @filecategory, NOW(),@context) 
                        RETURNING id";
            }
        }

        public string EB_SMSSERVICE_POST
        {
            get
            {
                return @"INSERT INTO logs_sms
                            (uri, send_to, send_from, message_body, status, error_message, user_id, context_id) 
                        VALUES 
                            (@uri, @to, @from, @message_body, @status, @error_message, @user_id, @context_id) RETURNING id";
            }
        }

        public string EB_FILECATEGORYCHANGE
        {
            get
            {
                return @"UPDATE 
	                        eb_files_ref FR
                        SET
	                        tags = jsonb_set(cast(tags as jsonb),
							'{Category}',
							(SELECT (cast(tags as jsonb)->'Category')-0 || to_jsonb(:categry::text)),
                            true)
                        WHERE 
                            FR.id = ANY(string_to_array(:ids,',')::int[]);";
            }
        }

        //....api query...
        public string EB_API_SQL_FUNC_HEADER
        {
            get
            {
                return @"CREATE OR REPLACE FUNCTION {0}(insert_json jsonb,update_json jsonb)
                            RETURNS void
                            LANGUAGE {1} AS $BODY$";
            }
        }

    }

    public class PGSQLFileDatabase : PGSQLDatabase, INoSQLDatabase
    {
        public PGSQLFileDatabase(EbDbConfig dbconf) : base(dbconf)
        {
            InfraConId = dbconf.Id;
        }

        public int InfraConId { get; set; }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory cat)
        {
            byte[] filebyte = null;
            int ifileid;
            Int32.TryParse(filestoreid, out ifileid);
            try
            {
                using (NpgsqlConnection con = GetNewConnection() as NpgsqlConnection)
                {
                    con.Open();
                    string sql = "SELECT bytea FROM eb_files_bytea WHERE id = :filestore_id AND filecategory = :cat;";
                    NpgsqlCommand cmd = new NpgsqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter(":filestore_id", EbDbTypes.Int32, ifileid));
                    cmd.Parameters.Add(GetNewParameter(":cat", EbDbTypes.Int32, (int)cat));
                    filebyte = (byte[])cmd.ExecuteScalar();
                }
            }
            catch (NpgsqlException npg)
            {
                Console.WriteLine("Exception :  " + npg.Message);
            }
            return filebyte;
        }

        public byte[] DownloadFileByName(string filename, EbFileCategory cat)
        {
            byte[] filebyte = null;
            try
            {
                using (NpgsqlConnection con = GetNewConnection() as NpgsqlConnection)
                {
                    con.Open();
                    string sql = "SELECT bytea FROM eb_files_bytea WHERE filename = :filename AND filecategory = :cat;";
                    NpgsqlCommand cmd = new NpgsqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter(":filename", EbDbTypes.String, filename));
                    cmd.Parameters.Add(GetNewParameter(":cat", EbDbTypes.Int32, (int)cat));
                    filebyte = (byte[])cmd.ExecuteScalar();
                }
            }
            catch (NpgsqlException npg)
            {
                Console.WriteLine("Exception :  " + npg.Message);
            }
            return filebyte;
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory cat)
        {
            Console.WriteLine("Before PostGre Upload File");

            int rtn = 0;
            try
            {
                using (NpgsqlConnection con = GetNewConnection() as NpgsqlConnection)
                {
                    con.Open();
                    string sql = "INSERT INTO eb_files_bytea (filename, bytea, filecategory) VALUES (:filename, :bytea, :cat) returning id;";
                    NpgsqlCommand cmd = new NpgsqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter(":filename", EbDbTypes.String, filename));
                    cmd.Parameters.Add(GetNewParameter(":bytea", EbDbTypes.Bytea, bytea));
                    cmd.Parameters.Add(GetNewParameter(":cat", EbDbTypes.Int32, (int)cat));
                    Int32.TryParse(cmd.ExecuteScalar().ToString(), out rtn);
                }
            }
            catch (NpgsqlException npg)
            {
                Console.WriteLine("Exception :  " + npg.Message);
            }
            Console.WriteLine("After PostGre Upload File , fileStore id: " + rtn.ToString());
            return rtn.ToString();
        }
    }
}