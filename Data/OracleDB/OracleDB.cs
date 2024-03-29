﻿using ExpressBase.Common.Connections;
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
        VendorDbType IVendorDbTypes.BooleanOriginal { get { return InnerDictionary[EbDbTypes.BooleanOriginal]; } }

        private OracleEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, OracleDbType.Clob, "to_clob({0})"));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, OracleDbType.Blob, "to_blob({0})"));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, OracleDbType.Byte, "to_single_byte({0})"));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, OracleDbType.Date, "to_date({0})"));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, OracleDbType.TimeStamp, "to_timestamp({0})"));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, OracleDbType.Decimal, "to_decimal({0})"));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, OracleDbType.Double, "to_binary_double({0})"));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, OracleDbType.Int16, "to_number({})"));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, OracleDbType.Int32, "to_number({})"));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, OracleDbType.Int64, "to_number({})"));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, OracleDbType.Clob, "to_clob({0})"));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, OracleDbType.Clob, "to_clob({0})"));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, OracleDbType.TimeStamp, "to_timestamp({0})"));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, OracleDbType.NVarchar2, "to_number({})"));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, OracleDbType.Clob, "to_clob({0})"));
            this.InnerDictionary.Add(EbDbTypes.Bytea, new VendorDbType(EbDbTypes.Bytea, OracleDbType.Blob, "to_blob({0})"));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, OracleDbType.Char, "to_char({0})"));
            this.InnerDictionary.Add(EbDbTypes.BooleanOriginal, new VendorDbType(EbDbTypes.BooleanOriginal, OracleDbType.Char, "to_char({0})"));
        }

        public static IVendorDbTypes Instance => new OracleEbDbTypes();

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

    public class OracleDB : IDatabase
    {
        public override DatabaseVendors Vendor
        {
            get
            {
                return DatabaseVendors.ORACLE;
            }
        }

        public override IVendorDbTypes VendorDbTypes
        {
            get
            {
                return OracleEbDbTypes.Instance;
            }
        }

        private const string CONNECTION_STRING_BARE = "Data Source=(DESCRIPTION =" + "(ADDRESS = (PROTOCOL = TCP)(HOST = {0})(PORT = {1}))" + "(CONNECT_DATA =" + "(SERVER = DEDICATED)" + "(SERVICE_NAME = XE)));" + "User Id= {2};Password={3};Pooling=true;Min Pool Size=1;Connection Lifetime=180;Max Pool Size=50;Incr Pool Size=5";
        private string _cstr;
        private EbDbConfig DbConfig { get; set; }
        public override string DBName { get; }

        public OracleDB(EbDbConfig dbconf)
        {
            this.DbConfig = dbconf;
            _cstr = string.Format(CONNECTION_STRING_BARE, this.DbConfig.Server, this.DbConfig.Port, this.DbConfig.UserName, this.DbConfig.Password);
            DBName = DbConfig.DatabaseName;
        }
        public OracleDB()
        {

        }

        public override DbConnection GetNewConnection(string dbName)
        {
            //System.Data.Common.DbConnection con = new OracleConnection();
            return new OracleConnection(_cstr);
        }

        public override DbConnection GetNewConnection()
        {
            return new OracleConnection(_cstr);

        }

        public override System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql)
        {
            return new OracleCommand(sql, (OracleConnection)con);
        }

        public override System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type, object value)
        {
            if (type == EbDbTypes.DateTime)
                return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(EbDbTypes.DateTime)) { Value = new OracleDate(Convert.ToDateTime(value)) };
            if (type == EbDbTypes.Date || type == EbDbTypes.Time || type == EbDbTypes.DateTime2)
                return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = Convert.ToDateTime(value).Date };
            else
                return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = value };
        }

        public override System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
        }

        public override System.Data.Common.DbParameter GetNewOutParameter(string parametername, EbDbTypes type)
        {
            return new OracleParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Direction = ParameterDirection.Output };
        }

        public override EbDataTable DoQuery(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();
            List<DbParameter> dbParameter = new List<DbParameter>();

            foreach (var param in parameters)
            {
                if (Regex.IsMatch(query, ":" + param.ParameterName))
                    dbParameter.Add(param);
            }

            using (var con = dbConnection as OracleConnection)
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
                catch (SocketException scket)
                {
                    throw scket;
                }
            }

            return dt;
        }

        public override EbDataSet DoQueries(DbConnection dbConnection, string query, params DbParameter[] parameters)
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

            using (var con = dbConnection as OracleConnection)
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

        protected override DbDataReader DoQueriesBasic(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            var con = dbConnection as OracleConnection;
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

        public override int DoNonQuery(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            var return_val = 0;
            List<DbParameter> dbParameter = new List<DbParameter>();
            string[] sql_arr = query.Split(";");
            foreach (var param in parameters)
            {
                if (Regex.IsMatch(query, ":" + param.ParameterName))
                    dbParameter.Add(param);
            }

            using (var con = dbConnection as OracleConnection)
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

        public override EbDataTable DoProcedure(DbConnection dbConnection, string query, params DbParameter[] parameters)
        {
            return null;
        }

        public override T DoQuery<T>(string query, params DbParameter[] parameters)
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

        public override EbDataTable DoQuery(string query, params DbParameter[] parameters)
        {
            EbDataTable dt = new EbDataTable();
            try
            {
                var con = GetNewConnection() as OracleConnection;
                dt = DoQuery(con, query, parameters);
            }
            catch (OracleException orcl)
            {
                Console.WriteLine(orcl.Message);
            }
            catch (SocketException scket)
            {
                throw scket;
            }
            return dt;
        }

        //public DbDataReader DoQueriesBasic(string query, params DbParameter[] parameters)
        //{
        //    DbDataReader dbDataReader;
        //    try
        //    {
        //        var con = GetNewConnection() as OracleConnection;
        //        dbDataReader = DoQueriesBasic(query, con, parameters);
        //        return dbDataReader;
        //    }
        //    catch (OracleException orcl)
        //    {
        //        Console.WriteLine(orcl.Message);
        //    }
        //    return null;
        //}

        public override EbDataSet DoQueries(string query, params DbParameter[] parameters)
        {
            EbDataSet ds = new EbDataSet();
            try
            {
                var con = GetNewConnection() as OracleConnection;
                ds = DoQueries(con, query, parameters);
            }
            catch (OracleException orcl)
            {
                Console.WriteLine(orcl.Message);
            }
            return ds;
        }

        public override EbDataTable DoProcedure(string query, params DbParameter[] parameters)
        {
            return null;
        }

        public override int DoNonQuery(string query, params DbParameter[] parameters)
        {
            var return_val = 0;
            try
            {
                var con = GetNewConnection() as OracleConnection;
                return_val = DoNonQuery(con, query, parameters);
            }
            catch (OracleException orcl)
            {
                Console.WriteLine(orcl.Message);
            }

            return return_val;
        }

        public override T ExecuteScalar<T>(string query, params DbParameter[] parameters)
        {
            throw new NotImplementedException();

        }

        public override bool IsTableExists(string query, params DbParameter[] parameters)
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
                catch (SocketException scket)
                {
                    throw scket;
                }
            }

            return rslt;
        }

        public override int CreateTable(string query)
        {
            int res = 0;
            using (var con = GetNewConnection() as OracleConnection)
            {
                try
                {
                    con.Open();
                    using (OracleCommand cmd = new OracleCommand(query, con))
                    {
                        cmd.BindByName = true;
                        res = cmd.ExecuteNonQuery();
                    }
                }
                catch (OracleException orcl)
                {
                    Console.WriteLine(orcl.Message);
                    throw orcl;
                }
                catch (SocketException scket)
                {
                    throw scket;
                }
            }
            return res;
        }

        public override int InsertTable(string query, params DbParameter[] parameters)
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
                catch (SocketException scket) { throw scket; }
            }
        }

        public override int UpdateTable(string query, params DbParameter[] parameters)
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

        public override int AlterTable(string query, params DbParameter[] parameters)
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

        public override int DeleteTable(string query, params DbParameter[] parameters)
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

        public override ColumnColletion GetColumnSchema(string table)
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
                catch (SocketException scket)
                {
                    throw scket;
                }
            }
            return cols;
        }

        public override Dictionary<int, string> GetDictionary(string query, string dm, string vm)
        {
            throw new NotImplementedException();
        }

        public override List<int> GetAutoResolveValues(string query, string vm, string cond)
        {
            throw new NotImplementedException();
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
            else if (_typ == "Byte[]")
                return EbDbTypes.Bytea;
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

        public override string EB_INITROLE2USER { get { return "INSERT INTO eb_role2user(role_id, user_id, createdat) VALUES (@role_id, @user_id, SYSDATE);"; } }
        public override string EB_USER_ROLE_PRIVS { get { return @"SELECT granted_role FROM USER_ROLE_PRIVS WHERE USERNAME='@uname'"; } }
        public override string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM table(eb_authenticate_unified(uname => :uname, passwrd => :pass,wc => :wc))"; } }
        public override string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM table(eb_authenticate_unified(social => :social, wc => :wc))"; } }
        public override string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM table(eb_authenticate_unified(uname => :uname, wc => :wc))"; } }

        public override string EB_AUTHENTICATE_ANONYMOUS { get { return "SELECT * FROM table(eb_authenticate_anonymous(@params in_appid => :appid ,in_wc => :wc))"; } }

        public override string EB_SIDEBARUSER_REQUEST { get { return @"
                       SELECT id, applicationname,app_icon
                FROM eb_applications ORDER BY applicationname;
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

        public override string EB_SIDEBARCHECK { get { return "AND EO.id = ANY(:Ids) "; } }

        public override string EB_GETROLESRESPONSE_QUERY
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
        public override string EB_GETMANAGEROLESRESPONSE_QUERY
        {
            get
            {
                return @"
                        SELECT id, applicationname FROM eb_applications where COALESCE(eb_del, 'F') = 'F' ORDER BY applicationname;
						SELECT DISTINCT EO.id, EO.display_name, EO.obj_type, EO2A.app_id
							FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
							WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
							AND EOS.id = ANY(SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id)
							AND EO.id = EO2A.obj_id AND COALESCE(EO2A.eb_del, 'F') = 'F';
						SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> :id ORDER BY to_char(role_name);
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE COALESCE(eb_del, 'F') = 'F';
						SELECT id, longname, shortname FROM eb_locations;
                        SELECT id, fullname, email, phnoprimary FROM eb_users WHERE COALESCE(eb_del, 'F') = 'F';";
            }
        }

        public override string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED
        {
            get
            {
                return @"
                                    SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = :id;
									SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = :id AND eb_del = 'F';
                					SELECT A.applicationname, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = :id AND A.eb_del = 'F';
									SELECT A.id, A.firstname, A.email, A.phnoprimary, B.id FROM eb_users A, eb_role2user B
										WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = :id;
									SELECT locationid FROM eb_role2location WHERE roleid = :id AND eb_del='F';";
            }
        }

        public override string EB_SAVEROLES_QUERY { get { return "SELECT eb_create_or_update_rbac_roles(:role_id, :applicationid, :createdby, :role_name, :description, :is_anonym, :users, :dependants, :permission, :locations) FROM dual"; } }


        public override string EB_SAVEUSER_QUERY { get { return "SELECT eb_createormodifyuserandroles(:userid, :id, :fullname, :nickname, :email, :pwd, :dob, :sex, :alternateemail, :phprimary, :phsecondary, :phlandphone, :extension, :fbid, :fbname, :roles, :groups, :statusid, :hide, :anonymoususerid, :preference) FROM dual;"; } }

        public override string EB_SAVEUSERGROUP_QUERY { get { return "SELECT eb_createormodifyusergroup(:userid,:id,:name,:description,:users) FROM dual;"; } }

        public override string EB_MANAGEUSER_FIRST_QUERY
        {
            get
            {
                return @"SELECT id, role_name, description FROM eb_roles ORDER BY to_char(role_name);
                        SELECT id, name,description FROM eb_usergroup ORDER BY name;
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';";
            }
        }

        public override string EB_GET_MYPROFILE_OBJID
        {
            get
            {
                return @"";
            }
        }

        public override string EB_CREATEAPPLICATION_DEV
        {
            get
            {
                return @"INSERT INTO eb_applications (applicationname,application_type, description,app_icon) VALUES (:applicationname,:apptype, :description,:appicon) RETURNING id;";
            }
        }

        public override string EB_EDITAPPLICATION_DEV
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

        public override string EB_GETTABLESCHEMA
        {
            get
            {
                return @"SELECT ACols.*, BCols.foreign_table_name, BCols.foreign_column_name 
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

        public override string EB_GET_CHART_2_DETAILS
        {
            get
            {
                return @"SELECT created_at FROM eb_executionlogs WHERE refid = :refid AND created_at::TIMESTAMP::DATE =current_date";
            }
        }

        public override string EB_GET_PROFILERS
        {
            get
            {
                return @"SELECT id, exec_time FROM eb_executionlogs WHERE exec_time=(SELECT MAX(exec_time) FROM eb_executionlogs WHERE refid = :refid);
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

        public override string EB_GETUSEREMAILS
        {
            get
            {
                return @"SELECT id, email FROM eb_users WHERE id = ANY
                             (string_to_array(:userids,',')::int[]);
                           SELECT distinct id, email FROM eb_users WHERE id = ANY(SELECT userid FROM eb_user2usergroup WHERE 
                                groupid = ANY(string_to_array(:groupids,',')::int[])) ;";
            }
        }

        public override string EB_GETPARTICULARSSURVEY
        {
            get
            {
                return @"SELECT name,startdate,enddate,status FROM eb_surveys WHERE id = :id;
							SELECT * FROM
								(SELECT UNNEST(string_to_array(S.questions, ',')::int[]) AS q_id FROM eb_surveys S WHERE id = :id) QUES_IDS, 
								(SELECT Q.id, Q.query, Q.q_type FROM eb_survey_queries Q) QUES_ANS,
								(SELECT C.choice,C.score,C.id, C.q_id from eb_query_choices C WHERE eb_del = 'F' ) QUES_QRY
								WHERE QUES_IDS.q_id = QUES_ANS.id
									AND QUES_QRY.q_id = QUES_ANS.id";
            }
        }

        public override string EB_SURVEYMASTER
        {
            get
            {
                return @"INSERT INTO eb_survey_master(surveyid,userid,anonid,eb_createdate) VALUES(:sid,:uid,:anid,now()) RETURNING id;";
            }
        }

        public override string EB_CURRENT_TIMESTAMP
        {
            get
            {
                return @"CURRENT_TIMESTAMP AT TIME ZONE 'UTC'";
            }
        }

        public override string EB_SAVESURVEY
        {
            get
            {
                return @"
INSERT INTO eb_surveys(name, startdate, enddate, status, questions) VALUES (:name, :start, :end, :status, :questions) RETURNING id;";
            }
        }

        public override string EB_PROFILER_QUERY_COLUMN
        {
            get
            {
                return @"SELECT id, rows, exec_time, created_by, created_at FROM eb_executionlogs WHERE refid = :refid; ";
            }
        }

        public override string EB_PROFILER_QUERY_DATA
        {
            get
            {
                return @"SELECT COUNT(id) FROM eb_executionlogs WHERE refid = :refid; 
                SELECT EL.id, EL.rows, EL.exec_time, EU.fullname, EL.created_at FROM eb_executionlogs EL, eb_users EU
                WHERE refid = :refid AND EL.created_by = EU.id
                LIMIT :limit OFFSET :offset;";
            }
        }

        public override string EB_LOGIN_ACTIVITY_ALL_USERS
        {
            get
            {
                return @"";
            }
        }

        public override string EB_LOGIN_ACTIVITY_USERS
        {
            get
            {
                return @"";
            }
        }

        public override string EB_GET_CHART_DETAILS
        {
            get
            {
                return @"SELECT rows, exec_time FROM eb_executionlogs WHERE refid = :refid AND EXTRACT(month FROM created_at) = EXTRACT(month FROM current_date);";
            }
        }

        public override string EB_INSERT_EXECUTION_LOGS
        {
            get
            {
                return @"INSERT INTO eb_executionlogs(rows, exec_time, created_by, created_at, params, refid) 
                                VALUES(:rows, :exec_time, :created_by, :created_at, :params, :refid);";
            }
        }

        public override string EB_GET_SELECT_CONSTRAINTS
        {
            get
            {
                return @"SELECT m.id, m.key_id, m.key_type, m.description, l.id AS lid, l.c_type, l.c_operation, l.c_value 
	                    FROM eb_constraints_master m, eb_constraints_line l
	                    WHERE m.id = l.master_id AND key_type = {0} AND m.key_id = :{1} AND eb_del = 'F' ORDER BY m.id;";
            }
        }

        public override string EB_SAVE_LOCATION_2Q
        {
            get
            {
                return @"UPDATE eb_locations SET longname = :lname, shortname = :sname, image = :img, meta_json = :meta WHERE id = :lid;";
            }
        }

        public override string EB_DELETE_LOC
        {
            get
            {
                return @"UPDATE eb_location_config SET eb_del = 'T' WHERE id = :id;";
            }
        }

        public override string EB_GET_MOB_MENU_OBJ_IDS
        {
            get
            {
                return @"";
            }
        }

        public override string EB_GET_MOBILE_PAGES
        {
            get
            {
                return @"";
            }
        }

        public override string EB_GET_MOBILE_PAGES_OBJS
        {
            get
            {
                return @"";
            }
        }

        public override string EB_GET_MYACTIONS
        {
            get
            {
                return @"";
            }
        }

        public override string EB_GET_USER_DASHBOARD_OBJECTS
        {
            get
            {
                return @"";
            }
        }

        // DBClient

        public override string EB_GETDBCLIENTTTABLES
        {
            get { return @"
                "; }
        }

        //.......OBJECTS QUERIES.....

        public override string EB_FETCH_ALL_VERSIONS_OF_AN_OBJ
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
        public override string EB_PARTICULAR_VERSION_OF_AN_OBJ
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
        public override string EB_LATEST_COMMITTED_VERSION_OF_AN_OBJ
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
        public override string EB_COMMITTED_VERSIONS_OF_ALL_OBJECTS_OF_A_TYPE
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
        public override string EB_GET_LIVE_OBJ_RELATIONS
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
        public override string EB_GET_ALL_COMMITTED_VERSION_LIST
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
                                EO.obj_name, EOV.id
                ";
            }
        }
        public override string EB_GET_OBJECTS_OF_A_TYPE
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
        public override string EB_GET_OBJ_STATUS_HISTORY
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
        public override string EB_LIVE_VERSION_OF_OBJS
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
                        AND ROWNUM<=1
                        ORDER BY EOV.eb_objects_id;";
            }
        }
        public override string EB_GET_ALL_TAGS
        {
            get
            {
                return @"WITH obj_tags AS (SELECT LISTAGG(obj_tags,',')WITHIN GROUP(ORDER BY obj_tags) tags FROM eb_objects)SELECT DISTINCT  
                         REGEXP_SUBSTR (tags, '[^,]+', 1, LEVEL) DISTINCT_TAGS  FROM obj_tags 
                         CONNECT BY LEVEL <= (SELECT LENGTH (REPLACE (tags, ',', NULL)) FROM obj_tags)
                ";
            }
        }
        public override string EB_GET_TAGGED_OBJECTS
        {
            get
            {
                return "SELECT * FROM TABLE(eb_get_tagged_object(:tags))";
            }
        }

        public override string EB_GET_MLSEARCHRESULT
        {
            get
            {
                return @"SELECT count(*) FROM (SELECT * FROM eb_keys WHERE LOWER(key) LIKE LOWER(@KEY)) AS Temp;
											SELECT A.id, A.key, B.id, B.name, C.id, C.value
											FROM (SELECT * FROM eb_keys WHERE LOWER(key) LIKE LOWER(@KEY) ORDER BY key ASC OFFSET @OFFSET LIMIT @LIMIT) A,
													eb_languages B, eb_keyvalue C
											WHERE A.id=C.key_id AND B.id=C.lang_id  
											ORDER BY A.key ASC, B.name ASC;";
            }
        }

        public override string EB_MLADDKEY
        {
            get
            {
                return @"INSERT INTO eb_keys (key) VALUES(@KEY) RETURNING id;";
            }
        }

        public override string EB_GET_BOT_FORM
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

        public override string IS_TABLE_EXIST
        {
            get
            {
                return @"select count(*) from user_tables where table_name = upper(:tbl)";
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
                            EO.id = ANY(string_to_array(:ids,',')::int[]) AND
                            EO.id = EOV.eb_objects_id AND COALESCE(EOV.working_mode, 'F') <> 'T'
                        ORDER BY
                            EO.obj_name; ";
            }
        }

        public override string EB_CREATELOCATIONCONFIG1Q
        {
            get
            {
                return @"INSERT INTO eb_location_config (keys,isrequired,keytype,eb_del) VALUES(:keys,:isrequired,:type,'F') RETURNING id; ";
            }
        }

        public override string EB_CREATELOCATIONCONFIG2Q
        {
            get
            {
                return @"UPDATE eb_location_config SET keys = :keys ,isrequired = :isrequired , keytype = :type WHERE id = :keyid;";
            }
        }

        public override string EB_GET_DISTINCT_VALUES
        {
            get
            {
                return @"SELECT DISTINCT (TRIM(:ColumName)) AS :ColumName FROM :TableName ORDER BY :ColumName;";
            }
        }

        public override string EB_ADD_FAVOURITE
        {
            get
            {
                return @"INSERT INTO 
                                eb_objects_favourites(userid,object_id)
                            VALUES(:userid,:objectid)";
            }
        }

        public override string EB_REMOVE_FAVOURITE
        {
            get
            {
                return @"UPDATE 
                                eb_objects_favourites SET eb_del= 'T' 
                           WHERE 
                                userid = :userid 
                           AND 
                                object_id = :objectid";
            }
        }

        public override string EB_GET_APPLICATIONS
        {
            get
            {
                return @"SELECT id, applicationname, description, application_type, app_icon, app_settings FROM eb_applications WHERE id = :id AND eb_del = 'F'";
            }
        }

        public override string EB_GET_OBJECTS_BY_APP_ID
        {
            get
            {
                return @"SELECT applicationname,description,app_icon,application_type, app_settings FROM eb_applications WHERE id = :appid AND  eb_del = 'F';
				                SELECT 
				                     EO.id, EO.obj_type, EO.obj_name, EO.obj_desc, EO.display_name,EOV.refid,EOV.working_mode
				                FROM
				                     eb_objects_ver EOV,eb_objects EO
				                INNER JOIN
				                     eb_objects2application EO2A
				                ON
				                     EO.id = EO2A.obj_id
				                WHERE 
				                    EO2A.app_id = :appid
								    AND	EO.id = EOV.eb_objects_id
                                    AND	COALESCE(EO.eb_del, 'F') = 'F'
                                    AND COALESCE(EO2A.eb_del, 'F') = 'F'
				                ORDER BY
				                    EO.obj_type;";
            }
        }

        public override string EB_SAVE_APP_SETTINGS
        {
            get
            {
                return @"UPDATE eb_applications SET app_settings = :newsettings WHERE id = :appid AND application_type = :apptype AND eb_del='F';";
            }
        }

        public override string EB_UNIQUE_APPLICATION_NAME_CHECK
        {
            get
            {
                return @"SELECT id FROM eb_applications WHERE applicationname = :name ;";
            }
        }

        public override string EB_DELETE_APP
        {
            get
            {
                return @"UPDATE eb_applications SET eb_del = 'T' WHERE id = :appid";
            }
        }

        public override string EB_UPDATE_APP_SETTINGS
        {
            get
            {
                return @"UPDATE eb_applications SET app_settings = :settings WHERE id = :appid";
            }
        }

        public override string EB_OBJ_ALL_VER_WIHOUT_CIRCULAR_REF
        {
            get
            {
                return @" SELECT 
                                EO.id, EO.obj_name, EO.display_name, 
                                EOV.id, EOV.version_num, EOV.refid
                            FROM
                                eb_objects EO, eb_objects_ver EOV
                            WHERE
                                EO.id = EOV.eb_objects_id AND
                                EOV.working_mode = 'F' AND
                                EO.obj_type = :obj_type 
                            ORDER BY 
                                EO.display_name ASC, EOV.version_num DESC;";
            }
        }

        public override string EB_OBJ_ALL_VER_WIHOUT_CIRCULAR_REF_REFID
        {
            get
            {
                return @"SELECT 
                                EO.id, EO.obj_name, EO.display_name, 
                                EOV.id, EOV.version_num, EOV.refid
                            FROM
                                eb_objects EO, eb_objects_ver EOV
                            WHERE
                                EO.id = EOV.eb_objects_id AND
                                EOV.working_mode = 'F' AND
                                EO.obj_type = :obj_type AND
                                EOV.refid != :dominant AND
                                EOV.refid NOT IN (
                                    WITH RECURSIVE objects_relations AS (
	                                SELECT dependant FROM eb_objects_relations WHERE eb_del='F' AND dominant = :dominant
	                                UNION
	                                SELECT a.dependant FROM eb_objects_relations a, objects_relations b WHERE a.eb_del='F' AND a.dominant = b.dependant
                                    )SELECT * FROM objects_relations
                                )
                            ORDER BY 
                                EO.display_name ASC, EOV.version_num DESC;";
            }
        }

        public override string EB_UNIQUE_OBJECT_NAME_CHECK
        {
            get
            {
                return @"SELECT id FROM eb_objects WHERE display_name = :name ;";
            }
        }

        public override string EB_ENABLE_LOG
        {
            get
            {
                return @"UPDATE eb_objects SET is_logenabled = :log WHERE id = :id";
            }
        }

        public override string EB_DELETE_OBJECT
        {
            get
            {
                return @"UPDATE eb_objects SET eb_del='T' WHERE id = :id;             
                           UPDATE eb_objects_ver SET eb_del='T' WHERE eb_objects_id = :id;";
            }
        }

        //.....OBJECT FUNCTION CALLS
        public override string EB_CREATE_NEW_OBJECT
        {
            get
            {
                return "SELECT eb_objects_create_new_object(:obj_name, :obj_desc, :obj_type, :obj_cur_status, :commit_uid, :src_pid, :cur_pid, :relations, :issave, :tags, :app_id,:s_obj_id, :s_ver_id) FROM DUAL";
            }
        }
        public override string EB_SAVE_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_save(:id, :obj_name, :obj_desc, :obj_type, :commit_uid,  :relations, :tags, :app_id) FROM DUAL";
            }
        }
        public override string EB_COMMIT_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_commit(:id, :obj_name, :obj_desc, :obj_type, :obj_changelog,  :commit_uid,  :relations, :tags, :app_id) FROM DUAL
                ";
            }
        }
        public override string EB_EXPLORE_OBJECT
        {
            get
            {
                return @"   
                    SELECT * FROM TABLE(eb_objects_exploreobject(:id))
                ";
            }
        }
        public override string EB_MAJOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_major_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations) FROM DUAL
                ";
            }
        }
        public override string EB_MINOR_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_minor_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations) FROM DUAL
                ";
            }
        }
        public override string EB_CHANGE_STATUS_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_objects_change_status(:id, :status, :commit_uid, :obj_changelog) FROM DUAL
                ";
            }
        }
        public override string EB_PATCH_VERSION_OF_OBJECT
        {
            get
            {
                return @"   
                    SELECT eb_object_create_patch_version(:id, :obj_type, :commit_uid, :src_pid, :cur_pid, :relations) FROM DUAL
                ";
            }
        }
        public override string EB_UPDATE_DASHBOARD
        {
            get
            {
                return @"   
                    SELECT * FROM TABLE(eb_objects_update_dashboard(:refid))
                ";
            }
        }

        public override string EB_SAVELOCATION
        {
            get
            {
                return @"INSERT INTO eb_locations(longname,shortname,image,meta_json) VALUES(:lname,:sname,:img,:meta) RETURNING id;";
            }
        }

        public override string EB_CREATEBOT
        {
            get
            {
                return @"SELECT * FROM eb_createbot(@solid, @name, @fullname, @url, @welcome_msg, @uid, @botid)";
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
                            (:refid, :filestoreid, :length, :imagequality_id, :is_image, :imgmanpserid, :filedb_con_id) RETURNING id";
            }
        }

        public override string EB_DPUPDATESQL
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

        //public override string EB_LOGOUPDATESQL
        //{
        //    get
        //    {
        //        return @"INSERT INTO eb_files_ref_variations 
        //                    (eb_files_ref_id, filestore_sid, length, imagequality_id, is_image, img_manp_ser_con_id, filedb_con_id)
        //                VALUES 
        //                    (:refid, :filestoreid, :length, :imagequality_id, :is_image, :imgmanpserid, :filedb_con_id) RETURNING id;
        //                UPDATE eb_solutions SET logorefid = :refid WHERE isolution_id = :solnid;";
        //    }
        //}

        public override string EB_MQ_UPLOADFILE
        {
            get
            {
                return @"INSERT INTO eb_files_ref_variations 
                            (eb_files_ref_id, filestore_sid, length, is_image, filedb_con_id)
                         VALUES 
                            (:refid, :filestoresid, :length, :is_image, :filedb_con_id) RETURNING id";
            }
        }

        public override string EB_GETFILEREFID
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

        public override string EB_UPLOAD_IDFETCHQUERY
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

        public override string EB_FILECATEGORYCHANGE
        {
            get
            {
                return @"SELECT id,tags FROM eb_files_ref WHERE id = ANY(string_to_array(:ids,',')::int[]);";
            }
        }

        public override string EB_DOWNLOAD_FILE_BY_ID
        {
            get
            {
                return @"SELECT
                                B.filestore_sid , B.filedb_con_id
                            FROM 
                                eb_files_ref A, eb_files_ref_variations B
                            WHERE 
                                A.id=B.eb_files_ref_id AND A.id = :fileref;";
            }
        }

        public override string EB_DOWNLOAD_IMAGE_BY_ID
        {
            get
            {
                return @"SELECT 
                                B.imagequality_id, B.filestore_sid, B.filedb_con_id
                            FROM 
                                eb_files_ref A, eb_files_ref_variations B
                            WHERE 
                                A.id=B.eb_files_ref_id AND A.id = :fileref
                            ORDER BY 
                                B.imagequality_id;";
            }
        }

        public override string EB_DOWNLOAD_DP
        {
            get
            {
                return @"SELECT 
                                V.filestore_sid , V.filedb_con_id
                            FROM 
                                eb_files_ref_variations V 
                            INNER JOIN 
                                eb_users U
                            ON 
                                V.eb_files_ref_id = U.dprefid
                            WHERE 
                                U.id = @userid";
            }
        }

        public override string EB_GET_SELECT_FILE_UPLOADER_CXT
        {
            get
            {
                return @"SELECT 
	                            B.id, B.filename, B.tags, B.uploadts,B.filecategory
                            FROM
	                            eb_files_ref B
                            WHERE
	                            B.context = CONCAT(:context, '_@Name@') AND B.eb_del = 'F';";
            }
        }

        public override string EB_GET_SELECT_FILE_UPLOADER_CXT_SEC
        {
            get
            {
                return @"SELECT 
	                            B.id, B.filename, B.tags, B.uploadts,B.filecategory
                            FROM
	                            eb_files_ref B
                            WHERE
	                            (B.context = CONCAT(:context, '_@Name@') OR B.context_sec = :context_sec) AND B.eb_del = 'F';";
            }
        }

        public override string EB_GET_LOG_ENABLED
        {
            get
            {
                return @"SELECT is_logenabled FROM eb_objects WHERE id = (SELECT eb_objects_id FROM eb_objects_ver WHERE refid = :refid)";
            }
        }

        //....api query...
        public override string EB_API_SQL_FUNC_HEADER
        {
            get
            {
                return @"CREATE OR REPLACE FUNCTION {0}(insert_json jsonb,update_json jsonb)
                            RETURNS void
                            LANGUAGE {1} AS $BODY$";
            }
        }

        public override string EB_API_BY_NAME
        {
            get
            {
                return @"SELECT 
	                            EOV.obj_json,EOV.version_num,EOS.status,EO.obj_tags, EO.obj_type
                            FROM
	                            eb_objects_ver EOV
                            INNER JOIN
	                            eb_objects EO ON EOV.eb_objects_id = EO.id
                            INNER JOIN
	                            eb_objects_status EOS ON EOS.eb_obj_ver_id = EOV.id
                            WHERE
	                            EO.obj_type=20 
                            AND
	                            EO.obj_name = :objname
                            AND 
	                            EOV.version_num = :version
                            LIMIT 1;";
            }
        }

        public override string EB_PARAM_SYMBOL
        {
            get
            {
                return ":";
            }
        }
    }

    public class OracleFilesDB : OracleDB, INoSQLDatabase
    {
        public OracleFilesDB(EbDbConfig dbconf) : base(dbconf) { }

        public int InfraConId { get => throw new NotImplementedException(); set => throw new NotImplementedException(); }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory category)
        {
            throw new NotImplementedException();
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory category)
        {
            throw new NotImplementedException();
        }
    }
}

// Auto disconnect: https://stackoverflow.com/questions/35352060/odp-net-oracle-manageddataacess-random-ora-12570-errors
