using ExpressBase.Common.Objects;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Objects
{
    public class Script
    {
        public string Code { get; set; }

        public ScriptingLanguage Lang{ get; set; }
    }
}
