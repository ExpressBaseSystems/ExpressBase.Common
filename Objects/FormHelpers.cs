using ExpressBase.Common.JsonConverters;
using ExpressBase.Common.Objects;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Objects
{
    public class EbScript
    {
        [JsonConverter(typeof(Base64Converter))]
        public string Code { get; set; }

        public ScriptingLanguage Lang { get; set; }
    }
}
