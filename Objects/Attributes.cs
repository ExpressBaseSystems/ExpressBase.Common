using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Objects.Attributes
{
    public enum PropertyEditorType
    {
        Boolean = 0,
        DropDown = 1,
        Number = 2,
        Color = 3,//--
        Label = 4,//--
        Text = 5,//--
        DateTime = 6,//--
        Collection = 7,
        CollectionFrmSrc = 8,
        CollectionFrmSrcPG = 9,
        CollectionA2C = 10,
        JS = 11,
        SQL = 12,//not completed
        ObjectSelector = 13,//--
        FontSelector = 14,//--  //not completed
        Expandable = 15,
        String =16,
        ImageSeletor = 17
    }

    public class HideInToolBox : Attribute { }

    public class HideInPropertyGrid : Attribute { }

    public class regexCheck : Attribute {
        string regex { set; get; }

        public regexCheck()
        {
            this.regex = "[a-z][a-z0-9]*(_[a-z0-9]+)*";
        }

        public regexCheck( string regex)
        {
            this.regex = regex;
        }
    }
    

    public class Unique : Attribute { }

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, Inherited = false)]
    public class EnableInBuilder : Attribute
    {
        public BuilderType[] BuilderTypes { get; set; }

        public EnableInBuilder(params BuilderType[] types) { this.BuilderTypes = types; }
    }

    public class Alias : Attribute
    {
        public string Name { get; set; }

        public Alias(string alias) { this.Name = alias; }
    }

    public class OSE_ObjectTypes : Attribute
    {
        public EbObjectType[] ObjectTypes { get; set; }

        public OSE_ObjectTypes(params EbObjectType[] objectTypes) { this.ObjectTypes = objectTypes; }
    }


    public class OnChangeExec : Attribute
    {
        public string JsCode { get; set; }

        public OnChangeExec(string jsCode) { this.JsCode = jsCode; }
    }

    public class PropertyEditor : Attribute
    {
        public PropertyEditorType PropertyEditorType { get; set; }

        public string PropertyEditorSource{ get; set; }

        public PropertyEditor(PropertyEditorType type) { this.PropertyEditorType = type; }

        public PropertyEditor(PropertyEditorType type, string source)
        {
            this.PropertyEditorType = type;
            this.PropertyEditorSource = source;
        }
    }
    public class PropertyGroup : Attribute
    {
        public string Name { get; set; }

        public PropertyGroup(string groupName) { this.Name = groupName; }
    }

    public class DefaultPropValue : Attribute
    {
        public string Value { get; set; }

        public DefaultPropValue(string val) { this.Value = val; }
    }

    public class HelpText : Attribute 
    {
        public string value { get; set; }

        public HelpText(string value) { this.value = value; }
    }

    public class UIproperty : Attribute { public UIproperty() { } }

    public class EbRequired : Attribute { public EbRequired() { } }
}
