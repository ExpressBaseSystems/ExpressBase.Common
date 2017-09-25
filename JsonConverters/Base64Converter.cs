using ExpressBase.Common.Extensions;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

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
            return System.Text.Encoding.UTF8.GetString(Convert.FromBase64String(reader.Value.ToString()));
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            string valueAsString = Convert.ToString(value);

            if (!string.IsNullOrWhiteSpace(valueAsString))
                writer.WriteValue(valueAsString.ToBase64());
        }
    }
}
