﻿using ExpressBase.Common.Data;
using ExpressBase.Common.Structures;
using MongoDB.Driver;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;

namespace ExpressBase.Common.Connections
{

    public static class EbConnectionExtens
    {
        public static void Persist(this IEbConnection con, string TenantAccountId, EbConnectionFactory infra, bool IsNew, int UserId)
        {
            if (IsNew)
            {
                string sql = "INSERT INTO eb_connections (con_type, solution_id, nick_name, con_obj,date_created,eb_user_id) VALUES (@con_type, @solution_id, @nick_name, @con_obj , NOW() , @eb_user_id) RETURNING id";
                DbParameter[] parameters = {
                                                infra.DataDB.GetNewParameter("con_type", EbDbTypes.String, con.EbConnectionType.ToString()),
                                                infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, TenantAccountId),
                                                infra.DataDB.GetNewParameter("nick_name", EbDbTypes.String, !(string.IsNullOrEmpty(con.NickName))?con.NickName:string.Empty),
                                                infra.DataDB.GetNewParameter("con_obj", EbDbTypes.Json,EbSerializers.Json_Serialize(con) ),
                                                infra.DataDB.GetNewParameter("eb_user_id", EbDbTypes.Int32, UserId )
                                           };
                var iCount = infra.DataDB.DoQuery(sql, parameters);
            }
            else if (!IsNew)
            {
                string sql = @"UPDATE eb_connections SET eb_del = 'T' WHERE con_type = @con_type AND solution_id = @solution_id AND id = @id; 
                              INSERT INTO eb_connections (con_type, solution_id, nick_name, con_obj, date_created, eb_user_id) VALUES (@con_type, @solution_id, @nick_name, @con_obj, NOW() , @eb_user_id)";
                DbParameter[] parameters = {
                                                infra.DataDB.GetNewParameter("con_type", EbDbTypes.String, con.EbConnectionType.ToString()),
                                                infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, TenantAccountId),
                                                infra.DataDB.GetNewParameter("nick_name", EbDbTypes.String, !(string.IsNullOrEmpty(con.NickName))?con.NickName:string.Empty),
                                                infra.DataDB.GetNewParameter("con_obj", EbDbTypes.Json,EbSerializers.Json_Serialize(con)),
                                                infra.DataDB.GetNewParameter("eb_user_id", EbDbTypes.Int32, UserId ),
                                                infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, con.Id)
                                           };
                var iCount = infra.DataDB.DoNonQuery(sql, parameters);
            }
        }
    }

    public interface IEbConnection
    {
        int Id { get; set; }

        bool IsDefault { get; set; }

        string NickName { get; set; }

        EbConnectionTypes EbConnectionType { get; }
    }

    public abstract class EbBaseDbConnection : IEbConnection
    {

        public string DatabaseName { get; set; }

        public string Server { get; set; }

        public int Port { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public string ReadWriteUserName { get; set; }

        public string ReadWritePassword { get; set; }

        public string ReadOnlyUserName { get; set; }

        public string ReadOnlyPassword { get; set; }

        public int Timeout { get; set; }

        public abstract EbConnectionTypes EbConnectionType { get; }

        public int Id { get; set; }

        public bool IsDefault { get; set; }

        public string NickName { get; set; }

        public bool IsSSL { get; set; }

    }

    public class EbObjectsDbConnection : EbBaseDbConnection
    {
        public DatabaseVendors DatabaseVendor { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbOBJECTS; } }
    }

    // For Infra T-Data, Tenant T-Data
    public class EbDataDbConnection : EbBaseDbConnection
    {
        public DatabaseVendors DatabaseVendor { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbDATA; } }

    }

    // For Infra Files, Tenant Files
    public class EbFilesDbConnection : EbBaseDbConnection
    {
        public FilesDbVendors FilesDbVendor { set; get; }

        [JsonConverter(typeof(CustomBase64Converter))]
        public string FilesDB_url { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbFILES; } }
    }

    public class EbLogsDbConnection : EbBaseDbConnection
    {
        public DatabaseVendors DatabaseVendor { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbLOGS; } }
    }

    internal class CustomBase64Converter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return true;
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            return System.Text.Encoding.UTF8.GetString((Convert.FromBase64String((string)reader.Value)));
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            writer.WriteValue(Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes((string)value)));
        }
    }

    public class Base64Serializer : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return (objectType == typeof(string));
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            return Convert.FromBase64String(reader.Value.ToString());
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            string valueAsString = Convert.ToBase64String(Encoding.ASCII.GetBytes(value.ToString()));

            if (!string.IsNullOrWhiteSpace(valueAsString))
                writer.WriteValue(valueAsString);
        }
    }


    //--------------------------------------------------------- integrations-----------------------------------


    public class EbIntegrationConf
    {
        public int Id { get; set; }

        public string NickName { get; set; }

        public virtual EbIntegrations Type { get; }

        public void PersistIntegrationConf(string Sol_Id, EbConnectionFactory infra, int UserId)
        {
            string query = @"INSERT INTO eb_integration_configs (solution_id, nickname, type, con_obj, created_by, created_at, eb_del) 
                               VALUES (@solution_id, @nick_name, @type, @con_obj, @uid, NOW() , 'F') RETURNING id;";

            //if (con.Id>0)
            //    query += @"UPDATE eb_integration_configs SET eb_del = 'T', modified_at = NOW(), modified_by = @uid WHERE id = @id;";

            DbParameter[] parameters = {
                                                infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, Sol_Id),
                                                infra.DataDB.GetNewParameter("nick_name", EbDbTypes.String, !(string.IsNullOrEmpty(this.NickName))?this.NickName:string.Empty),
                                                infra.DataDB.GetNewParameter("type", EbDbTypes.String, this.Type.ToString()),
                                                infra.DataDB.GetNewParameter("con_obj", EbDbTypes.Json,EbSerializers.Json_Serialize(this) ),
                                                infra.DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId ),
                                                infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, this.Id)
                                           };
            var iCount = infra.DataDB.DoQuery(query, parameters);
        }
    }

    public class EbDbConfig : EbIntegrationConf
    {
        public string DatabaseName { get; set; }

        public string Server { get; set; }

        public int Port { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public int Timeout { get; set; }

        public bool IsSSL { get; set; }

        public string ReadWriteUserName { get; set; }

        public string ReadWritePassword { get; set; }

        public string ReadOnlyUserName { get; set; }

        public string ReadOnlyPassword { get; set; }

    }

    public class PostgresConfig : EbDbConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.PGSQL; } }
        private const string CONNECTION_STRING_BARE = @"Host={0}; Port={1}; Database={2}; Username={3}; Password={4};  Trust Server Certificate=true; 
                                                        Pooling=true; CommandTimeout={5};SSL Mode=Require; Use SSL Stream=true; ";
    }

    public class OracleConfig : EbDbConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.ORACLE; } }
        private const string CONNECTION_STRING_BARE = @"Data Source=(DESCRIPTION =" + "(ADDRESS = (PROTOCOL = TCP)(HOST = {0})(PORT = {1}))" +
            "(CONNECT_DATA =" + "(SERVER = DEDICATED)" + "(SERVICE_NAME = XE)));" + "User Id= {2};Password={3};Pooling=true;Min Pool Size=1;" +
            "Connection Lifetime=180;Max Pool Size=50;Incr Pool Size=5";
    }

    public class MySqlConfig : EbDbConfig
    {
        public override EbIntegrations Type { get { return EbIntegrations.MYSQL; } }
        private const string CONNECTION_STRING_BARE = "Server={0}; Port={1}; Database={2}; Uid={3}; pwd={4};SslMode=none; ";
    }

    public class EbTwilioConfig : EbIntegrationConf
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string From { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.Twilio; } }
    }

    public class EbExpertTextingConfig : EbIntegrationConf
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string From { get; set; }

        public string ApiKey { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.ExpertTexting; } }
    }

    public class EbMongoConfig : EbIntegrationConf
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string Host { get; set; }

        public int Port { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.MongoDB; } }
    }

    public class EbSmtpConfig : EbIntegrationConf
    {
        public SmtpProviders ProviderName { get; set; }

        public string Host { get; set; }

        public int Port { get; set; }

        public string EmailAddress { get; set; }

        public string Password { get; set; }

        public bool EnableSsl { get; set; }

        public override EbIntegrations Type { get { return EbIntegrations.SMTP; } }
    }

    public class EbIntegration
    {
        public int Id { get; set; }

        public int ConfigId { get; set; }

        public EbConnections Type { get; set; }

        public ConPreferences Preference { get; set; }

        public void PersistIntegration(string Sol_Id, EbConnectionFactory infra, int UserId)
        {
            string query = @"INSERT INTO eb_integrations (solution_id, type, preference, eb_integration_conf_id, created_at, created_by, eb_del) 
                               VALUES (@solution_id, @type, @preference, @conf_id, NOW(), @uid, 'F') RETURNING id;";

            if (Id > 0)
                query += @"UPDATE eb_integration_configs SET eb_del = 'T', modified_at = NOW(), modified_by = @uid WHERE id = @id;";

            DbParameter[] parameters = {
                                                infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, Sol_Id),
                                                infra.DataDB.GetNewParameter("type", EbDbTypes.String, this.Type.ToString()),
                                                infra.DataDB.GetNewParameter("preference", EbDbTypes.Int32,Preference),
                                                infra.DataDB.GetNewParameter("conf_id", EbDbTypes.Int32, this.ConfigId),
                                                infra.DataDB.GetNewParameter("uid", EbDbTypes.Int32, UserId),
                                                infra.DataDB.GetNewParameter("id", EbDbTypes.Int32, this.Id)
                                           };
            var iCount = infra.DataDB.DoQuery(query, parameters);
        }

    }
}
