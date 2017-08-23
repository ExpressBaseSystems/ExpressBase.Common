using ExpressBase.Common.Objects.Attributes;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Objects
{
    public class Meta
    {
        public string name { get; set; }

        public string group { get; set; }

        public PropertyEditorType editor { get; set; }

        public string[] options { get; set; }

        public bool IsUIproperty { get; set; }

        public string helpText { get; set; }
    }
}
