

using ExpressBase.Common.Connections;
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

        private MySQLEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, MySqlDbType.Text,"text"));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, MySqlDbType.Binary,"Binary"));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, MySqlDbType.Byte, "Byte"));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, MySqlDbType.Date,"Date"));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, MySqlDbType.Timestamp,"Timestamp"));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, MySqlDbType.Decimal,"Decimal"));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, MySqlDbType.Double,"Double"));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, MySqlDbType.Int16,"Int16"));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, MySqlDbType.Int32,"Int32"));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, MySqlDbType.Int64,"Int64"));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, MySqlDbType.JSON,"Json"));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, MySqlDbType.Text,"Text"));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, MySqlDbType.Time,"Time"));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, MySqlDbType.LongText,"LongText"));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, MySqlDbType.JSON,"Json"));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, MySqlDbType.VarChar,"Varchar"));
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


        public DatabaseVendors Vendor
        {
            get
            {
                return DatabaseVendors.MYSQL;
            }
        }

        public IVendorDbTypes VendorDbTypes
        {
            get
            {
                return MySQLEbDbTypes.Instance;
            }
        }



        //private const string CONNECTION_STRING_BARE = "Host={0}; Port={1}; Database={2}; Username={3}; Password={4}; SSL Mode=Require; Use SSL Stream=true; Trust Server Certificate=true; Pooling=true; CommandTimeout={5};";
        //private const string CONNECTION_STRING_BARE = "Server={0}; Port={1}; Database={2}; Uid={3}; pwd={4}; ";
        private const string CONNECTION_STRING_BARE = "Server=35.200.156.92; Port=3306; Database=northwind; Uid=jith; pwd=MyNewPass123#; ";
        private string _cstr;
        private EbBaseDbConnection EbBaseDbConnection { get; set; }
        public string DBName { get; }

        public MySqlDB()
        {

        }

        public MySqlDB(EbBaseDbConnection dbconf)
        {
            this.EbBaseDbConnection = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port, this.EbBaseDbConnection.DatabaseName, this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password);
        }

        public DbConnection GetNewConnection(string dbName)
        {
            return new MySqlConnection(string.Format(CONNECTION_STRING_BARE, this.EbBaseDbConnection.Server, this.EbBaseDbConnection.Port, dbName, this.EbBaseDbConnection.UserName, this.EbBaseDbConnection.Password));
        }

        public DbConnection GetNewConnection()
        {
            return new MySqlConnection(_cstr);
        }

        public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new MySqlCommand(sql, (MySqlConnection)con);
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type, object value)
        {
            return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = value };
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
        }

        public System.Data.Common.DbParameter GetNewOutParameter(string parametername, EbDbTypes type)
        {
            return new MySqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Output };
        }

        public T DoQuery<T>(string query, params DbParameter[] parameters)
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

                    throw myexce;
                }
                catch (SocketException scket) { }
            }

            return obj;
        }

        public EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();

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
                            //Type[] typeArray = this.AddColumns(dt, reader.GetColumnSchema());

                            DataTable schema = reader.GetSchemaTable();
                            this.AddColumns(dt, schema);
                            PrepareDataTable(reader, dt);

                            //PrepareDataTable(reader, dt, typeArray);
                        }

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

            return dt;
        }

        public DbDataReader DoQueriesBasic(string query, params DbParameter[] parameters)
        {
            var con = GetNewConnection() as MySqlConnection;
            try
            {
                con.Open();
                using (MySqlCommand cmd = new MySqlCommand(query, con))
                {
                    if (parameters != null && parameters.Length > 0)
                        cmd.Parameters.AddRange(parameters);

                    return cmd.ExecuteReader(CommandBehavior.CloseConnection);
                }
            }
            catch (MySqlException myexce)
            {

                throw myexce;
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
                            //Type[] typeArray = this.AddColumns(dt, (reader as MySqlDataReader).GetColumnSchema());
                            //PrepareDataTable((reader as MySqlDataReader), dt, typeArray);
                            //ds.Tables.Add(dt);

                            DataTable schema = reader.GetSchemaTable();
                            this.AddColumns(dt, schema);
                            PrepareDataTable(reader as MySqlDataReader, dt);
                        }
                        catch (Exception ee)
                        {
                            throw ee;
                        }
                    }
                    while (reader.NextResult());
                }
            }
            catch (MySqlException myexce)
            {

                throw myexce;
            }
            catch (SocketException scket) { }

            var dtEnd = DateTime.Now;
            var ts = (dtEnd - dtStart).TotalMilliseconds;
            Console.WriteLine(string.Format("-------------------------------------> {0}", ts));
            return ds;
        }

        public int DoNonQuery(string query, params DbParameter[] parameters)
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

        public EbDbTypes ConvertToDbType(Type _typ)
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


        public bool IsTableExists(string query, params DbParameter[] parameters)
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
                catch (SocketException scket) { }
            }

            return false;
        }

        public int CreateTable(string query)
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
                catch (SocketException scket) { }
            }
            return xx;
        }

        public int InsertTable(string query, params DbParameter[] parameters)
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

        public int UpdateTable(string query, params DbParameter[] parameters)
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

        public int AlterTable(string query, params DbParameter[] parameters)
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
                                cols.Add(column);

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

        public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        public string EB_AUTHENTICATEUSER_SOCIAL { get; set; }
        public string EB_AUTHENTICATEUSER_SSO { get; set; }
        public string EB_AUTHENTICATE_ANONYMOUS { get; set; }
        public string EB_SIDEBARUSER_REQUEST { get; set; }
        public string EB_SIDEBARDEV_REQUEST { get; set; }
        public string EB_SIDEBARCHECK { get; set; }
        public string EB_GETROLESRESPONSE_QUERY { get; set; }
        public string EB_GETMANAGEROLESRESPONSE_QUERY { get; set; }
        public string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get; set; }
        public string EB_SAVEROLES_QUERY { get; set; }
        public string EB_SAVEUSER_QUERY { get; set; }
        public string EB_SAVEUSERGROUP_QUERY { get; set; }
        public string EB_USER_ROLE_PRIVS { get; set; }
        public string EB_INITROLE2USER { get; set; }
        public string EB_MANAGEUSER_FIRST_QUERY { get; set; }

        public string EB_FETCH_ALL_VERSIONS_OF_AN_OBJ { get; set; }
        public string EB_PARTICULAR_VERSION_OF_AN_OBJ { get; set; }
        public string EB_LATEST_COMMITTED_VERSION_OF_AN_OBJ { get; set; }
        public string EB_ALL_LATEST_COMMITTED_VERSION_OF_AN_OBJ { get; set; }
        public string EB_GET_LIVE_OBJ_RELATIONS { get; set; }
        public string EB_GET_TAGGED_OBJECTS { get; set; }
        public string EB_GET_ALL_COMMITTED_VERSION_LIST { get; set; }
        public string EB_GET_OBJ_LIST_FROM_EBOBJECTS { get; set; }
        public string EB_GET_OBJ_STATUS_HISTORY { get; set; }
        public string EB_LIVE_VERSION_OF_OBJS { get; set; }
        public string EB_GET_ALL_TAGS { get; set; }


        public string EB_GET_BOT_FORM { get; set; }
        public string IS_TABLE_EXIST { get; set; }

        public string EB_CREATE_NEW_OBJECT { get; set; }
        public string EB_SAVE_OBJECT { get; set; }
        public string EB_COMMIT_OBJECT { get; set; }
        public string EB_EXPLORE_OBJECT { get; set; }
        public string EB_MAJOR_VERSION_OF_OBJECT { get; set; }
        public string EB_MINOR_VERSION_OF_OBJECT { get; set; }
        public string EB_CHANGE_STATUS_OBJECT { get; set; }
        public string EB_PATCH_VERSION_OF_OBJECT { get; set; }
        public string EB_UPDATE_DASHBOARD { get; set; }
        public string EB_LOCATION_CONFIGURATION { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }
        //public string EB_AUTHETICATE_USER_NORMAL { get; set; }

    }
}