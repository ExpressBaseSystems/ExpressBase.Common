using ExpressBase.Common;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Structures;
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

        VendorDbType IVendorDbTypes.Boolean { get { return InnerDictionary[EbDbTypes.Boolean]; } }
        //VendorDbType IVendorDbTypes.Currency => new VendorDbType(EbDbTypes.Currency, NpgsqlDbType.Money);
        //VendorDbType IVendorDbTypes.Guid => new VendorDbType(EbDbTypes.Double, NpgsqlDbType.Double);
        //VendorDbType IVendorDbTypes.SByte => new VendorDbType(EbDbTypes.SByte, NpgsqlDbType.in);
        // VendorDbType IVendorDbTypes.Single => new VendorDbType(EbDbTypes.Single, NpgsqlDbType.Real);
        //VendorDbType IVendorDbTypes.AnsiStringFixedLength => new VendorDbType(EbDbTypes.VarNumeric, (int)NpgsqlDbType.Numeric, NpgsqlDbType.Numeric.ToString());
        //VendorDbType IVendorDbTypes.Xml => new VendorDbType(EbDbTypes.Xml, (int)NpgsqlDbType.Xml, NpgsqlDbType.Xml.ToString());
        //VendorDbType IVendorDbTypes.DateTime2 => new VendorDbType(EbDbTypes.DateTime2, (int)NpgsqlDbType.Timestamp, NpgsqlDbType.Timestamp.ToString());
        //VendorDbType IVendorDbTypes.DateTimeOffset => new VendorDbType(EbDbTypes.DateTimeOffset, (int)NpgsqlDbType.Timestamp, NpgsqlDbType.Timestamp.ToString());
        //VendorDbType IVendorDbTypes.StringFixedLength => throw new NotImplementedException();
        //VendorDbType IVendorDbTypes.UInt16 => throw new NotImplementedException();
        //VendorDbType IVendorDbTypes.UInt32 => throw new NotImplementedException();
        //VendorDbType IVendorDbTypes.UInt64 => throw new NotImplementedException();

        private PGSQLEbDbTypes()
        {
            this.InnerDictionary = new Dictionary<EbDbTypes, VendorDbType>();
            this.InnerDictionary.Add(EbDbTypes.AnsiString, new VendorDbType(EbDbTypes.AnsiString, NpgsqlDbType.Text));
            this.InnerDictionary.Add(EbDbTypes.Binary, new VendorDbType(EbDbTypes.Binary, NpgsqlDbType.Bytea));
            this.InnerDictionary.Add(EbDbTypes.Byte, new VendorDbType(EbDbTypes.Byte, NpgsqlDbType.Char));
            this.InnerDictionary.Add(EbDbTypes.Date, new VendorDbType(EbDbTypes.Date, NpgsqlDbType.Date));
            this.InnerDictionary.Add(EbDbTypes.DateTime, new VendorDbType(EbDbTypes.DateTime, NpgsqlDbType.Timestamp));
            this.InnerDictionary.Add(EbDbTypes.Decimal, new VendorDbType(EbDbTypes.Decimal, NpgsqlDbType.Numeric));
            this.InnerDictionary.Add(EbDbTypes.Double, new VendorDbType(EbDbTypes.Double, NpgsqlDbType.Double));
            this.InnerDictionary.Add(EbDbTypes.Int16, new VendorDbType(EbDbTypes.Int16, NpgsqlDbType.Smallint));
            this.InnerDictionary.Add(EbDbTypes.Int32, new VendorDbType(EbDbTypes.Int32, NpgsqlDbType.Integer));
            this.InnerDictionary.Add(EbDbTypes.Int64, new VendorDbType(EbDbTypes.Int64, NpgsqlDbType.Bigint));
            this.InnerDictionary.Add(EbDbTypes.Object, new VendorDbType(EbDbTypes.Object, NpgsqlDbType.Json));
            this.InnerDictionary.Add(EbDbTypes.String, new VendorDbType(EbDbTypes.String, NpgsqlDbType.Text));
            this.InnerDictionary.Add(EbDbTypes.Time, new VendorDbType(EbDbTypes.Time, NpgsqlDbType.Time));
            this.InnerDictionary.Add(EbDbTypes.VarNumeric, new VendorDbType(EbDbTypes.VarNumeric, NpgsqlDbType.Numeric));
            this.InnerDictionary.Add(EbDbTypes.Json, new VendorDbType(EbDbTypes.Json, NpgsqlDbType.Json));
            this.InnerDictionary.Add(EbDbTypes.Boolean, new VendorDbType(EbDbTypes.Boolean, NpgsqlDbType.Char));
        }

        public static IVendorDbTypes Instance => new PGSQLEbDbTypes();

        public dynamic GetVendorDbType(EbDbTypes e)
        {
            return this.InnerDictionary[e].VDbType;
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

        //public System.Data.Common.DbCommand GetNewCommand(DbConnection con, string sql, DbTransaction trans)
        //{
        //    return new NpgsqlCommand(sql, (NpgsqlConnection)con, (NpgsqlTransaction)trans);
        //}

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type, object value)
        {
            return new NpgsqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type)) { Value = value };
        }

        public System.Data.Common.DbParameter GetNewParameter(string parametername, EbDbTypes type)
        {
            return new NpgsqlParameter(parametername, this.VendorDbTypes.GetVendorDbType(type));
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
                    Console.WriteLine(npgse.ToString());
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
            else if (_typ == typeof(int) || _typ == typeof(Int32))
                return EbDbTypes.Int32;
            else if (_typ == typeof(Int64))
                return EbDbTypes.Int64;
            else if (_typ == typeof(TimeSpan))
                return EbDbTypes.Time;

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

        public void CreateTable(string query)
        {
            using (var con = GetNewConnection() as NpgsqlConnection)
            {
                try
                {
                    con.Open();
                    using (NpgsqlCommand cmd = new NpgsqlCommand(query, con))
                    {
                        var xx = cmd.ExecuteNonQuery();
                    }
                }
                catch (Npgsql.NpgsqlException npgse)
                {
                    throw npgse;
                }
                catch (SocketException scket) { }
            }
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
                                cols.Add(column);
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
        public string EB_AUTHETICATE_USER_NORMAL { get { return "SELECT * FROM eb_authenticate_unified(uname => @uname, password => @pass, wc => @wc);"; } }

        public string EB_AUTHENTICATEUSER_SOCIAL { get { return "SELECT * FROM eb_authenticate_unified(social => @social, wc => @wc);"; } }

        public string EB_AUTHENTICATEUSER_SSO { get { return "SELECT * FROM eb_authenticate_unified(uname => @uname, wc => @wc);"; } }

        public string EB_AUTHENTICATE_ANONYMOUS { get { return "SELECT * FROM eb_authenticate_anonymous(@params in_appid => :appid ,in_wc => :wc);"; } }

        public string EB_SIDEBARUSER_REQUEST { get { return @"
                SELECT id, applicationname
                FROM eb_applications;
                SELECT
                    EO.id, EO.obj_type, EO.obj_name,
                    EOV.version_num, EOV.refid, EO2A.app_id,EO.obj_desc, EOS.status,EOS.id
                FROM
                    eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
                WHERE
                EOV.eb_objects_id=EO.id	
                AND EO.id = ANY('{:Ids}')               			    
				AND EOS.eb_obj_ver_id = EOV.id 
				AND EO2A.obj_id = EO.id
				AND EO2A.eb_del = 'F'
                AND EOS.status = 3 
				AND EOS.id = ANY( Select MAX(id) from eb_objects_status EOS Where EOS.eb_obj_ver_id = EOV.id And EOS.status = 3);"; } }
         
        public string EB_SIDEBARDEV_REQUEST {
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
	                            EO.obj_type;"; } }

        public string EB_SIDEBARCHECK { get { return "AND EO.id = ANY('{:Ids}') "; } }

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

										SELECT A.id, A.fullname, A.email, B.id FROM eb_users A, eb_role2user B
											WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = :id;"; } }
        public string EB_SAVEROLES_QUERY
        {
            get
            {
                return "SELECT eb_create_or_update_rbac_roles(:role_id, :applicationid, :createdby, :role_name, :description, :is_anonym, :users, :dependants, :permission " +
");";
            }
        }

        public string EB_SAVEUSER_QUERY { get { return "SELECT * FROM eb_createormodifyuserandroles(:userid,:id,:fullname,:nickname,:email,:pwd,:dob,:sex,:alternateemail,:phprimary,:phsecondary,:phlandphone,:extension,:fbid,:fbname,:roles,:groups,:statusid,:hide,:anonymoususerid,:preference);"; } }
        public string EB_SAVEUSERGROUP_QUERY { get { return "SELECT * FROM eb_createormodifyusergroup(:userid,:id,:name,:description,:users);"; } }


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
                            EU.fullname
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
                            EU.fullname
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
                            EO.id = :id AND EOV.eb_objects_id = :id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id
                ";
            }
        }
        public string EB_GET_ALL_TAGS
        {
            get
            {
                return @"SELECT distinct(tags)
                    FROM (SELECT unnest(string_to_array(obj_tags, ',')) AS tags
	                      FROM eb_objects)
                    AS tags
                ";
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


        //.....OBJECTS FUNCTION CALL......
        public string EB_CREATE_NEW_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_create_new_object(:obj_name, :obj_desc, :obj_type, :obj_cur_status, :obj_json::json, :commit_uid, :src_pid, :cur_pid, :relations, :issave, :tags, :app_id)

                ";
            }
        }
        public string EB_SAVE_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_save(:id, :obj_name, :obj_desc, :obj_type, :obj_json, :commit_uid, :src_pid, :cur_pid, :relations, :tags, :app_id)
                ";
            }
        }
        public string EB_COMMIT_OBJECT
        {
            get
            {
                return @"
                    SELECT eb_objects_commit(:id, :obj_name, :obj_desc, :obj_type, :obj_json, :obj_changelog,  :commit_uid, :src_pid, :cur_pid, :relations, :tags, :app_id)
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


    }
}

