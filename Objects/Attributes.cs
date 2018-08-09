using ExpressBase.Common.Structures;
using System;
using System.Reflection;

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
        String = 16,
        ImageSeletor = 17,
        ScriptEditorCS = 18,
        ScriptEditorJS = 19,
        ScriptEditorSQ = 20,
        MultiLanguageKeySelector = 21,
        CollectionPropsFrmSrc = 22,
        DictionaryEditor = 23,
        CollectionProp = 24,
        DDfromDictProp = 25,
        CollectionABCpropToggle = 26,
    }

    public class HideInToolBox : Attribute { }

    public class UsedWithTopObjectParent : Attribute
    {

        public Type TopObjectParentType { get; set; }

        public UsedWithTopObjectParent(Type _TopObjectParentType)
        {
            TopObjectParentType = _TopObjectParentType;
        }
    }

    public class HideInPropertyGrid : Attribute { }

    public class InputMask : Attribute
    {
        public string MaskPattern { get; set; }

        public InputMask(string pattern)
        {
            MaskPattern = pattern;
        }
    }

    public class regexCheck : Attribute
    {
        string regex { set; get; }

        public regexCheck()
        {
            this.regex = "[a-z][a-z0-9]*(_[a-z0-9]+)*";
        }

        public regexCheck(string regex)
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

    [AttributeUsage(AttributeTargets.Property, Inherited = false, AllowMultiple = true)]
    public class OSE_ObjectTypes : Attribute
    {
        public int[] ObjectTypes { get; set; }

        public OSE_ObjectTypes(params int[] objectTypes) { this.ObjectTypes = objectTypes; }
    }


    public class HideForUser : Attribute
    {
    }


    public class OnChangeExec : Attribute
    {
        public string JsCode { get; set; }

        public OnChangeExec(string jsCode) { this.JsCode = jsCode; }
    }

    public class CEOnSelectFn : Attribute
    {
        public string JsCode { get; set; }

        public CEOnSelectFn(string jsCode) { this.JsCode = jsCode; }
    }

    public class CEOnDeselectFn : Attribute
    {
        public string JsCode { get; set; }

        public CEOnDeselectFn(string jsCode) { this.JsCode = jsCode; }
    }

    public class PropertyEditor : Attribute
    {
        public PropertyEditorType PropertyEditorType { get; set; }

        public string PropertyEditorSource { get; set; }

        public string DependantProp { get; set; }

        public string DependantProp2 { get; set; }

        public int Limit { get; set; }

        public PropertyEditor(PropertyEditorType type) { this.PropertyEditorType = type; }

        public PropertyEditor(PropertyEditorType type, string source)
        {
            this.PropertyEditorType = type;
            this.PropertyEditorSource = source;
        }

        public PropertyEditor(PropertyEditorType type, string source, int limit)
        {
            this.PropertyEditorType = type;
            this.PropertyEditorSource = source;
            this.Limit = limit;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop)
        {
            this.PropertyEditorType = type;
            this.PropertyEditorSource = source;
            this.DependantProp = Dprop;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop, string Dprop2)
        {
            this.PropertyEditorType = type;
            this.PropertyEditorSource = source;
            this.DependantProp = Dprop;
            this.DependantProp2 = Dprop2;
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
    public class MetaOnly : Attribute { public MetaOnly() { } }

    public class UIproperty : Attribute { public UIproperty() { } }

    public class EbRequired : Attribute { public EbRequired() { } }

    public class OnChangeUIFunction : Attribute
    {
        public string FunctionName { get; set; }

        public OnChangeUIFunction(string funName)
        {
            FunctionName = funName;
        }
    }

    public static class OnChangeUIfns
    {
        public const string BACKCOLOR = @"
                $('#' + elementId + ' [ui-inp]').css('background-color',props.BackColor);";

        public const string FORECOLOR = @"
                $('#' + elementId + ' [ui-inp]').css('background-color',props.ForeColor);";

        public const string LABEL= @"
                $('#' + elementId + ' [ui-label]').text(props.Label);";

        public const string LABEL_COLOR = @"
                $('#' + elementId + ' [ui-label]').css('color',props.LabelForeColor);";

        public const string LABEL_BACKCOLOR = @"
                $('#' + elementId + ' [ui-label]').css('background-color',props.LabelBackColor);";

        public const string HELP_TEXT= @"
                $('#' + elementId + ' [ui-helptxt]').text(props.HelpText);";

        public static  string getFunctions()
        {
            string jsonStr = "EbOnChangeUIfns.Common = {";
            Type type = typeof(OnChangeUIfns);
            FieldInfo[] props = type.GetFields();
            foreach (var prop in props)
            {
                var fun = prop.GetValue(null);
                fun = @"function(elementId, props){
                        console.log(elementId);
                        console.log(props);
                        @functionStr
                    }".Replace("@functionStr", fun.ToString());

                jsonStr += "'" + prop.Name + "':" +  fun + ", ";
            }
            return jsonStr + "}";
        }
    }
}