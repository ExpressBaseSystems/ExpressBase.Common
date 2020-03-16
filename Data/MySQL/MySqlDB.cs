using ExpressBase.Common.Connections;
using ExpressBase.Common.Data;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Structures;
using MySql.Data.MySqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Net.Sockets;

namespace ExpressBase.Common
{
    public class MySQLEbDbTypes : IVendorDbTypes
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
        VendorDbType IVendorDbTypes.Int32 { get { return InnerDictionary[EbDbTypes.Decimal]; } }
        VendorDbType IVendorDbTypes.Int64 { get { return InnerDictionary[EbDbTypes.Int64]; } }
        VendorDbType IVendorDbTypes.Object { get { return InnerDictionary[EbDbTypes.Object]; } }
        VendorDbType IVendorDbTypes.String { get { return InnerDictionary[EbDbTypes.String]; } }
        VendorDbType IVendorDbTypes.Time { get { return InnerDictionary[EbDbTypes.Time]; } }
        VendorDbType IVendorDbTypes.VarNumeric { get { return InnerDictionary[EbDbTypes.VarNumeric]; } }
        VendorDbType IVendorDbTypes.Json { get { return InnerDictionary[EbDbTypes.Json]; } }
        VendorDbType IVendorDbTypes.Bytea { get { return InnerDictionary[EbDbTypes.Bytea]; } }
        //VendorDbType IVendorDbTypes.Boolean { get { return InnerDictionary[EbDbTypes.Boolean]; } } changed bcoz of issue in webform services in tbl crreation
        VendorDbType IVendorDbTypes.Boolean { get { return InnerDictionary[EbDbTypes.Boolean]; } }
        VendorDbType IVendorDbTypes.BooleanOriginal { get { return InnerDictionary[EbDbTypes.BooleanOriginal]; } }

        private MySQLEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, MySqlDbType.Text, "text"));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, MySqlDbType.Binary, "binary"));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, MySqlDbType.VarChar + "(1)", "varchar(1)"));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, MySqlDbType.Datetime, "datetime"));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, MySqlDbType.Timestamp, "timestamp"));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, MySqlDbType.Decimal, "decimal"));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, MySqlDbType.Double, "double"));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, MySqlDbType.Int16, "int16"));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, MySqlDbType.Decimal, "int32"));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, MySqlDbType.Int64, "int64"));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, MySqlDbType.JSON, "json"));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, MySqlDbType.Text, "text"));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, MySqlDbType.Time, "time"));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, MySqlDbType.Decimal, "decimal"));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, MySqlDbType.JSON, "json"));
            this.InnerDictionary.Add(EbDbTypes.Bytea, new VendorDbType(EbDbTypes.Bytea, MySqlDbType.Blob, "blob"));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, MySqlDbType.VarChar + "(1)", "varchar(1)"));
        }

        public static IVendorDbTypes Instance => new MySQLEbDbTypes();

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

    public class MySqlDB : IDatabase
    {
        public override DatabaseVendors Vendor
        {
            get
            {
                return DatabaseVendors.MYSQL;
            }
        }

        public override IVendorDbTypes VendorDbTypes
        {
            get
            {
                return MySQLEbDbTypes.Instance;
            }
        }

        private const string CONNECTION_STRING_BARE = "Server={0}; Port={1}; Database={2}; Uid={3}; Pwd={4}; SslMode=None; Allow User Variables=True;";

        private string _cstr;
        private EbDbConfig DbConfig { get; set; }
        public override string DBName { get; }

        public MySqlDB()
        {

        }

        public MySqlDB(EbDbConfig dbconf)
        {
            this.DbConfig = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, this.DbConfig.Port, this.DbConfig.DatabaseName, this.DbConfig.UserName, this.DbConfig.Password);
            DBName = DbConfig.DatabaseName;
        }

        public override DbConnection GetNewConnection(string dbName)
        {
            return new MySqlConnection(string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, this.DbConfig.Port, dbName, this.DbConfig.UserName, this.DbConfig.Password));
        }

        public override DbConnection GetNewConnection()
        {
            return new MySqlConnection(_cstr);
        }

        public override System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new MySqlCommand(sql, (MySqlConnection)con);
        }

        public override System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type, object value)
        {

            if (type == EbDbTypes.Boolean)
                value = Convert.ToBoolean(value) ? 'T' : 'F';
            return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = value, Direction = ParameterDirection.Input };
        }

        public override System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
            //return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Input };
        }

        public override System.Data.Common.DbParameter GetNewOutParameter(string parametername, EbDbTypes type)
        {
            return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Output };
        }

        public override EbDataTable DoQuery(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            if (query.Contains(":"))
            {
                query = query.Replace(":", "@");
            }
            EbDataTable dt = new EbDataTable();
            try
            {
                MySqlConnection con = dbConnection as MySqlConnection;

                using (MySqlCommand cmd = new MySqlCommand(query, con))
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

            catch (MySqlException myexce)
            {
                Console.WriteLine("MySQL Exception : " + myexce.Message);
                throw myexce;
            }
            catch (SocketException scket)
            {
            }

            return dt;
        }

        public override EbDataSet DoQueries(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            if (query.Contains(":"))
            {
                query = query.Replace(":", "@");
            }
            EbDataSet ds = new EbDataSet();
            if (query == "")
            {
                return ds;
            }
            var dtStart = DateTime.Now;
            Console.WriteLine(string.Format("DoQueries Start Time : {0}", dtStart));

            query = query.Trim();
            string[] qry_ary = query.Split(";");

            MySqlConnection con = dbConnection as MySqlConnection;

            var dtExeTime = DateTime.Now;
            Console.WriteLine(string.Format("DoQueries Execution Time : {0}", dtExeTime));

            ds.RowNumbers = "";
            try
            {
                for (int i = 0; i < qry_ary.Length && qry_ary[i] != string.Empty && qry_ary[i] != " "; i++)
                {
                    using (MySqlCommand cmd = new MySqlCommand(qry_ary[i], con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);
                        using (var reader = cmd.ExecuteReader())
                        {
                            EbDataTable dt = new EbDataTable();
                            DataTable schema = reader.GetSchemaTable();
                            if (schema != null)
                            {
                                this.AddColumns(dt, schema);
                                PrepareDataTable(reader, dt);
                            }
                            ds.Tables.Add(dt);
                            ds.RowNumbers += dt.Rows.Count.ToString() + ",";
                        }
                        cmd.Parameters.Clear();
                    }
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
            ds.RowNumbers = ds.RowNumbers.Substring(0, ds.RowNumbers.Length - 1);/*(ds.RowNumbers.Length>3)?ds.RowNumbers.Substring(0, ds.RowNumbers.Length - 3): ds.RowNumbers*/
            ds.StartTime = dtStart;
            ds.EndTime = dtEnd;

            return ds;
        }

        public override EbDataTable DoProcedure(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            EbDataTable tbl = new EbDataTable();
            int index = query.IndexOf("(");
            string procedure_name = query.Substring(0, index);
            try
            {
                MySqlConnection con = dbConnection as MySqlConnection;

                using (MySqlCommand cmd = new MySqlCommand())
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
                Console.WriteLine("MySQL Exception : " + e.Message);
                throw e;
            }

            return null;
        }

        protected override DbDataReader DoQueriesBasic(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            if (query.Contains(":"))
            {
                query = query.Replace(":", "@");
            }
            MySqlConnection con = dbConnection as MySqlConnection;

            try
            {
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
                    if (parameters != null && parameters.Length > 0)
                        cmd.Parameters.AddRange(parameters);
                    cmd.Prepare();
                    var reader = cmd.ExecuteReader();
                    return reader;
                }
            }
            catch (MySqlException myexce)
            {
                throw myexce;
            }
            catch (SocketException scket) { }

            return null;
        }

        public override int DoNonQuery(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {

            MySqlConnection con = dbConnection as MySqlConnection;
            try
            {
                if (query.Contains(":"))
                {
                    query = query.Replace(":", "@");
                }
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
                    if (parameters != null && parameters.Length > 0)
                        cmd.Parameters.AddRange(parameters);

                    return cmd.ExecuteNonQuery();
                }
            }
            catch (MySqlException myexce)
            {
                throw myexce;
            }
            catch (SocketException scket)
            {
            }

            return 0;
        }

        public override T DoQuery<T>(string query, params DbParameter[] parameters)
        {
            T obj = default(T);

            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
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
                catch (MySqlException myexce)
                {
                    if (con.State != ConnectionState.Closed)
                        con.Close();
                    Console.WriteLine("MySQL Exception : " + myexce.Message);
                    throw myexce;
                }
                catch (SocketException scket)
                {
                }
            }

            return obj;
        }

        public override EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();
            MySqlConnection con = GetNewConnection() as MySqlConnection;
            try
            {
                
                con.Open();
                dt = DoQuery(con, query, parameters);
                con.Close();
            }
            catch (MySqlException myexec)
            {
                if (con.State != ConnectionState.Closed)
                    con.Close();

                throw myexec;
            }
            return dt;
        }

        public override EbDataTable DoProcedure(string query, params DbParameter[] parameters)
        {
            EbDataTable tbl = new EbDataTable();
            MySqlConnection con = GetNewConnection() as MySqlConnection;
            try
            {                
                con.Open();
                tbl = DoProcedure(con, query, parameters);
                con.Close();
            }
            catch (MySqlException myexec)
            {
                if (con.State != ConnectionState.Closed)
                    con.Close();
                throw myexec;
            }
            return tbl;
        }

        public override EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();
            if (query == "")
            {
                return ds;
            }
            MySqlConnection con = GetNewConnection() as MySqlConnection;
            try
            {                
                con.Open();
                ds = DoQueries(con, query, parameters);
                con.Close();
            }
            catch (MySqlException myexec)
            {
                if (con.State != ConnectionState.Closed)
                    con.Close();
                throw myexec;
            }
            return ds;
        }

        public override int DoNonQuery(string query, params DbParameter[] parameters)
        {
            int val = 0;
            MySqlConnection con = GetNewConnection() as MySqlConnection;
            try
            {                
                con.Open();
                val = DoNonQuery(con, query, parameters);
                con.Close();
            }
            catch (MySqlException myexec)
            {
                if (con.State != ConnectionState.Closed)
                    con.Close();
                throw myexec;
            }
            return val;
        }

        public override Dictionary<int, string> GetDictionary(string query, string dm, string vm)
        {
            Dictionary<int, string> _dic = new Dictionary<int, string>();
            string sql = $"SELECT {vm},{dm} FROM ({query.Replace(";", string.Empty)}) as __table;";

            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(sql, con))
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
                catch (MySqlException myexce)
                {
                    Console.WriteLine("MySQL Exception: " + myexce.Message);
                    throw myexce;
                }
                catch (SocketException scket)
                {
                }
            }

            return _dic;
        }

        public override List<int> GetAutoResolveValues(string query, string vm, string cond)
        {
            List<int> _list = new List<int>();
            string sql = $"SELECT {vm} FROM ({query.Replace(";", string.Empty)}) as __table WHERE {cond};";

            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(sql, con))
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
                catch (MySqlException myexce)
                {
                    Console.WriteLine("MySQL Exception: " + myexce.Message);
                    throw myexce;
                }
                catch (SocketException scket)
                {
                }
            }

            return _list;
        }

        public override void BeginTransaction()
        {
            // This is a place where you will use _mySQLDriver to begin transaction
        }

        public override void RollbackTransaction()
        {
            // This is a place where you will use _mySQLDriver to rollback transaction
        }

        public override void CommitTransaction()
        {
            // This is a place where you will use _mySQLDriver to commit transaction
        }

        public override bool IsInTransaction()
        {
            // This is a place where you will use _mySQLDriver to check, whether you are in a transaction
            return false;
        }

        //private Type[] AddColumns(EbDataTable dt, ReadOnlyCollection<NpgsqlDbColumn> schema)
        //{
        //    int pos = 0;
        //    Type[] typeArray = new Type[schema.Count];
        //    foreach (Mys drow in schema)
        //    {
        //        string columnName = System.Convert.ToString(drow["ColumnName"]);
        //        typeArray[pos] = (Type)(drow["DataType"]);
        //        EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType(typeArray[pos]));
        //        column.ColumnIndex = pos++;
        //        dt.Columns.Add(column);
        //    }

        //    return typeArray;
        //}

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

        public override EbDbTypes ConvertToDbType(Type _typ)
        {
            if (_typ == typeof(DateTime))
                return EbDbTypes.Date;
            else if (_typ == typeof(string))
                return EbDbTypes.String;
            else if (_typ == typeof(bool))
                return EbDbTypes.Boolean;
            else if (_typ == typeof(decimal) || _typ == typeof(Double))
                return EbDbTypes.Decimal;
            else if (_typ == typeof(int) || _typ == typeof(Int32) || _typ == typeof(Int16) || _typ == typeof(Single))
                return EbDbTypes.Int32;
            else if (_typ == typeof(Int16))
                return EbDbTypes.Int16;
            else if (_typ == typeof(Int64))
                return EbDbTypes.Int64;
            else if (_typ == typeof(Single))
                return EbDbTypes.Int32;
            else if (_typ == typeof(TimeSpan))
                return EbDbTypes.Time;

            return EbDbTypes.String;
        }

        //private void PrepareDataTable(MySqlDataReader reader, EbDataTable dt, Type[] typeArray)
        //{
        //    int _fieldCount = reader.FieldCount;

        //    while (reader.Read())
        //    {
        //        EbDataRow dr = dt.NewDataRow();
        //        object[] oArray = new object[_fieldCount];
        //        reader.GetValues(oArray);
        //        dr.AddRange(oArray);
        //        dt.Rows.Add(dr);
        //    }

        //    typeArray = null;
        //}

        private void PrepareDataTable(MySqlDataReader reader, EbDataTable dt)
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

        public override bool IsTableExists(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return Convert.ToBoolean(cmd.ExecuteScalar());
                    }
                }
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket)
                {
                }
            }

            return false;
        }

        public override int CreateTable(string query)
        {
            int xx = 0;
            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        xx = cmd.ExecuteNonQuery();
                    }
                }
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket)
                {
                }
            }

            return xx;
        }

        public override int InsertTable(string query, params DbParameter[] parameters)
        {
            if (query.Contains(":"))
            {
                query = query.Replace(":", "@");
            }

            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket) { }
            }

            return 0;
        }

        public override int UpdateTable(string query, params DbParameter[] parameters)
        {
            if (query.Contains(":"))
            {
                query = query.Replace(":", "@");
            }
            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket) { }
            }

            return 0;
        }

        public override int AlterTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket) { }
            }

            return 0;
        }

        public override int DeleteTable(string query, params DbParameter[] parameters)
        {
            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        if (parameters != null && parameters.Length > 0)
                            cmd.Parameters.AddRange(parameters);

                        return cmd.ExecuteNonQuery();
                    }
                }
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket) { }
            }

            return 0;
        }

        public override ColumnColletion GetColumnSchema(string table)
        {
            ColumnColletion cols = new ColumnColletion();
            var query = "SELECT * FROM @tbl LIMIT 0".Replace("@tbl", table);
            using (var con = GetNewConnection() as MySqlConnection)
            {
                try
                {
                    con.Open();
                    using (MySqlCommand cmd = new MySqlCommand(query, con))
                    {
                        using (var reader = cmd.ExecuteReader())
                        {
                            int pos = 0;
                            //foreach (NpgsqlDbColumn drow in reader.GetColumnSchema())
                            //{
                            //    string columnName = System.Convert.ToString(drow["ColumnName"]);
                            //    var type = (Type)(drow["DataType"]);//for date and timstamp wihout tz return system.Datetime
                            //    EbDataColumn column = new EbDataColumn(columnName, ConvertToDbType(type));
                            //    column.ColumnIndex = pos++;
                            //    cols.Add(column);
                            //}
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
                catch (MySqlException myexce)
                {
                    throw myexce;
                }
                catch (SocketException scket) { }
            }
            return cols;
        }


        public override string EB_AUTHETICATE_USER_NORMAL
        {
            get
            {
                return @"eb_authenticate_unified(@uname, @pwd, @social, @wc, @ipaddress, @deviceinfo, @tmp_userid, @tmp_status_id, @tmp_email, @tmp_fullname, @tmp_roles_a, 
                            @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraints_a, @tmp_signin_id, @tmp_usergroup_a, @tmp_public_ids, @tmp_user_type);";
            }
        }

        public override string EB_AUTHENTICATEUSER_SOCIAL
        {
            get
            {
                return @"eb_authenticate_unified(@uname, @pwd, @social, @wc, @ipaddress, @deviceinfo, @tmp_userid, @tmp_status_id, @tmp_email, @tmp_fullname, @tmp_roles_a, 
                            @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraints_a, @tmp_signin_id, @tmp_usergroup_a, @tmp_public_ids, @tmp_user_type);";
            }
        }

        public override string EB_AUTHENTICATEUSER_SSO
        {
            get
            {
                return @"eb_authenticate_unified(@uname, @pwd, @social, @wc, @ipaddress, @deviceinfo, @tmp_userid, @tmp_status_id, @tmp_email, @tmp_fullname, @tmp_roles_a, 
                            @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraints_a, @tmp_signin_id, @tmp_usergroup_a, @tmp_public_ids, @tmp_user_type);";
            }
        }

        public override string EB_AUTHENTICATE_ANONYMOUS
        {
            get
            {
                return @"eb_authenticate_anonymous(@in_socialid, @in_fullname, @in_emailid, @in_phone, @in_user_ip, @in_user_browser,@in_city, @in_region, @in_country, 
                            @in_latitude, @in_longitude, @in_timezone, @in_iplocationjson, @in_appid, @in_wc, @out_userid, @out_status_id, @out_email, @out_fullname, @out_roles_a, 
                            @out_rolename_a, @out_permissions, @out_preferencesjson, @out_constraints_a, @out_signin_id, @out_usergroup_a, @out_public_ids, @out_user_type); ";
            }
        }

        public override string EB_SIDEBARUSER_REQUEST
        {
            get
            {
                return @"SELECT 
                    id, applicationname,app_icon
                FROM 
                    eb_applications
                WHERE 
                    COALESCE(eb_del, 'F') = 'F' 
                ORDER BY 
                    applicationname;
                SELECT
                    EO.id, EO.obj_type, EO.obj_name,
                    EOV.version_num, EOV.refid, EO2A.app_id, EO.obj_desc, EOS.status, EOS.id, display_name
                FROM
                    eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A
                WHERE
                    EOV.eb_objects_id = EO.id
                    AND EO.id IN (:Ids)                  
                    AND EOS.eb_obj_ver_id = EOV.id
                    AND EO2A.obj_id = EO.id
                    AND EO2A.eb_del = 'F'
                    AND EOS.status = 3
                    AND COALESCE( EO.eb_del, 'F') = 'F'
                    AND EOS.id = ANY( SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id );
                SELECT 
                    object_id 
                FROM 
                    eb_objects_favourites 
                WHERE 
                    userid = @user_id AND eb_del='F';";
            }
        }

        // only for mysql
        public string EB_SIDEBARUSER_REQUEST_SOL_OWNER
        {
            get
            {
                return @"SELECT id, applicationname,app_icon
                            FROM eb_applications WHERE COALESCE(eb_del, 'F') = 'F' ORDER BY applicationname;
                        SELECT
                            EO.id, EO.obj_type, EO.obj_name, EOV.version_num, EOV.refid, EO2A.app_id, EO.obj_desc, EOS.status, EOS.id, display_name
                        FROM
                            eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A
                        WHERE
                            EOV.eb_objects_id = EO.id                                      
                            AND EOS.eb_obj_ver_id = EOV.id
                            AND EO2A.obj_id = EO.id
                            AND EO2A.eb_del = 'F'
                            AND EOS.status = 3
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                            AND EOS.id = ANY( SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id );
                        SELECT object_id FROM eb_objects_favourites WHERE userid=@user_id AND eb_del='F';";
            }
        }

        public override string EB_SIDEBARCHECK { get { return "AND EO.id = any (SELECT '@Ids')"; } }

        public override string EB_GETROLESRESPONSE_QUERY
        {
            get
            {
                return @"SELECT R.id, R.role_name, R.description, A.applicationname,
                            (SELECT COUNT(role1_id) FROM eb_role2role WHERE role1_id=R.id AND eb_del = 'F') AS subrole_count,
                            (SELECT COUNT(user_id) FROM eb_role2user WHERE role_id=R.id AND eb_del = 'F') AS user_count,
                            (SELECT COUNT(distinct permissionname) FROM eb_role2permission RP, eb_objects2application OA 
                                    WHERE role_id = R.id AND app_id = A.id AND RP.obj_id = OA.obj_id AND RP.eb_del = 'F' AND OA.eb_del = 'F') AS permission_count
                            FROM eb_roles R, eb_applications A
                            WHERE R.applicationid = A.id AND A.eb_del = 'F' AND R.role_name LIKE CONCAT('%',@searchtext,'%');";
            }
        }

        // Only for Mysql
        public string EB_GETROLESRESPONSE_QUERY_WITHOUT_SEARCHTEXT
        {
            get
            {
                return @"SELECT R.id, R.role_name, R.description, A.applicationname,
                        (SELECT COUNT(role1_id) FROM eb_role2role WHERE role1_id = R.id AND eb_del = 'F') AS subrole_count,
                        (SELECT COUNT(user_id) FROM eb_role2user WHERE role_id = R.id AND eb_del = 'F') AS user_count,
                        (SELECT COUNT(DISTINCT permissionname) FROM eb_role2permission RP, eb_objects2application OA WHERE role_id = R.id 
                            AND app_id = A.id AND RP.obj_id = OA.obj_id AND RP.eb_del = 'F' AND OA.eb_del = 'F') AS permission_count
                        FROM eb_roles R, eb_applications A
                        WHERE R.applicationid = A.id AND A.eb_del = 'F';";
            }
        }

        public override string EB_SAVEROLES_QUERY
        {
            get
            {
                return @"eb_create_or_update_rbac_roles(@role_id, @applicationid, @createdby, @role_name, @description, @is_anonym, @users, @dependants, @permission, 
                            @locations, @out_r);";
            }
        }

        public override string EB_SAVEUSER_QUERY
        {
            get
            {
                return @"eb_security_user(@_userid, @_id, @_fullname, @_nickname, @_email, @_pwd, @_dob, @_sex, @_alternateemail, @_phprimary, @_phsecondary, @_phlandphone, 
                            @_extension, @_fbid, @_fbname, @_roles, @_groups, @_statusid, @_hide ,@_anonymoususerid, @_preferences, @_usertype, @_consadd, @_consdel, @out_uid);";
            }
        }

        public override string EB_SAVEUSERGROUP_QUERY
        {
            get
            {
                return @"eb_security_usergroup(@userid, @id, @name, @description, @users, @constraints_add, @constraints_del, @out_gid);";
            }
        }

        public override string EB_USER_ROLE_PRIVS
        {
            get
            {
                return "SELECT DISTINCT privilege_type FROM information_schema.USER_PRIVILEGES WHERE grantee = \"'@uname'@'%'\"";
            }
        }

        public string EB_GETUSERGROUP_QUERY_WITHOUT_SEARCHTEXT
        {
            get
            {
                return @"SELECT id,name,description FROM eb_usergroup WHERE eb_del = 'F';";
            }
        }

        public override string EB_GETUSERDETAILS
        {
            get
            {
                return @"SELECT id, fullname, email FROM eb_users WHERE LOWER(fullname) LIKE LOWER(CONCAT('%', @searchtext, '%')) AND eb_del = 'F' ORDER BY fullname ASC;";
            }
        }

        public override string EB_GET_MYPROFILE_OBJID
        {
            get
            {
                return @" AND FIND_IN_SET(eov.eb_objects_id, @ids)";
            }
        }

        public override string EB_CREATEAPPLICATION_DEV
        {
            get
            {
                return @"INSERT INTO eb_applications (applicationname, application_type, description, app_icon) VALUES (@applicationname, @apptype, @description, @appicon); 
                        SELECT LAST_INSERT_ID();";
            }
        }
        
        public override string EB_GETTABLESCHEMA
        {
            get
            {
                return @"SELECT 
                            ACols.*, BCols.foreign_table_name, BCols.foreign_column_name 
                         FROM
                            (SELECT 
                                    TCols.*, CCols.constraint_type FROM
                                (SELECT
                                        T.table_name, C.column_name, C.data_type
                                FROM 
                                        information_schema.tables T,
                                        information_schema.columns C
                                WHERE
                                        T.table_name = C.table_name 
                                ) TCols
                           LEFT JOIN
                                (SELECT 
                                    TC.table_name,TC.constraint_type,KCU.column_name 
                                FROM
                                    information_schema.table_constraints TC,
                                    information_schema.key_column_usage KCU
                                WHERE
                                    TC.constraint_name = KCU.constraint_name AND
                                    (TC.constraint_type = 'PRIMARY KEY' OR TC.constraint_type = 'FOREIGN KEY') 
                                ) CCols
                             ON 
                                CCols.table_name = TCols.table_name AND
                                CCols.column_name = TCols.column_name) ACols
                    LEFT JOIN
                            (SELECT
                                TC.constraint_name, TC.table_name, KCU.column_name, 
                                KCU.REFERENCED_TABLE_NAME AS foreign_table_name,
                                KCU.REFERENCED_COLUMN_NAME AS foreign_column_name 
                            FROM 
                                information_schema.table_constraints AS TC 
                            JOIN 
                                information_schema.key_column_usage AS KCU
                            ON 
                                TC.constraint_name = KCU.constraint_name
                            WHERE 
                                TC.constraint_type = 'FOREIGN KEY' ) BCols
                     ON
                            ACols.table_name=BCols.table_name AND  ACols.column_name=BCols.column_name
                    ORDER BY
                        table_name, column_name;";
            }
        }

        public override string EB_GET_CHART_2_DETAILS
        {
            get
            {
                return @"SELECT created_at FROM eb_executionlogs WHERE refid = @refid AND CAST(created_at AS date) = current_date;";
            }
        }

        public override string EB_GET_PROFILERS
        {
            get
            {
                return @"SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = @refid);
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid = @refid);
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = @refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date));
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid = @refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date));
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid= @refid and CONVERT(created_at, DATE) = current_date);
                        SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MIN(exec_time) FROM eb_executionlogs WHERE refid= @refid and CONVERT(created_at, DATE) = current_date);
                        SELECT COUNT(*) FROM eb_executionlogs WHERE refid = @refid;
                        SELECT COUNT(*) FROM eb_executionlogs WHERE CONVERT(created_at, date) = current_date AND refid = @refid;
                        SELECT COUNT(*) FROM eb_executionlogs WHERE EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date) and refid = @refid;";
            }
        }

        public override string EB_GETUSEREMAILS
        {
            get
            {
                return @"SELECT id, email FROM eb_users WHERE FIND_IN_SET(id, @userids);
                           SELECT distinct id, email FROM eb_users WHERE id = ANY(SELECT userid FROM eb_user2usergroup WHERE 
                                FIND_IN_SET(groupid, @groupids)) ;";
            }
        }

        public override string EB_GETPARTICULARSSURVEY
        {
            get
            {
                return @"SELECT name, startdate, enddate, status FROM eb_surveys WHERE id = @id;
                         SELECT questions AS q_id FROM eb_surveys WHERE id = @id into @qstns;
                         DROP TEMPORARY TABLE IF EXISTS temp_array_table;
                         CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
                         DROP TEMPORARY TABLE IF EXISTS temp_qstns_tbl;
                         CALL eb_str_to_tbl_util(@qstns);
                         CREATE TEMPORARY TABLE IF NOT EXISTS temp_qstns_tbl
                            SELECT `value` FROM temp_array_table;
                         SELECT * FROM (SELECT `value` AS q_id FROM temp_qstns_tbl) QUES_IDS, 
								        (SELECT Q.id, Q.query, Q.q_type FROM eb_survey_queries Q) QUES_ANS,
								        (SELECT C.choice,C.score,C.id, C.q_id FROM eb_query_choices C WHERE eb_del = 'F' ) QUES_QRY
								WHERE QUES_IDS.q_id = QUES_ANS.id
									AND QUES_QRY.q_id = QUES_ANS.id;";
            }
        }

        public override string EB_SURVEYMASTER
        {
            get
            {
                return @"INSERT INTO eb_survey_master(surveyid, userid, anonid, eb_createdate) VALUES(@sid, @uid, @anid, now());
                            SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_CURRENT_TIMESTAMP
        {
            get
            {
                return @"UTC_TIMESTAMP()";
            }
        }

        public override string EB_SAVESURVEY
        {
            get
            {
                return @"INSERT INTO eb_surveys(name, startdate, enddate, status, questions) VALUES (@name, @start, @end, @status, @questions);
                        SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_PROFILER_QUERY_COLUMN
        {
            get
            {
                return @"SELECT id, `rows`, exec_time, created_by, created_at FROM eb_executionlogs WHERE refid = @refid; ";
            }
        }

        public override string EB_PROFILER_QUERY_DATA
        {
            get
            {
                return @"SELECT COUNT(id) FROM eb_executionlogs WHERE refid = @refid; 
                            SELECT 
                                    EL.id, EL.`rows`, EL.exec_time, EU.fullname, EL.created_at 
                                FROM 
                                    eb_executionlogs EL, eb_users EU
                                WHERE 
                                    refid = @refid AND EL.created_by = EU.id
                                LIMIT @limit OFFSET @offset;";
            }
        }

        public override string EB_LOGIN_ACTIVITY_ALL_USERS
        {
            get
            {
                return @"SELECT 
	                            users.fullname, signin.device_info AS usertype, signin.ip_address, signin.signin_at, 
	                            cast(date_format(signin.signin_at,'%h:%i:%s') as char(10)) signin_time, signin.signout_at, 
                                cast(date_format(signin.signout_at,'%h:%i:%s') as char(10)) signout_time,
	                            cast(SEC_TO_TIME(TIMESTAMPDIFF(second,signin_at, signout_at)) as char(15)) AS duration
                            FROM
	                            eb_signin_log signin, eb_users users
                            WHERE 
	                            is_attempt_failed = @islg
	                            AND signin.user_id = users.id
                            ORDER BY 
	                            signin.signin_at DESC; ";
            }
        }

        public override string EB_LOGIN_ACTIVITY_USERS
        {
            get
            {
                return @"SELECT
	                            signin.ip_address, signin.signin_at, cast(date_format(signin.signin_at,'%h:%i:%s') as char(10)) signin_time,
	                            signin.signout_at, cast(date_format(signin.signout_at,'%h:%i:%s') as char(10)) signout_time,
	                            cast(SEC_TO_TIME(TIMESTAMPDIFF(second,signin_at, signout_at)) as char(15)) AS duration
                            FROM
	                            eb_signin_log signin, eb_users users
                            WHERE 
	                            is_attempt_failed = @islg
	                            AND signin.user_id = @usrid
	                            AND users.id = @usrid
                            ORDER BY 
	                            signin.signin_at DESC;";
            }
        }

        public override string EB_GET_CHART_DETAILS
        {
            get
            {
                return @"SELECT 
                                `rows`, exec_time 
                            FROM 
                                eb_executionlogs 
                            WHERE 
                                refid = @refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date);";
            }
        }

        public override string EB_INSERT_EXECUTION_LOGS
        {
            get
            {
                return @"INSERT INTO eb_executionlogs(`rows`, exec_time, created_by, created_at, params, refid) 
                                VALUES(@rows, @exec_time, @created_by, @created_at, @params, @refid);";
            }
        }

        public override string EB_GET_MOB_MENU_OBJ_IDS
        {
            get
            {
                return @"AND FIND_IN_SET(EOA.obj_id, @ids) ";
            }
        }

        public override string EB_GET_MOBILE_PAGES
        {
            get
            {
                return @"AND FIND_IN_SET(OD.id, @objids) ";
            }
        }

        public override string EB_GET_MOBILE_PAGES_OBJS
        {
            get
            {
                return @"SELECT obj_name,display_name,obj_type,version_num,obj_json,refid FROM (
				                                SELECT 
					                                EO.id,EO.obj_name,EO.display_name,EO.obj_type,EOV.version_num, EOV.obj_json,EOV.refid
				                                FROM
					                                eb_objects EO
				                                LEFT JOIN 
					                                eb_objects_ver EOV ON (EOV.eb_objects_id = EO.id)
				                                LEFT JOIN
					                                eb_objects_status EOS ON (EOS.eb_obj_ver_id = EOV.id)
				                                WHERE
					                                COALESCE(EO.eb_del, 'F') = 'F'
				                                AND
					                                EOS.status = 3
				                                AND 
					                                FIND_IN_SET(EO.obj_type, '13,3')
				                                AND 
					                                EOS.id = ANY( Select MAX(id) from eb_objects_status EOS Where EOS.eb_obj_ver_id = EOV.id)
				                                ) OD 
                                LEFT JOIN eb_objects2application EO2A ON (EO2A.obj_id = OD.id)
                                WHERE 
	                                EO2A.app_id = @appid 
                                {0}
                                AND 
	                                COALESCE(EO2A.eb_del, 'F') = 'F';
                                SELECT app_settings FROM eb_applications WHERE id = @appid;";
            }
        }

        public override string EB_GET_MYACTIONS
        {
            get
            {
                return @"SELECT * FROM eb_my_actions EACT 
	                        WHERE 
		                        COALESCE(EACT.is_completed, 'F') = 'F' 
		                        AND COALESCE(EACT.eb_del, 'F') = 'F' 
                                AND (FIND_IN_SET(@userid,EACT.user_ids)
			                        OR FIND_IN_SET(EACT.role_id, @roleids)
			                        OR FIND_IN_SET(EACT.usergroup_id, @usergroupids)
			                        ); ";
            }
        }

        public override string EB_GET_USER_DASHBOARD_OBJECTS
        {
            get
            {
                return @" AND FIND_IN_SET(eov.eb_objects_id, @ids) ";
            }
        }

        // DBClient

        public override string EB_GETDBCLIENTTTABLES
        {
            get
            {
                return @"
                 SELECT Q1.table_name, Q1.table_schema, i.index_name 
                 FROM 
                    (SELECT
                        table_name, table_schema,table_type
                    FROM
                        information_schema.tables 
                    WHERE
                        table_schema != 'sys' 
                        AND table_schema != 'information_schema'
                        AND table_schema != 'performance_schema'                   
                        AND table_schema != 'mysql'
                        AND table_type='BASE TABLE'
                        AND table_name NOT LIKE 'eb_%'
                    )Q1
                    LEFT JOIN
                        information_schema.statistics  i
                    ON
                        Q1.table_name = i.table_name ORDER BY table_name;
                    SELECT 
                        table_name, column_name, data_type
                    FROM
                        information_schema.columns
                    WHERE
                        table_schema != 'sys' AND
                        table_schema != 'information_schema'  
                        AND table_schema != 'performance_schema'                   
                        AND table_schema != 'mysql'
                        AND table_name NOT LIKE 'eb_%'
                    ORDER BY table_name;
                    SELECT
                        c.constraint_name AS constraint_name,
                        c.constraint_type AS constraint_type,
                        c.table_name AS tabless,
                        GROUP_CONCAT(col.column_name) AS columns                   
                    FROM 
                        information_schema.table_constraints c              
                    JOIN 
                        information_schema.columns col ON(col.table_schema = c.table_schema AND col.table_name = c.table_name)
                    WHERE
                        col.table_name NOT LIKE 'eb_%'
                    GROUP BY 
                        constraint_name, constraint_type, tabless-- , definition
                    ORDER BY 
                        tabless;";
            }
        }

        //.......OBJECTS QUERIES.....

        public override string EB_GET_TAGGED_OBJECTS
        {
            get
            {
                return @"eb_get_tagged_object(@tags);";
            }
        }     

        public override string EB_GET_ALL_TAGS
        {
            get
            {
                return @"SET @ab='';
                         SELECT GROUP_CONCAT(obj_tags SEPARATOR ',') FROM eb_objects WHERE COALESCE(eb_del, 'F') = 'F' INTO @ab;
                         DROP TEMPORARY TABLE IF EXISTS temp_array_table;
                         CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value text);
                         CALL eb_str_to_tbl_util(@ab,',');
                         DROP TEMPORARY TABLE IF EXISTS temp_tags_tbl;
                         CREATE TEMPORARY TABLE IF NOT EXISTS temp_tags_tbl
                            SELECT `value` FROM temp_array_table;                                        
                         SELECT DISTINCT `value` FROM temp_tags_tbl;";
            }
        }

        public override string EB_GET_MLSEARCHRESULT
        {
            get
            {
                return @"SELECT count(*) FROM (SELECT * FROM eb_keys WHERE LOWER(`key`) LIKE LOWER(@KEY)) AS Temp;
											SELECT A.id, A.`key`, B.id, B.language, C.id, C.value
											FROM (SELECT * FROM eb_keys WHERE LOWER(`key`) LIKE LOWER(@KEY) ORDER BY `key` ASC LIMIT @LIMIT OFFSET @OFFSET ) A,
													eb_languages B, eb_keyvalue C
											WHERE A.id=C.key_id AND B.id = C.lang_id  
											ORDER BY A.`key` ASC, B.language ASC;";
            }
        }

        public override string EB_MLADDKEY
        {
            get
            {
                return @"INSERT INTO eb_keys (`key`) VALUES(@KEY);
                          SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_GET_BOT_FORM
        {
            get
            {
                return @"SELECT DISTINCT
                                EOV.refid, EO.obj_name
                            FROM
                                eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EOTA
                            WHERE
                                EO.id = EOV.eb_objects_id  AND
                                EO.id = EOTA.obj_id  AND
                                EOS.eb_obj_ver_id = EOV.id AND
                                FIND_IN_SET(EO.id, @Ids) AND
                                EOS.status = 3 AND
                                (
                                EO.obj_type = 16 OR
                                EO.obj_type = 17
                                OR EO.obj_type = 18
                                )  AND
                                EOTA.app_id = @appid AND
                                EOTA.eb_del = 'F'
                                AND COALESCE( EO.eb_del, 'F') = 'F';";
            }
        }

        public override string IS_TABLE_EXIST
        {
            get
            {
                return @"SELECT EXISTS (SELECT 1 FROM information_schema.tables WHERE table_schema = DATABASE() AND table_name like @tbl);";
            }
        }

        public override string EB_ALLOBJNVER
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.display_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.refid,
                            EU.fullname
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid=EU.id
                        WHERE
                            FIND_IN_SET(EO.id, @ids) AND
                            EO.id = EOV.eb_objects_id AND COALESCE(EOV.working_mode, 'F') <> 'T'
                        ORDER BY
                            EO.obj_name;";
            }
        }

        public override string EB_CREATELOCATIONCONFIG1Q
        {
            get
            {
                return @"INSERT INTO eb_location_config (`keys`,isrequired,keytype,eb_del) VALUES(@keys,@isrequired,@type,'F');
                          SELECT LAST_INSERT_ID()";
            }
        }

        public override string EB_CREATELOCATIONCONFIG2Q
        {
            get
            {
                return @"UPDATE eb_location_config SET `keys` = @keys ,isrequired = @isrequired , keytype = @type WHERE id = @keyid;";
            }
        }

        //.....OBJECTS FUNCTION CALL......

        public override string EB_CREATE_NEW_OBJECT
        {
            get
            {
                return @"eb_objects_create_new_object(@obj_name, @obj_desc, @obj_type, @obj_cur_status, @obj_json, @commit_uid, @src_pid, @cur_pid, @relations, @issave, @tags, @app_id, @s_obj_id, @s_ver_id, @disp_name, @out_refid_of_commit_version)";
            }
        }

        public override string EB_SAVE_OBJECT
        {
            get
            {
                return @"eb_objects_save(@id, @obj_name, @obj_desc, @obj_type, @obj_json, @commit_uid, @relations, @tags, @app_id, @disp_name, @out_refidv);";
            }
        }

        public override string EB_COMMIT_OBJECT
        {
            get
            {
                return @"eb_objects_commit(@id, @obj_name, @obj_desc, @obj_type, @obj_json, @obj_changelog,  @commit_uid, @relations, @tags, @app_id, @disp_name, 
                            @out_committed_refidunique);";
            }
        }

        public override string EB_EXPLORE_OBJECT
        {
            get
            {
                return @"eb_objects_exploreobject(@id, @idval, @nameval, @typeval, @statusval, @descriptionval, @changelogval, @commitatval, @commitbyval,
                                @refidval, @ver_numval, @work_modeval, @workingcopiesval, @json_wcval, @json_lcval, @major_verval, @minor_verval, @patch_verval,
                                @tagsval, @app_idval, @lastversionrefidval, @lastversionnumberval, @lastversioncommit_tsval, @lastversion_statusval,
                                @lastversioncommit_byname, @lastversioncommit_byid, @liveversionrefidval, @liveversionnumberval, @liveversioncommit_tsval,
                                @liveversion_statusval, @liveversioncommit_byname, @liveversioncommit_byid, @owner_uidVal, @owner_tsVal, @wner_nameVal, @dispnameval,
                                @is_logv, @is_publicv);";
            }
        }

        public override string EB_MAJOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"eb_object_create_major_version(@id, @obj_type, @commit_uid, @src_pid, @cur_pid, @relations, @committed_refidunique)";
            }
        }
        public override string EB_MINOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"eb_object_create_minor_version(@id, @obj_type, @commit_uid, @src_pid, @cur_pid, @relations, @committed_refidunique)";
            }
        }

        public override string EB_CHANGE_STATUS_OBJECT
        {
            get
            {
                return @"SELECT eb_objects_change_status(@id, @status, @commit_uid, @obj_changelog)";
            }
        }

        public override string EB_PATCH_VERSION_OF_OBJECT
        {
            get
            {
                return "eb_object_create_patch_version(@id, @obj_type, @commit_uid, @src_pid, @cur_pid, @relations, @committed_refidunique)";
            }
        }

        public override string EB_UPDATE_DASHBOARD
        {
            get
            {
                return @"eb_objects_update_dashboard(@refid, @namev, @status, @ver_num, @work_mode, @workingcopies, @major_ver, @minor_ver, @patch_ver, @tags,
                        @app_id, @lastversionrefidval, @lastversionnumberval, @lastversioncommit_tsval, @lastversion_statusval, @lastversioncommit_byname, 
                        @lastversioncommit_byid, @liveversionrefidval, @liveversionnumberval, @liveversioncommit_tsval, @liveversion_statusval, 
                        @liveversioncommit_byname, @liveversioncommit_byid, @owner_uidval, @owner_tsval, @owner_nameval, @is_public)";
            }
        }               

        public override string EB_SAVELOCATION
        {
            get
            {
                return @"INSERT INTO eb_locations(longname,shortname,image,meta_json) VALUES(@lname, @sname, @img, @meta);
                        SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_CREATEBOT
        {
            get
            {
                return @"SELECT eb_createbot(@solid, @name, @fullname, @url, @welcome_msg, @uid, @botid)";
            }
        }

        //....Files query

        public override string EB_IMGREFUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id)
                         VALUES 
                            (@refid, @filestoreid, @length, @imagequality_id, @is_image, @imgmanpserid, @filedb_con_id);
                        SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_DPUPDATESQL
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id)
                            VALUES 
                                (@refid, @filestoreid, @length, @imagequality_id, @is_image, @imgmanpserid, @filedb_con_id);
                        SELECT LAST_INSERT_ID();
                        UPDATE eb_users SET dprefid = @refid WHERE id=@userid";
            }
        }

        //public override string EB_LOGOUPDATESQL
        //{
        //    get
        //    {
        //        return @"";
        //    }
        //}

        public override string EB_MQ_UPLOADFILE
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, is_image, filedb_con_id)
                         VALUES 
                            (@refid, @filestoresid, @length, @is_image, @filedb_con_id);
                        SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_GETFILEREFID
        {
            get
            {
                return @"INSERT INTO
                            eb_files_ref (userid, filename, filetype, tags, filecategory) 
                         VALUES 
                            (@userid, @filename, @filetype, @tags, @filecategory); 
                        SELECT LAST_INSERT_ID();";
            }
        }

        public override string EB_UPLOAD_IDFETCHQUERY
        {
            get
            {
                return @"INSERT INTO
                            eb_files_ref (userid, filename, filetype, tags, filecategory, uploadts,context) 
                        VALUES 
                            (@userid, @filename, @filetype, @tags, @filecategory, NOW(),@context); 
                        SELECT LAST_INSERT_ID()";
            }
        }                

        //public string EB_FILECATEGORYCHANGE
        //{
        //    get
        //    {
        //        return @"
        //                CALL string_to_rows(@ids);
        //                UPDATE 
        //                 eb_files_ref FR
        //                SET
        //                 tags = JSON_SET(CAST(tags AS JSON),
        //                      '$.Category',@categry
        //                      (SELECT CAST(CONCAT('[""',@categry,'""]')AS JSON)))
        //                WHERE
        //                    FR.id = (SELECT CAST(`value` AS UNSIGNED INT) FROM tmp_array_table);";
        //    }
        //}

        public override string EB_FILECATEGORYCHANGE
        {
            get
            {
                return @"SELECT id,tags FROM eb_files_ref WHERE FIND_IN_SET(id, @ids);";
            }
        }

        //....api query...
        public override string EB_API_SQL_FUNC_HEADER
        {
            get
            {
                return @"CREATE OR REPLACE FUNCTION {0}(insert_json json,update_json json)
                            RETURNS void
                            LANGUAGE {1} AS $BODY$";
            }
        }

    }

    public class MySQLFilesDB : MySqlDB, INoSQLDatabase
    {
        public MySQLFilesDB(EbDbConfig dbconf) : base(dbconf)
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
                using (MySqlConnection con = GetNewConnection() as MySqlConnection)
                {
                    con.Open();
                    string sql = "SELECT bytea FROM eb_files_bytea WHERE id = @filestore_id AND filecategory = @cat;";
                    MySqlCommand cmd = new MySqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter("filestore_id", EbDbTypes.Int32, ifileid));
                    cmd.Parameters.Add(GetNewParameter("cat", EbDbTypes.Int32, (int)cat));
                    filebyte = (byte[])cmd.ExecuteScalar();
                }
            }
            catch (MySqlException mexce)
            {
                Console.WriteLine("Exception :  " + mexce.Message);
            }
            return filebyte;
        }

        public byte[] DownloadFileByName(string filename, EbFileCategory cat)
        {
            byte[] filebyte = null;
            try
            {
                using (MySqlConnection con = GetNewConnection() as MySqlConnection)
                {
                    con.Open();
                    string sql = "SELECT bytea FROM eb_files_bytea WHERE filename = @filename AND filecategory = @cat;";
                    MySqlCommand cmd = new MySqlCommand(sql, con);
                    cmd.Parameters.Add(GetNewParameter("filename", EbDbTypes.String, filename));
                    cmd.Parameters.Add(GetNewParameter("cat", EbDbTypes.Int32, (int)cat));
                    filebyte = (byte[])cmd.ExecuteScalar();
                }
            }
            catch (MySqlException mexce)
            {
                Console.WriteLine("Exception :  " + mexce.Message);
            }
            return filebyte;
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory cat)
        {
            Console.WriteLine("Before Mysql Upload File");

            string rtn = null;
            try
            {
                using (MySqlConnection con = GetNewConnection() as MySqlConnection)
                {
                    con.Open();
                    string sql = @"INSERT INTO eb_files_bytea(filename, bytea, filecategory) VALUES(@filename, @bytea, @cat);SELECT last_insert_id();";

                    using (MySqlCommand cmd = new MySqlCommand(sql, con))
                    {
                        cmd.Parameters.Add(GetNewParameter("filename", EbDbTypes.String, filename));
                        cmd.Parameters.Add(GetNewParameter("bytea", EbDbTypes.Bytea, bytea));
                        cmd.Parameters.Add(GetNewParameter("cat", EbDbTypes.Int32, (int)cat));
                        rtn = cmd.ExecuteScalar().ToString();
                    }

                    con.Close();
                }
            }
            catch (MySqlException mexce)
            {
                Console.WriteLine("Exception :  " + mexce.Message);
            }
            Console.WriteLine("After Mysql Upload File , fileStore id: " + rtn.ToString());
            return rtn.ToString();
        }
    }
}