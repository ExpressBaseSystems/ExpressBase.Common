using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public abstract class EbBaseDbConnection
    {
        public string DatabaseName { get; set; }

        public string Server { get; set; }

        public int Port { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public int Timeout { get; set; }
    }

    public class EbObjectsDbConnection: EbBaseDbConnection
    {
        public DatabaseVendors DatabaseVendor { get; set; }
    }

    // For Infra T-Data, Tenant T-Data
    public class EbDataDbConnection: EbBaseDbConnection
    {
        public DatabaseVendors DatabaseVendor { get; set; }
    }

    // For Infra Files, Tenant Files
    public class EbFilesDbConnection
    {
        [JsonConverter(typeof(CustomBase64Converter))]
        public string MongoDB_url { get; set; }
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
