using ExpressBase.Common.Data;
using ExpressBase.Common.Structures;
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

        public bool IsDefault { get; set; }

        public string NickName { get; set; }

        public virtual void Persist(string TenantAccountId, EbConnectionFactory infra, bool IsNew, int UserId)
        {
            if (IsNew)
            {
                string sql = "INSERT INTO eb_connections (con_type, solution_id, nick_name, con_obj,date_created,eb_user_id) VALUES (@con_type, @solution_id, @nick_name, @con_obj , NOW() , @eb_user_id) RETURNING id";
                DbParameter[] parameters = { infra.DataDB.GetNewParameter("con_type", EbDbTypes.String, EbConnectionType),
                                    infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, TenantAccountId),
                                    infra.DataDB.GetNewParameter("nick_name", EbDbTypes.String, !(string.IsNullOrEmpty(NickName))?NickName:string.Empty),
                                    infra.DataDB.GetNewParameter("con_obj", EbDbTypes.Json,EbSerializers.Json_Serialize(this) ),
                                    infra.DataDB.GetNewParameter("eb_user_id", EbDbTypes.Int32, UserId ) };
                var iCount = infra.DataDB.DoQuery(sql, parameters);
            }

            else if (!IsNew)
            {
                string sql = @"UPDATE eb_connections SET eb_del = 'T' WHERE con_type = @con_type AND solution_id = @solution_id; 
                                      INSERT INTO eb_connections (con_type, solution_id, nick_name, con_obj, date_created, eb_user_id) VALUES (@con_type, @solution_id, @nick_name, @con_obj, NOW() , @eb_user_id)";
                DbParameter[] parameters = { infra.DataDB.GetNewParameter("con_type", EbDbTypes.String, EbConnectionType),
                                    infra.DataDB.GetNewParameter("solution_id", EbDbTypes.String, TenantAccountId),
                                    infra.DataDB.GetNewParameter("nick_name", EbDbTypes.String, !(string.IsNullOrEmpty(NickName))?NickName:string.Empty),
                                    infra.DataDB.GetNewParameter("con_obj", EbDbTypes.Json,EbSerializers.Json_Serialize(this)),
                                      infra.DataDB.GetNewParameter("eb_user_id", EbDbTypes.Int32, UserId )};
                var iCount = infra.DataDB.DoNonQuery(sql, parameters);
            }
        }

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
