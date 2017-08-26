using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Objects.Attributes
{
    public enum PropertyEditorType
    {
        Boolean,
        DropDown,
        Number,
        Color,
        Label,
        Text,
        Collection,
        Columns,
    }

    public class HideInToolBox : Attribute { }

    public class HideInPropertyGrid : Attribute { }

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, Inherited = false)]
    public class EnableInBuilder : Attribute
    {
        public BuilderType[] BuilderTypes { get; set; }

        public EnableInBuilder(params BuilderType[] types)
        {
            this.BuilderTypes = types;
        }
    }

    public class Alias : Attribute
    {
        public string Name { get; set; }

        public Alias(string alias)
        {
            this.Name = alias;
        }
    }

    public class PropertyEditor : Attribute
    {
        public PropertyEditorType PropertyEditorType { get; set; }

        public PropertyEditor(PropertyEditorType type)
        {
            this.PropertyEditorType = type;
        }
    }
    public class PropertyGroup : Attribute
    {
        public string Name { get; set; }

        public PropertyGroup(string groupName)
        {
            this.Name = groupName;
        }
    }

    public class HelpText : Attribute
    {
        public string value { get; set; }

        public HelpText(string value)
        {
            this.value = value;
        }
    }

    public class UIproperty : Attribute
    {
        public UIproperty() { }
    }
}
