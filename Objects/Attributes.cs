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
        ObjectSelector = 13,
        FontSelector = 14,
        Expandable = 15,
        String = 16,
        ImageSeletor = 17,
        //ScriptEditorCS = 18,//=========
        //ScriptEditorJS = 19,
        //ScriptEditorSQ = 20,
        MultiLanguageKeySelector = 21,
        CollectionPropsFrmSrc = 22,
        DictionaryEditor = 23,
        CollectionProp = 24,
        DDfromDictProp = 25,
        CollectionABCpropToggle = 26,
        ScriptEditorJS = 64,
        ScriptEditorCS = 128,
        ScriptEditorSQ = 256
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

    [AttributeUsage(AttributeTargets.All, Inherited = false)]
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
        public int PropertyEditorType { get; set; }

        public string PropertyEditorSource { get; set; }

        public string DependantProp { get; set; }

        public string DependantProp2 { get; set; }

        public int Limit { get; set; }

        public PropertyEditor(PropertyEditorType type1)
        {
            this.PropertyEditorType = (int)type1;
        }

        public PropertyEditor(PropertyEditorType type1, PropertyEditorType type2)
        {
            this.PropertyEditorType = (int)type1 + (int)type2;
        }

        public PropertyEditor(PropertyEditorType type1, PropertyEditorType type2, PropertyEditorType type3)
        {
            this.PropertyEditorType = (int)type1 + (int)type2 + (int)type3;
        }

        public PropertyEditor(PropertyEditorType type, string source):this(type)
        {
            //this.PropertyEditorType = (int)type;
            this.PropertyEditorSource = source;
        }

        public PropertyEditor(PropertyEditorType type, string source, int limit):this(type, source)
        {
            //this.PropertyEditorType = (int)type;
            //this.PropertyEditorSource = source;
            this.Limit = limit;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop):this(type ,source)
        {
            //this.PropertyEditorType = (int)type;
            //this.PropertyEditorSource = source;
            this.DependantProp = Dprop;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop, string Dprop2):this(type,source, Dprop)
        {
        //    this.PropertyEditorType = (int)type;
        //    this.PropertyEditorSource = source;
        //    this.DependantProp = Dprop;
            this.DependantProp2 = Dprop2;
        }
    }

    public class PropertyGroup : Attribute
    {
        public string Name { get; set; }

        public PropertyGroup(string groupName) { this.Name = groupName; }
    }

    public class ListType : Attribute
    {
        public Type TypeOfList { get; set; }

        public ListType(Type typeName) { this.TypeOfList = typeName; }
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
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-inp]').css('background-color',props.BackColor);";

        public const string FORECOLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-inp]').css('color',props.ForeColor);";

        public const string LABEL = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]').text(props.Label);";

        public const string LABEL_COLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]').css('color',props.LabelForeColor);";

        public const string LABEL_BACKCOLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]').css('background-color',props.LabelBackColor);";

        public const string HELP_TEXT = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-helptxt]').text(props.HelpText);";

        public static string getFunctions()
        {
            string jsonStr = "EbOnChangeUIfns.Common = {";
            Type type = typeof(OnChangeUIfns);
            FieldInfo[] props = type.GetFields();
            foreach (var prop in props)
            {
                var fun = prop.GetValue(null);
                fun = @"function(elementId, props){
                        @functionStr
                    }".Replace("@functionStr", fun.ToString());

                jsonStr += "'" + prop.Name + "':" + fun + ", ";
            }
            return jsonStr + "}";
        }
    }
}