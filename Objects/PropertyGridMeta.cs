﻿using ExpressBase.Common.Objects.Attributes;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Objects
{
    public class Meta
    {
        public string name { get; set; }

        public string alias { get; set; }

        public string group { get; set; }

        public PropertyEditorType editor { get; set; }

        public string[] options { get; set; }

        public bool IsUIproperty { get; set; }

        public string helpText { get; set; }

        [JsonConverter(typeof(FunctionSerializer))]
        public string OnChangeExec { get; set; }
    }

    public class FunctionSerializer : JsonConverter
    {
        public override bool CanConvert(Type objectType)
        {
            return (objectType == typeof(string));
        }

        public override object ReadJson(JsonReader reader, Type objectType, object existingValue, JsonSerializer serializer)
        {
            throw new NotImplementedException();
        }

        public override void WriteJson(JsonWriter writer, object value, JsonSerializer serializer)
        {
            string valueAsString = Convert.ToString(value);

            if (!string.IsNullOrWhiteSpace(valueAsString))
                writer.WriteRawValue(valueAsString);
        }
    }
}