using ExpressBase.Common.Data;
using MongoDB.Driver;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public abstract class IEbConnection
    {
        public virtual EbConnectionTypes EbConnectionType { get; }

        public string NickName { get; set; }

        public virtual void Persist(string TenantAccountId, ITenantDbFactory dbconf, bool IsNew)
        {
            if (IsNew)
            {
                string sql = "INSERT INTO eb_connections (con_type, solution_id, nick_name, con_obj) VALUES (@con_type, @solution_id, @nick_name, @con_obj) RETURNING id";
                DbParameter[] parameters = { dbconf.DataDB.GetNewParameter("con_type", System.Data.DbType.String, EbConnectionType),
                                    dbconf.DataDB.GetNewParameter("solution_id", System.Data.DbType.String, TenantAccountId),
                                    dbconf.DataDB.GetNewParameter("nick_name", System.Data.DbType.String, !(string.IsNullOrEmpty(NickName))?NickName:string.Empty),
                                    dbconf.DataDB.GetNewParameter("con_obj", NpgsqlTypes.NpgsqlDbType.Json,EbSerializers.Json_Serialize(this) )};
                var iCount = dbconf.DataDB.DoQuery(sql, parameters);
            }

            else if (!IsNew)
            {
                string sql = @"UPDATE eb_connections SET eb_del = true WHERE con_type = @con_type AND solution_id = @solution_id; 
                                      INSERT INTO eb_connections (con_type, solution_id, nick_name, con_obj) VALUES (@con_type, @solution_id, @nick_name, @con_obj)";
                DbParameter[] parameters = { dbconf.DataDB.GetNewParameter("con_type", System.Data.DbType.String, EbConnectionType),
                                    dbconf.DataDB.GetNewParameter("solution_id", System.Data.DbType.String, TenantAccountId),
                                    dbconf.DataDB.GetNewParameter("nick_name", System.Data.DbType.String, !(string.IsNullOrEmpty(NickName))?NickName:string.Empty),
                                    dbconf.DataDB.GetNewParameter("con_obj", NpgsqlTypes.NpgsqlDbType.Json,EbSerializers.Json_Serialize(this) )};
                var iCount = dbconf.DataDB.DoNonQuery(sql, parameters);
            }
        }
    }

    public abstract class EbBaseDbConnection : IEbConnection
    {
        public DatabaseVendors DatabaseVendor { get; set; }

        public string DatabaseName { get; set; }

        public string Server { get; set; }

        public int Port { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public int Timeout { get; set; }
    }

    public class EbObjectsDbConnection : EbBaseDbConnection
    {
        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbOBJECTS; } }
    }

    // For Infra T-Data, Tenant T-Data
    public class EbDataDbConnection : EbBaseDbConnection
    {
        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbDATA; } }
    }

    // For Infra Files, Tenant Files
    public class EbFilesDbConnection : IEbConnection
    {
        public bool IsDef { get; set; } //for distinguish between our server and a custom MongoDB server 

        [JsonConverter(typeof(CustomBase64Converter))]
        public string FilesDB_url { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.EbFILES; } }
    }

    public class EbLogsDbConnection : EbBaseDbConnection
    {
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
}
