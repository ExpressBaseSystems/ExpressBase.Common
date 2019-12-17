﻿using System.Data.SqlClient;
using System.Data;

using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Text;
using System.Data.Common;
using ExpressBase.Common.Connections;
using System.Collections.ObjectModel;
using ExpressBase.Common.Enums;

namespace ExpressBase.Common.Data.MSSQLServer
{
    public class MSSQLEbDbTypes : IVendorDbTypes
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

        private MSSQLEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, SqlDbType.Text, "text"));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, SqlDbType.Binary, "binary"));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, SqlDbType.Char, "char"));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, SqlDbType.Date, "datetime"));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, SqlDbType.DateTimeOffset + "(4)", "datetimeoffset(4)"));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, SqlDbType.Decimal, "decimal"));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, SqlDbType.Real, "double precision"));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, SqlDbType.SmallInt, "smallint"));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, SqlDbType.Int, "integer"));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, SqlDbType.BigInt, "bigint"));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, SqlDbType.NVarChar, "nvarchar(max)"));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, SqlDbType.Text, "text"));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, SqlDbType.Time, "time"));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, SqlDbType.Float, "numeric"));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, SqlDbType.NVarChar, "jsonb"));
            this.InnerDictionary.Add(EbDbTypes.Bytea, new VendorDbType(EbDbTypes.Bytea, SqlDbType.Image, "bytea"));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, SqlDbType.Bit, "char"));
            this.InnerDictionary.Add(EbDbTypes.BooleanOriginal, new VendorDbType(EbDbTypes.BooleanOriginal, SqlDbType.Bit, "bool"));
        }

        public static IVendorDbTypes Instance => new MSSQLEbDbTypes();

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

    public class MSSQLDatabase : IDatabase
    {
        public DatabaseVendors Vendor
        {
            get
            {
                return DatabaseVendors.MSSQL;
            }
        }

        public IVendorDbTypes VendorDbTypes
        {
            get
            {
                return MSSQLEbDbTypes.Instance;
            }
        }

        private const string CONNECTION_STRING_BARE = "Server = {0}; Database = {1}; User Id = {2}; Password = {3};";
        //private const string CONNECTION_STRING_BARE = "Data Source = {0};Initial Catalog = {1}; User ID = {2}; Password = {3}; Trusted_Connection=True; Integrated Security=False";
        private string _cstr;
        private EbDbConfig DbConfig { get; set; }
        public string DBName { get; }

        
        public MSSQLDatabase(EbDbConfig dbconf)
        {
            this.DbConfig = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, this.DbConfig.DatabaseName, this.DbConfig.UserName, this.DbConfig.Password);
            DBName = DbConfig.DatabaseName;
        }

        public DbConnection GetNewConnection(string dbName)
        {
            var con = new SqlConnection(string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, dbName, this.DbConfig.UserName, this.DbConfig.Password));
            return con;
        }

        public DbConnection GetNewConnection()
        {
            return new SqlConnection(_cstr);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new SqlCommand(sql, (SqlConnection)con);
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

                return new SqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = val };
            }
            catch (Exception ex)
            {
                Console.WriteLine(string.Format("Exception in GetNewParameter : Message = {0}\n parametername = {1}\n type = {2} \n value = {3}", ex.Message, parametername, type.ToString(), value.ToString()));
                throw new Exception(ex.Message);
            }
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new SqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
        }

        public System.Data.Common.DbParameter GetNewOutParameter(string parametername, EbDbTypes type)
        {
            return new SqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Output };
        }

        public EbDataTable DoQuery(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();

            using (SqlConnection con = dbConnection as SqlConnection)
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
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
                catch (Exception e)
                {
                    Console.WriteLine("SQL Server Exception: " + e.Message);
                    throw e;
                }
            }

            return dt;
        }

        public EbDataSet DoQueries(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            var dtStart = DateTime.Now;
            Console.WriteLine(string.Format("DoQueries Start Time : {0}", dtStart));
            EbDataSet ds = new EbDataSet();
            ds.RowNumbers = "";
            try
            {
                DbConnection con = dbConnection;
                using (var reader = this.DoQueriesBasic(con, query, parameters))
                {
                    var dtExeTime = DateTime.Now;
                    Console.WriteLine(string.Format("DoQueries Execution Time : {0}", dtExeTime));
                    do
                    {
                        try
                        {
                            EbDataTable dt = new EbDataTable();
                            DataTable schema = reader.GetSchemaTable();
                            if (schema != null)
                            {
                                this.AddColumns(dt, schema);
                                PrepareDataTable((SqlDataReader)reader, dt);
                            }
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
            catch (Exception e)
            {
                throw e;
            }

            var dtEnd = DateTime.Now;
            Console.WriteLine(string.Format("DoQueries End Time : {0}", dtEnd));

            var ts = (dtEnd - dtStart).TotalMilliseconds;
            Console.WriteLine(string.Format("DoQueries Execution Time : {0}", ts));
            ds.RowNumbers = ds.RowNumbers.Substring(0, ds.RowNumbers.Length - 1)/*(ds.RowNumbers.Length>3)?ds.RowNumbers.Substring(0, ds.RowNumbers.Length - 3): ds.RowNumbers*/;
            ds.StartTime = dtStart;
            ds.EndTime = dtEnd;
            return ds;
        }

        public EbDataTable DoProcedure(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            EbDataTable tbl = new EbDataTable();
            int index = query.IndexOf("(");
            string procedure_name = query.Substring(0, index);
            try
            {
                SqlConnection con = dbConnection as SqlConnection;

                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandText = procedure_name;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.Parameters.AddRange(parameters);
                    var reader = cmd.ExecuteNonQuery();

                    tbl.Rows.Add(new EbDataRow());
                    int i = 0;
                    foreach (var param in parameters)
                    {
                        if (param.Direction == ParameterDirection.Output)
                        {
                            tbl.Columns.Add(new EbDataColumn(i++, param.ParameterName, (EbDbTypes)param.DbType));
                            tbl.Rows[0][param.ParameterName] = cmd.Parameters["@" + param.ParameterName].Value;
                        }
                    }
                    return tbl;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("SQLServer Exception : " + e.Message);
                throw e;
            }

            return null;
        }

        public DbDataReader DoQueriesBasic(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            var con = dbConnection as SqlConnection;
            try
            {
                using (SqlCommand cmd = new SqlCommand(query, con))
                {
                    if (parameters != null && parameters.Length > 0)
                        cmd.Parameters.AddRange(parameters);
                    cmd.Prepare();
                    return cmd.ExecuteReader(CommandBehavior.KeyInfo);
                }
            }
            catch (Exception e)
            {
                throw e;
            }

            return null;
        }

        public int DoNonQuery(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            using (var con = dbConnection as SqlConnection)
            {
                try
                {
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return 0;
        }

        public T DoQuery<T>(string query, params DbParameter[] parameters)
        {
            T obj = default(T);

            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
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
                catch (Exception e)
                {

                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return obj;
        }

        public EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();

            try
            {
                SqlConnection con = GetNewConnection() as SqlConnection;
                con.Open();
                dt = DoQuery(con, query, parameters);
                con.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("SQL Server Exception: " + e.Message);
                throw e;
            }

            return dt;
        }

        public EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();

            try
            {
                SqlConnection con = GetNewConnection() as SqlConnection;
                con.Open();
                ds = DoQueries(con, query, parameters);
                con.Close();
            }
            catch (Exception e)
            {
                Console.WriteLine("SQL Server Exception: " + e.Message);
                throw e;
            }

            return ds;
        }

        public EbDataTable DoProcedure(string query, params DbParameter[] parameters)
        {
            EbDataTable tbl = new EbDataTable();
            try
            {
                SqlConnection con = GetNewConnection() as SqlConnection;
                con.Open();
                tbl = DoProcedure(con, query, parameters);
                con.Close();
            }
            catch (SqlException myexec)
            {
                throw myexec;
            }
            return tbl;
        }

        public int DoNonQuery(string query, params DbParameter[] parameters)
        {
            var con = GetNewConnection() as SqlConnection;
            int val = 0;
            try
            {
                con.Open();
                val = DoNonQuery(con, query, parameters);
                con.Close();
            }
            catch (Exception e)
            {
                throw e;
            }

            return val;
        }

        public Dictionary<int, string> GetDictionary(string query, string dm, string vm)
        {
            Dictionary<int, string> _dic = new Dictionary<int, string>();
            string sql = $"SELECT {vm},{dm} FROM ({query.Replace(";", string.Empty)}) as __table;";

            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                if (!_dic.ContainsKey(Convert.ToInt32(reader[vm])))
                                    _dic.Add(Convert.ToInt32(reader[vm]), reader[dm].ToString());
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("SQL Server Exception: " + e);
                    throw e;
                }
                //catch (SocketException scket)
                //{
                //}
            }

            return _dic;
        }

        public List<int> GetAutoResolveValues(string query, string vm, string cond)
        {
            List<int> _list = new List<int>();
            string sql = $"SELECT {vm} FROM ({query.Replace(";", string.Empty)}) as __table WHERE {cond};";

            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            while (reader.Read())
                            {
                                if (!_list.Contains(Convert.ToInt32(reader[vm])))
                                    _list.Add(Convert.ToInt32(reader[vm]));
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine("SQL Server Exception: " + e.Message);
                    throw e;
                }
                //catch (SocketException scket)
                //{
                //}
            }

            return _list;
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
            else if (_typ == typeof(decimal) || _typ == typeof(Double) || _typ == typeof(Single))
                return EbDbTypes.Decimal;
            else if (_typ == typeof(int) || _typ == typeof(Int32) || _typ == typeof(Int16))
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

        private void PrepareDataTable(SqlDataReader reader, EbDataTable dt)
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

        public bool IsTableExists(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return Convert.ToBoolean(cmd.ExecuteScalar());
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return false;
        }

        public int CreateTable(string query)
        {
            int res = 0;
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        res = cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }
            return res;
        }

        public int InsertTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return 0;
        }

        public int UpdateTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return 0;
        }

        public int AlterTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return 0;
        }

        public int DeleteTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }

            return 0;
        }

        public ColumnColletion GetColumnSchema(string table)
        {
            ColumnColletion cols = new ColumnColletion();
            var query = "SELECT * FROM @tbl LIMIT 0".Replace("@tbl", table);
            using (var con = GetNewConnection() as SqlConnection)
            {
                try
                {
                    con.Open();
                    using (SqlCommand cmd = new SqlCommand(query, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            int pos = 0;

                            foreach (DataRow dr in reader.GetSchemaTable().Rows)
                            {
                                string columnName = System.Convert.ToString(dr["ColumnName"]);
                                Type type = (Type)(dr["DataType"]);
                                EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType(type));
                                column.ColumnIndex = pos++;
                                cols.BaseAdd(column);
                            }
                        }
                    }
                }
                catch (Exception e)
                {
                    throw e;
                }
                //catch (SocketException scket) { }
            }
            return cols;
        }

        public string EB_AUTHETICATE_USER_NORMAL
        {
            get
            {
                return @" eb_authenticate_unified @uname, @pwd, @social, @wc, @ipaddress, @deviceinfo, @tmp_userid, @tmp_status_id, @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraints_a, @tmp_signin_id;";
            }
        }

        public string EB_AUTHENTICATEUSER_SOCIAL
        {
            get
            {
                return @"eb_authenticate_unified @uname, @pwd, @social, @wc, @ipaddress, @deviceinfo, @tmp_userid, @tmp_status_id, @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraints_a, @tmp_signin_id;";
            }
        }

        public string EB_AUTHENTICATEUSER_SSO
        {
            get
            {
                return @"eb_authenticate_unified @uname, @pwd, @social, @wc, @ipaddress, @deviceinfo, @tmp_userid, @tmp_status_id, @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraints_a, @tmp_signin_id;";
            }
        }

        public string EB_AUTHENTICATE_ANONYMOUS
        {
            get
            {
                return @"eb_authenticate_anonymous @in_socialid, @in_fullname, @in_emailid, @in_phone, @in_user_ip, @in_user_browser,@in_city, @in_region, @in_country, 
                            @in_latitude, @in_longitude, @in_timezone, @in_iplocationjson, @in_appid, @in_wc, @out_userid, @out_status_id, @out_email, @out_fullname, @out_roles_a, 
                            @out_rolename_a, @out_permissions, @out_preferencesjson, @out_constraints_a, @out_signin_id ;";
            }
        }

        public string EB_SIDEBARUSER_REQUEST
        {
            get
            {
                return @"SELECT id, applicationname,app_icon
                            FROM eb_applications
                            WHERE COALESCE(eb_del, 'F') = 'F' ORDER BY applicationname;
                        SELECT EO.id, EO.obj_type, EO.obj_name,
                               EOV.version_num, EOV.refid, EO2A.app_id, EO.obj_desc, EOS.status, EOS.id, display_name
                            FROM
                                eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
                            WHERE
                            EOV.eb_objects_id = EO.id	
                            AND EO.id = ANY('{@Ids}')               			    
				            AND EOS.eb_obj_ver_id = EOV.id 
				            AND EO2A.obj_id = EO.id
				            AND EO2A.eb_del = 'F'
                            AND EOS.status = 3 
                            AND COALESCE( EO.eb_del, 'F') = 'F'
				            AND EOS.id = ANY( Select MAX(id) from eb_objects_status EOS Where EOS.eb_obj_ver_id = EOV.id );
                        SELECT object_id FROM eb_objects_favourites WHERE userid = @user_id AND eb_del = 'F'";
            }
        }
        // only for mysql
        public string EB_SIDEBARUSER_REQUEST_SOL_OWNER { get { return @""; } }

        public string EB_SIDEBARDEV_REQUEST
        {
            get
            {
                return @"SELECT id, applicationname,app_icon FROM eb_applications
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
	                            EO.obj_type;";
            }
        }

        public string EB_SIDEBARCHECK { get { return @""; } }

        public string EB_GETROLESRESPONSE_QUERY
        {
            get
            {
                return @"SELECT R.id,R.role_name,R.description,A.applicationname,
									(SELECT COUNT(role1_id) FROM eb_role2role WHERE role1_id=R.id AND eb_del = 'F') AS subrole_count,
									(SELECT COUNT(user_id) FROM eb_role2user WHERE role_id=R.id AND eb_del = 'F') AS user_count,
									(SELECT COUNT(distinct permissionname) FROM eb_role2permission RP, eb_objects2application OA WHERE role_id = R.id AND app_id=A.id AND RP.obj_id=OA.obj_id AND RP.eb_del = 'F' AND OA.eb_del = 'F') AS permission_count
								FROM eb_roles R, eb_applications A
								WHERE R.applicationid = A.id AND R.role_name like CONCAT('%',@searchtext,'%') AND A.eb_del = 'F';";
            }
        }

        public string EB_GETMANAGEROLESRESPONSE_QUERY
        {
            get
            {
                return @"SELECT id, applicationname FROM eb_applications where eb_del = 'F' ORDER BY applicationname;
                        SELECT DISTINCT EO.id, EO.display_name, EO.obj_type, EO2A.app_id
                                FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
								WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
									AND EOS.id = ANY(SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id)
									AND EO.id = EO2A.obj_id AND EO2A.eb_del = 'F';
						SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> @id ORDER BY role_name;
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';
						SELECT id, longname, shortname FROM eb_locations;";
            }
        }

        public string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED
        {
            get
            {
                return @"SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = @id;
                        SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = @id AND eb_del = 'F';
                        SELECT A.applicationname, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = @id AND A.eb_del = 'F';
                        SELECT A.id, A.fullname, A.email, B.id FROM eb_users A, eb_role2user B
                            WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = @id;
                        SELECT locationid FROM eb_role2location WHERE roleid = @id AND eb_del='F';";
            }
        }

        public string EB_SAVEROLES_QUERY
        { get { return @""; } }

        public string EB_SAVEUSER_QUERY { get { return @""; } }

        public string EB_SAVEUSERGROUP_QUERY { get { return @""; } }

        public string EB_USER_ROLE_PRIVS
        {
            get
            {
                return @"SELECT 
                            [database_role] = UPPER(rp.[name])  COLLATE Latin1_General_CI_AS
                        FROM
                            sys.database_role_members drm
                        JOIN
                            sys.database_principals rp 
                        ON
                            (drm.role_principal_id = rp.principal_id)
                        JOIN
                            sys.database_principals mp 
                        ON
                            (drm.member_principal_id = mp.principal_id)
                        WHERE
                            mp.name = '@uname'
                        UNION
                        SELECT 
                            [database_role] = UPPER(dp.[permission_name] ) COLLATE Latin1_General_CI_AS
                        FROM  
                            sys.database_principals p,sys.database_permissions dp  
                        WHERE
                            p.principal_id = dp.grantee_principal_id AND p.name = '@uname'
";
            }
        }

        public string EB_INITROLE2USER
        {
            get
            {
                return @"INSERT INTO eb_role2user(role_id, user_id, createdat) VALUES (@role_id, @user_id, CURRENT_TIMESTAMP);";
            }
        }

        public string EB_MANAGEUSER_FIRST_QUERY
        {
            get
            {
                return @"SELECT id, role_name, description FROM eb_roles ORDER BY role_name;
                        SELECT id, name,description FROM eb_usergroup ORDER BY name;
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';";
            }
        }

        public string EB_GETUSERGROUP_QUERY_WITHOUT_SEARCHTEXT
        { get { return @""; } }

        public string EB_GETUSERDETAILS
        {
            get
            {
                return @"SELECT id,fullname,email FROM eb_users 
                            WHERE LOWER(fullname) LIKE LOWER(CONCAT('%', @searchtext,'%')) AND eb_del = 'F' 
                            ORDER BY fullname ASC;";
            }
        }

        public string EB_GET_MYPROFILE_OBJID
        {
            get
            {
                return @"";
            }
        }

        public string EB_CREATEAPPLICATION_DEV
        {
            get
            {
                return @"INSERT INTO eb_applications (applicationname,application_type, description,app_icon) OUTPUT INSERTED.ID
                            VALUES (@applicationname, @apptype, @description, @appicon);";
            }
        }

        public string EB_EDITAPPLICATION_DEV
        {
            get
            {
                return @"UPDATE 
                            eb_applications 
                        SET 
                            applicationname = @applicationname,
                            application_type = @apptype,
                            description = @description,
                            app_icon = @appicon
                        WHERE
                            id = @appid";
            }
        }

        public string EB_GETTABLESCHEMA
        { get { return @""; } }

        public string EB_GET_CHART_2_DETAILS
        {
            get
            {
                return @"SELECT created_at FROM eb_executionlogs WHERE refid = @refid AND CAST(created_at AS date) = CAST(GETDATE() AS DATE);";
            }
        }

        public string EB_GET_PROFILERS
        {
            get
            {
                return @"SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = @refid);
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid = @refid);
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = @refid AND MONTH(created_at) = MONTH(GETDATE()));
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid = @refid AND MONTH(created_at) = MONTH(GETDATE()));
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid= @refid and CAST(created_at AS DATE) = CAST(GETDATE() AS DATE));
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid= @refid and CAST(created_at AS DATE) = CAST(GETDATE() AS DATE));
                        SELECT COUNT(*) FROM eb_executionlogs WHERE refid = @refid;
                        SELECT COUNT(*) FROM eb_executionlogs WHERE CAST(created_at AS DATE) = CAST(GETDATE() AS DATE) AND refid = @refid;
                        SELECT COUNT(*) FROM eb_executionlogs WHERE MONTH(created_at) = MONTH(GETDATE()) and refid = @refid; ";
            }
        }

        public string EB_GETUSEREMAILS
        { get { return @""; } }

        public string EB_GETPARTICULARSSURVEY
        { get { return @""; } }

        public string EB_SURVEYMASTER
        {
            get
            {
                return @"INSERT INTO eb_survey_master(surveyid,userid,anonid,eb_createdate) OUTPUT INSERTED.ID
                            VALUES(@sid,@uid,@anid,GETDATE())";
            }
        }

        public string EB_CURRENT_TIMESTAMP
        {
            get
            {
                return @"GETUTCDATE()";
            }
        }

        public string EB_SAVESURVEY
        {
            get
            {
                return @"INSERT INTO eb_surveys(name, startdate, enddate, status, questions) OUTPUT INSERTED.ID 
                            VALUES (@name, @start, @end, @status, @questions);";
            }
        }

        public string EB_PROFILER_QUERY_COLUMN
        {
            get
            {
                return @"SELECT id, rows, exec_time, created_by, created_at FROM eb_executionlogs WHERE refid = @refid;";
            }
        }

        public string EB_PROFILER_QUERY_DATA
        {
            get
            {
                return @"SELECT COUNT(id) FROM eb_executionlogs WHERE refid = @refid; 
                        SELECT EL.id, EL.rows, EL.exec_time, EU.fullname, EL.created_at FROM eb_executionlogs EL, eb_users EU
                            WHERE refid = @refid AND EL.created_by = EU.id
                            OFFSET @OFFSET ROWS FETCH NEXT @LIMIT ROWS ONLY;";
            }
        }

        public string EB_GET_CHART_DETAILS
        {
            get
            {
                return @"SELECT rows, exec_time FROM eb_executionlogs WHERE refid = @refid AND MONTH(created_at) = MONTH(GETDATE());";
            }
        }

        public string EB_INSERT_EXECUTION_LOGS
        {
            get
            {
                return @"INSERT INTO eb_executionlogs(rows, exec_time, created_by, created_at, params, refid) 
                            VALUES(@rows, @exec_time, @created_by, @created_at, @params, @refid);";
            }
        }

        public string EB_GET_MOB_MENU_OBJ_IDS
        {
            get
            {
                return @"";
            }
        }

        public string EB_GET_MOBILE_PAGES
        {
            get
            {
                return @"";
            }
        }

        public string EB_GET_USER_DASHBOARD_OBJECTS
        {
            get
            {
                return @"";
            }
        }

        // DBClient

        public string EB_GETDBCLIENTTTABLES
        { get { return @""; } }

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
                            EOV.commit_uid = EU.id 
                            AND EOV.eb_objects_id = (SELECT eb_objects_id FROM eb_objects_ver WHERE refid = @refid)
                        ORDER BY
                            EOV.id DESC";
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
                            EOV.refid = @refid AND EOS.eb_obj_ver_id = EOV.id AND EO.id=EOV.eb_objects_id
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
	                        EOS.id DESC 
                        OFFSET 0 ROW FETCH NEXT 1 ROW ONLY";
            }
        }

        public string EB_LATEST_COMMITTED_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status, EO.obj_desc, EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, 
                            EOV.commit_uid, EOV.obj_json, EOV.refid
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        WHERE
                            EO.id = EOV.eb_objects_id AND EOV.refid = @refid
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
                            EO.obj_type";
            }
        }

        public string EB_COMMITTED_VERSIONS_OF_ALL_OBJECTS_OF_A_TYPE
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
	                        EOV.commit_uid = EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id AND EO.obj_type = @type
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
                            EO.obj_name";
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
                                                  WHERE dominant = @dominant))
                            AND EOV.refid = ANY(SELECT dependant FROM eb_objects_relations WHERE dominant = @dominant)    
                            AND EO.id = EOV.eb_objects_id  AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17)
                            AND COALESCE( EO.eb_del, 'F') = 'F' ";
            }
        }

        public string EB_GET_TAGGED_OBJECTS
        {
            get
            {
                return @"";
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
	                        EOV.commit_uid = EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id  AND EO.obj_type = @type AND COALESCE(EOV.working_mode, 'F') <> 'T'
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
                            EO.obj_name, EOV.id";
            }
        }

        public string EB_GET_OBJECTS_OF_A_TYPE
        {
            get
            {
                return @"SELECT 
                    id, obj_name, obj_type, obj_cur_status, obj_desc  
                FROM 
                    eb_objects
                WHERE
                    obj_type = @type
                    AND COALESCE( eb_del, 'F') = 'F'
                ORDER BY
                    obj_name";
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
                            eb_obj_ver_id = EOV.id AND EOV.refid = @refid AND EOV.commit_uid=EU.id
                        ORDER BY 
                            EOS.id DESC";
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
                            EO.id = @id AND EOV.eb_objects_id = EO.id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY EOV.eb_objects_id	
                            OFFSET 0 ROW FETCH NEXT 1 ROW ONLY;";
            }
        }

        public string EB_GET_ALL_TAGS
        {
            get
            {
                return @"";
            }
        }

        public string EB_GET_MLSEARCHRESULT
        {
            get
            {
                return @"SELECT count(*) FROM (SELECT * FROM eb_keys WHERE LOWER(""key"") LIKE LOWER(@KEY)) AS Temp;
                        SELECT A.id, A.""key"", B.id, B.language, C.id, C.value
                            FROM (SELECT * FROM eb_keys 
                                    WHERE LOWER(""key"") LIKE LOWER(@KEY) 
                                    ORDER BY ""key"" ASC 
                                        OFFSET @OFFSET ROWS FETCH NEXT @LIMIT ROWS ONLY) A,
                                eb_languages B, eb_keyvalue C
                            WHERE A.id=C.key_id AND B.id=C.lang_id  
                            ORDER BY A.""key"" ASC, B.language ASC;";
            }
        }

        public string EB_MLADDKEY
        {
            get
            {
                return @"INSERT INTO eb_keys(""key"") OUTPUT INSERTED.ID VALUES(@KEY);";
            }
        }

        public string EB_GET_BOT_FORM
        {
            get
            {
                return @"";
            }
        }
        public string IS_TABLE_EXIST
        {
            get
            {
                return @"SELECT 1 FROM  INFORMATION_SCHEMA.TABLES WHERE TABLE_SCHEMA = 'dbo' AND TABLE_NAME = @tbl;";
            }
        }

        public string EB_ALLOBJNVER
        { get { return @""; } }

        public string EB_CREATELOCATIONCONFIG1Q
        {
            get
            {
                return @"INSERT INTO eb_location_config(keys,isrequired,keytype,eb_del) output inserted.id VALUES(@keys,@isrequired,@type,'F')";
            }
        }

        public string EB_CREATELOCATIONCONFIG2Q
        {
            get
            {
                return @"UPDATE eb_location_config SET keys = @keys ,isrequired = @isrequired , keytype = @type WHERE id = @keyid;";
            }
        }

        public string EB_GET_DISTINCT_VALUES
        {
            get
            {
                return @"SELECT DISTINCT TRIM(@ColumName) AS @ColumName FROM @TableName ORDER BY @ColumName;";
            }
        }

        //.....OBJECTS FUNCTION CALL......

        public string EB_CREATE_NEW_OBJECT
        { get { return @""; } }
        public string EB_SAVE_OBJECT
        { get { return @""; } }
        public string EB_COMMIT_OBJECT
        { get { return @""; } }
        public string EB_EXPLORE_OBJECT
        { get { return @""; } }
        public string EB_MAJOR_VERSION_OF_OBJECT
        { get { return @""; } }
        public string EB_MINOR_VERSION_OF_OBJECT
        { get { return @""; } }
        public string EB_CHANGE_STATUS_OBJECT
        { get { return @""; } }
        public string EB_PATCH_VERSION_OF_OBJECT
        { get { return @""; } }
        public string EB_UPDATE_DASHBOARD
        { get { return @""; } }
        public string EB_LOCATION_CONFIGURATION
        { get { return @""; } }

        public string EB_SAVELOCATION
        {
            get
            {
                return @"INSERT INTO eb_locations(longname,shortname,image,meta_json) OUTPUT INSERTED.ID VALUES(@lname,@sname,@img,@meta);";
            }
        }

        public string EB_CREATEBOT
        { get { return @""; } }

        //....Files query

        public string EB_IMGREFUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id) OUTPUT INSERTED.ID
                            VALUES (@refid, @filestoreid, @length, @imagequality_id, @is_image, @imgmanpserid, @filedb_con_id)";
            }
        }

        public string EB_DPUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id) OUTPUT INSERTED.ID
                         VALUES (@refid, @filestoreid, @length, @imagequality_id, @is_image, @imgmanpserid, @filedb_con_id);
                        UPDATE eb_users SET dprefid = @refid WHERE id=@userid";
            }
        }

        public string EB_LOGOUPDATESQL
        { get { return @""; } }

        public string Eb_MQ_UPLOADFILE
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations (eb_files_ref_id, filestore_sid, length, is_image, filedb_con_id) OUTPUT INSERTED.ID
                         VALUES (@refid, @filestoresid, @length, @is_image, @filedb_con_id)";
            }
        }

        public string EB_GETFILEREFID
        {
            get
            {
                return @"INSERT INTO eb_files_ref (userid, filename, filetype, tags, filecategory) OUTPUT INSERTED.ID
                         VALUES (@userid, @filename, @filetype, @tags, @filecategory)";
            }
        }

        public string EB_UPLOAD_IDFETCHQUERY
        {
            get
            {
                return @"INSERT INTO eb_files_ref (userid, filename, filetype, tags, filecategory, uploadts,context) OUTPUT INSERTED.ID
                        VALUES(@userid, @filename, @filetype, @tags, @filecategory, GETDATE(), @context) ";
            }
        }

        public string EB_SMSSERVICE_POST
        { get { return @""; } }

        public string EB_FILECATEGORYCHANGE
        { get { return @""; } }

        //....api query...
        public string EB_API_SQL_FUNC_HEADER
        { get { return @""; } }

        public string EB_PARAM_SYMBOL
        {
            get
            {
                return "@";
            }
        }
    }

    public class MSSQLServerFilesDB : MSSQLDatabase, INoSQLDatabase
    {
        public MSSQLServerFilesDB(EbDbConfig dbconf) : base(dbconf)
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
                using (SqlConnection con = GetNewConnection() as SqlConnection)
                {
                    con.Open();
                    string sql = "SELECT bytea FROM eb_files_bytea WHERE id = @filestore_id AND filecategory = @cat;";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter("filestore_id", EbDbTypes.Int32, ifileid));
                    cmd.Parameters.Add(GetNewParameter("cat", EbDbTypes.Int32, (int)cat));
                    filebyte = (byte[])cmd.ExecuteScalar();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception :  " + e.Message);
            }
            return filebyte;
        }

        public byte[] DownloadFileByName(string filename, EbFileCategory cat)
        {
            byte[] filebyte = null;
            try
            {
                using (SqlConnection con = GetNewConnection() as SqlConnection)
                {
                    con.Open();
                    string sql = "SELECT bytea FROM eb_files_bytea WHERE filename = @filename AND filecategory = @cat;";
                    SqlCommand cmd = new SqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter("filename", EbDbTypes.String, filename));
                    cmd.Parameters.Add(GetNewParameter("cat", EbDbTypes.Int32, (int)cat));
                    filebyte = (byte[])cmd.ExecuteScalar();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception :  " + e.Message);
            }
            return filebyte;
        }


        public string UploadFile(string filename, byte[] bytea, EbFileCategory cat)
        {
            Console.WriteLine("Before MSSQLServer Upload File");

            string rtn = null;
            try
            {
                using (SqlConnection con = GetNewConnection() as SqlConnection)
                {
                    con.Open();
                    string sql = @"INSERT INTO eb_files_bytea(filename, bytea, filecategory) output inserted.id VALUES(@filename, @bytea, @cat);";

                    using (SqlCommand cmd = new SqlCommand(sql, con))
                    {
                        cmd.Parameters.Add(GetNewParameter("filename", EbDbTypes.String, filename));
                        cmd.Parameters.Add(GetNewParameter("bytea", EbDbTypes.Bytea, bytea));
                        cmd.Parameters.Add(GetNewParameter("cat", EbDbTypes.Int32, (int)cat));
                        rtn = cmd.ExecuteScalar().ToString();
                    }

                    con.Close();
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception :  " + e.Message);
            }
            Console.WriteLine("After MSSQLServer Upload File , fileStore id: " + rtn.ToString());
            return rtn.ToString();
        }
    }
}
