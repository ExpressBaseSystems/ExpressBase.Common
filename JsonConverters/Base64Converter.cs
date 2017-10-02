using ExpressBase.Common.Extensions;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;
using System.Web;

namespace ExpressBase.Common.JsonConverters
{
    public class Base64Converter : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return (objectType == typeof(string));
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            if (reader.Value != null)
                return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(reader.Value.ToString()));
            else
                return null;
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            string valueAsString = (value != null) ? Convert.ToString(value) : string.Empty;

            if (!string.IsNullOrWhiteSpace(valueAsString))
                writer.WriteValue(valueAsString.ToBase64());
        }
    }
}
