using ExpressBase.Common.Objects.Attributes;
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

        public Dictionary<int, string> enumoptions { get; set; }

        public List<Meta> submeta { get; set; }

        public bool IsUIproperty { get; set; }

        public bool IsUnique { get; set; }

        public string helpText { get; set; }

        [JsonConverter(typeof(FunctionSerializer))]
        public string OnChangeExec { get; set; }

        [JsonConverter(typeof(FunctionSerializer))]
        public string CEOnSelectFn { get; set; }

        [JsonConverter(typeof(FunctionSerializer))]
        public string CEOnDeselectFn { get; set; }

        public bool IsRequired { get; set; }

        public string source { get; set; }

        public string Dprop { get; set; }

        public string Dprop2 { get; set; }

        public string MaskPattern { get; set; }

        public string regexCheck { get; set; }

        public bool HideForUser { get; set; }

        public bool MetaOnly { get; set; }

        public int Limit { get; set; }
        
        public string UIChangefn { get; set; }

        public Meta()
        {
            this.enumoptions = new Dictionary<int, string>();
        }
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
