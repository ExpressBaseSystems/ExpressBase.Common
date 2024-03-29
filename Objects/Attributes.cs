﻿using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
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
        Collection = 7,// collection editor -  add object, delete object, change props of the object ( B - C)
        CollectionFrmSrc = 8,// collection editor -  takes objects from another property value ( A - B)
        CollectionFrmSrcPG = 9,// collection editor -
        CollectionA2C = 10,// collection editor -
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
        CollectionPropsFrmSrc = 22,// collection editor -
        DictionaryEditor = 23,
        CollectionProp = 24,// collection editor - toggles a property (A - B - C)
        DDfromDictProp = 25,
        CollectionABCpropToggle = 26,// collection editor - toggles a property, disable a prop (A - B - C)(if the property value is true it come)
        CollectionABCFrmSrc = 27,// collection editor
        Mapper = 35,// 
        ObjectSelectorCollection = 36,// 
        IconPicker = 37,// 
        ShadowEditor = 38,// 
        ColorPicker = 39,// 
        GradientColorPicker = 40,// 
        String64 = 41,// 
        FileUploader = 42,// 
        PivotConfiguration = 43,// 
        ScriptEditorJS = 64,
        ScriptEditorCS = 128,
        ScriptEditorSQ = 256
    }

    public enum SurveyRoles
    {
        QuestionControl,
        AnswerControl
    }

    public class HideInToolBox : Attribute { }
    public class ShowInToolBox : Attribute { }

    public class UsedWithTopObjectParent : Attribute
    {
        public Type[] TopObjectParentTypes { get; set; }

        public UsedWithTopObjectParent(params Type[] _TopObjectParentTypes)
        {
            TopObjectParentTypes = _TopObjectParentTypes;
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

    public class ReservedValues : Attribute
    {
        public string[] Values { get; set; }

        public ReservedValues(params string[] values)
        {
            Values = values;
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

    [AttributeUsage(AttributeTargets.Class | AttributeTargets.Property, Inherited = true)]
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

    public class BuilderTypeEnum : Attribute
    {
        public BuilderType Type { get; set; }

        public BuilderTypeEnum(BuilderType Type) { this.Type = Type; }
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
        public bool BooleanOption { get; set; }
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

        public PropertyEditor(PropertyEditorType type, bool boolOpt) : this(type)
        {
            this.BooleanOption = boolOpt;
        }

        public PropertyEditor(PropertyEditorType type, string source) : this(type)
        {
            this.PropertyEditorSource = source;
        }

        public PropertyEditor(PropertyEditorType type, string source, bool ShouldRefreshOnInit) : this(type)
        {
            this.PropertyEditorSource = source;
            this.BooleanOption = ShouldRefreshOnInit;
        }

        public PropertyEditor(PropertyEditorType type, string source, int limit) : this(type, source)
        {
            this.Limit = limit;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop) : this(type, source)
        {
            this.DependantProp = Dprop;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop, bool ShouldRefreshOnInit) : this(type, source)
        {
            this.DependantProp = Dprop;
            this.BooleanOption = ShouldRefreshOnInit;
        }

        public PropertyEditor(PropertyEditorType type, string source, string Dprop, string Dprop2) : this(type, source, Dprop)
        {
            this.DependantProp2 = Dprop2;
        }

        public PropertyEditor(PropertyEditorType type1, int limit) : this(type1)
        {
            this.Limit = limit;
        }
    }

    public class PropertyGroup : Attribute
    {
        public string Name { get; set; }

        public PropertyGroup(string groupName) { this.Name = groupName; }
    }

    public class PropertyPriority : Attribute
    {
        public int Priority { get; set; }

        public PropertyPriority(int Priority) { this.Priority = Priority; }
    }

    public class ListType : Attribute
    {
        public Type TypeOfList { get; set; }

        public ListType(Type typeName) { this.TypeOfList = typeName; }
    }

    public class DefaultPropValue : Attribute
    {
        public dynamic Value { get; set; }
        public List<object> Values = new List<object>();
        //public Type ClassType { get; set; }

        public DefaultPropValue(object val, object val2, object val3, object val4)
        {
            try
            {
                this.Value = val;
                if (Value != null)
                    this.Values.Add(Value);
                if (val2 != null)
                    this.Values.Add(val2);
                if (val3 != null)
                    this.Values.Add(val3);
                if (val4 != null)
                    this.Values.Add(val4);
            }
            catch (Exception ee)
            {
                throw ee;
            }
        }

        public DefaultPropValue(object val)
        {
            //this.ClassType = ClassType;
            this.Value = val;
        }
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

    public class PropDataSourceJsFn : Attribute
    {
        public string JsCode { get; set; }

        public PropDataSourceJsFn(string jsCode)
        {
            JsCode = jsCode;
        }
    }

    public class SurveyBuilderRoles : Attribute
    {
        public SurveyRoles[] Roles { get; set; }

        public SurveyBuilderRoles(params SurveyRoles[] _surveyRoles)
        {
            Roles = _surveyRoles;
        }
    }

    public static class OnChangeUIfns
    {
        public const string BACKCOLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-inp]').css('background-color',props.BackColor);";

        public const string FORECOLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-inp]').css('color',props.ForeColor);";

        public const string LABEL_STYLE = @"setFontCss(props.LabelFontStyle, $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]'));";

        public const string LABEL = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]').text(props.Label);";

        public const string LABEL_COLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]').css('color',props.LabelForeColor);";

        public const string BORDER = @"
                if(props.HideBorder)
                    $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('.gb-border').css('border','none');
                else
                    $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('.gb-border').css('border','dashed 1px rgba(0, 0, 0, 0.12)');";

        public const string CONTROL_ICON = @"
                if(!props.HideInputIcon)
                    $(`#cont_${elementId}.Eb-ctrlContainer .ctrl-cover`).closestInner('.input-group-addon').show();
                else
                    $(`#cont_${elementId}.Eb-ctrlContainer .ctrl-cover`).closestInner('.input-group-addon').hide();";

        public const string LABEL_BACKCOLOR = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-label]').css('background-color',props.LabelBackColor);";

        public const string HELP_TEXT = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-helptxt]').text(props.HelpText);";

        public const string MARGIN = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).css('margin', `${props.Margin.Top}px ${props.Margin.Right}px ${props.Margin.Bottom}px ${props.Margin.Left}px`);";

        public const string ROOT_OBJ_PADDING = @"
                $(`#${elementId}`).css('padding', `${props.Padding.Top}px ${props.Padding.Right}px ${props.Padding.Bottom}px ${props.Padding.Left}px`);";

        public const string PADDING = @"
                $(`#cont_${elementId}.Eb-ctrlContainer`).css('padding', `${props.Padding.Top}px ${props.Padding.Right}px ${props.Padding.Bottom}px ${props.Padding.Left}px`);";

        public const string INP_PADDING = @"
                if(props.Padding) $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-inp]').css('padding', `${props.Padding.Top}px ${props.Padding.Right}px ${props.Padding.Bottom}px ${props.Padding.Left}px`);";
        public const string SS_PADDING = @"
if(props.Padding) {
    $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('.btn').css('padding', `${props.Padding.Top}px ${props.Padding.Right}px ${props.Padding.Bottom}px ${props.Padding.Left}px`).css('height', (parseInt(props.Padding.Top) + parseInt(props.Padding.Bottom) + 20) + 'px');
}";
        public const string PS_PADDING = @"
if(props.Padding) {
    $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('.ctrl-cover').css('height', (parseInt(props.Padding.Top) + parseInt(props.Padding.Bottom) + 20) + 'px');
}";
        public const string AUTO_ID_PADDING = @"
if(props.Padding) {
    $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('.ctrl-cover input').css('padding', `${props.Padding.Top}px ${props.Padding.Right}px ${props.Padding.Bottom}px ${props.Padding.Left}px`);
}";
        public const string INP_FONT_STYLE = @"setFontCss(props.FontStyle, $(`#cont_${elementId}.Eb-ctrlContainer`).closestInner('[ui-inp]'));";

        public const string RENDER_INLINE = @"$(`#cont_${elementId}.Eb-ctrlContainer .list-ctrl-box`).css('flex-direction',(props.RenderInline ? 'row' : 'column'));";

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