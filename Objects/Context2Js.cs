﻿using ExpressBase.Common.Extensions;
using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Common.Structures;
using ExpressBase.Objects;
using Newtonsoft.Json;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using Newtonsoft.Json.Serialization;

namespace ExpressBase.Common.Objects
{
    public class Context2Js
    {
        private BuilderType BuilderType { get; set; }
        private Type[] TypeArray { get; set; }
        private Type TypeOfTopEbObjectParent { get; set; }
        private Type TypeOfTopEbObjectParent2 { get; set; }

        private DateTime? start { get; set; }
        private DateTime? end { get; set; }
        public int MilliSeconds { get; private set; }

        public string AllMetas { get; private set; }
        public string EbEnums { get; private set; }
        public string CtrlCounters { get; private set; }
        public string JsObjects { get; private set; }

        public string ToolsHtml { get; private set; }

        public string TypeRegister { get; private set; }
        public string JsonToJsObjectFuncs { get; private set; }
        public string EbObjectTypes { get; private set; }
        public string EbOnChangeUIfns { get; private set; }
        private DateTime Start { get; set; }
        private DateTime End { get; set; }

        public void Init(Type[] _typeArray, BuilderType _builderType)
        {
            this.BuilderType = _builderType;
            this.TypeArray = _typeArray;
            this.TypeOfTopEbObjectParent2 = null;

            this.AllMetas = string.Empty;
            this.EbEnums = string.Empty;
            this.CtrlCounters = string.Empty;
            this.JsObjects = string.Empty;
            this.ToolsHtml = string.Empty;
            this.TypeRegister = string.Empty;
            this.JsonToJsObjectFuncs = string.Empty;
            this.EbObjectTypes = string.Empty;
            this.EbOnChangeUIfns = "var EbOnChangeUIfns ={}; ";

            this.Start = DateTime.Now;
        }

        public Context2Js(Type[] _typeArray, BuilderType _builderType, Type topObjectParentType)
        {
            this.Init(_typeArray, _builderType);
            this.TypeOfTopEbObjectParent = topObjectParentType;
            this.GenerateJs();
            this.End = DateTime.Now;
            this.EbOnChangeUIfns += OnChangeUIfns.getFunctions();

            this.MilliSeconds = (this.End - this.Start).Milliseconds;
        }
        public Context2Js(Type[] _typeArray, BuilderType _builderType, Type topObjectParentType, Type topObjectParentType2)
        {
            this.Init(_typeArray, _builderType);
            this.TypeOfTopEbObjectParent = topObjectParentType;
            this.TypeOfTopEbObjectParent2 = topObjectParentType2;
            this.GenerateJs();
            this.End = DateTime.Now;

            this.MilliSeconds = (this.End - this.Start).Milliseconds;
        }

        public Context2Js()
        {
        }

        ~Context2Js()
        {
            this.start = null;
            this.end = null;

            this.TypeArray = null;
            this.TypeOfTopEbObjectParent = null;
            this.TypeOfTopEbObjectParent2 = null;

            this.AllMetas = null;
            this.JsObjects = null;
            this.ToolsHtml = null;
            this.TypeRegister = null;
            this.JsonToJsObjectFuncs = null;
            this.EbObjectTypes = null;
            this.EbOnChangeUIfns = null;
        }

        private void GenerateJs()
        {
            //string RootObjName = this.TypeOfTopEbObjectParent.Name;
            //this.AllMetas = "AllMetasRoot['" + RootObjName  + "'] = {";
            this.AllMetas = "var AllMetas = {";
            this.EbEnums = "var EbEnums = {";
            this.CtrlCounters = "var CtrlCounters = {";
            this.JsObjects = "var EbObjects = {};";

            this.JsonToJsObjectFuncs = @"
function Proc(jsonObj, rootContainerObj) {
    $.extend(rootContainerObj, jsonObj);
    rootContainerObj.Controls = new EbControlCollection(jsonObj.Controls);
    ProcRecur(jsonObj.Controls, rootContainerObj.Controls);
};

function ProcRecur(src_controls, dest_controls) {
    $.each(src_controls.$values, function (i, control) {
        if (i ===0)
            dest_controls.$values=[];
        var newObj = ObjectFactory(control);
        dest_controls.$values.push(newObj);
        if (control.IsContainer){
            newObj.Controls.$values=[];
            ProcRecur(control.Controls, newObj.Controls);
        }
    });
};";
            this.TypeRegister = "function ObjectFactory(jsonObj) { ";

            this.ToolsHtml = this.GetToolBoxHtml();

            this.AllMetas += string.Concat("};", this.EbEnums, "};", this.CtrlCounters + "};");
            this.TypeRegister += " };";
            this.EbObjectTypes = string.Concat("var EbObjectTypes = ", Get_EbObjTypesStr());
        }

        private string GetToolBoxHtml()
        {
            string _ToolsHtml = string.Empty;
            string _controlsHtml = string.Empty;
            string _containerControlsHtml = string.Empty;
            string _specialContainerControlHtml = string.Empty;
            string _placeHolderControlsHtml = string.Empty;
            string _componentsHtml = string.Empty;

            foreach (Type tool in this.TypeArray)
            {
                if (tool.GetTypeInfo().IsSubclassOf(this.TypeOfTopEbObjectParent) ||
                    (tool.GetTypeInfo().IsDefined(typeof(UsedWithTopObjectParent)) &&
                        (tool.GetCustomAttribute<UsedWithTopObjectParent>().TopObjectParentTypes.Contains(this.TypeOfTopEbObjectParent))) ||
                    ((this.TypeOfTopEbObjectParent2 != null) ? tool.GetTypeInfo().IsSubclassOf(this.TypeOfTopEbObjectParent2) : false))
                {
                    if (!tool.IsAbstract)
                    {
                        try
                        {
                            TypeInfo _typeInfo = tool.GetTypeInfo();
                            EnableInBuilder _enableInBuider = _typeInfo.GetCustomAttribute<EnableInBuilder>();

                            if (_enableInBuider != null && _enableInBuider.BuilderTypes.Contains(this.BuilderType))
                            {
                                object toolObj = Activator.CreateInstance(tool);

                                if (toolObj is EbControl &&
                                    (!_typeInfo.IsDefined(typeof(HideInToolBox)) || _typeInfo.IsDefined(typeof(ShowInToolBox)))) // ShowInToolBox should override HideInToolBox( in a case where HideInToolBox inherit from parent class)
                                {
                                    EbControl ControlObj = toolObj as EbControl;

                                    if (toolObj is IEbPlaceHolderControl)
                                    {
                                        _placeHolderControlsHtml += ControlObj.GetToolHtml();
                                    }
                                    else if (toolObj is IEbSpecialContainer)
                                    {
                                        _specialContainerControlHtml += ControlObj.GetToolHtml();
                                    }
                                    else if (toolObj is IEbComponent)
                                    {
                                        _componentsHtml += ControlObj.GetToolHtml();
                                    }
                                    else if (toolObj is EbControlContainer)
                                    {
                                        _containerControlsHtml += ControlObj.GetToolHtml();
                                    }
                                    else
                                        _controlsHtml += ControlObj.GetToolHtml();
                                }
                                //ToolBoxHtml += this.GetToolHtml(tool.Name.Substring(2));
                                this.TypeRegister += string.Format(@"
                                    if (jsonObj['$type'].includes('{0}')) 
                                        return new EbObjects.{1}(jsonObj.EbSid, jsonObj); ", toolObj.GetType().FullName, toolObj.GetType().Name);
                                this.GetJsObject(toolObj);
                                if (toolObj is EbControl)
                                    this.EbOnChangeUIfns += String.IsNullOrEmpty((toolObj as EbControl).UIchangeFns) ? string.Empty : ("EbOnChangeUIfns." + (toolObj as EbControl).UIchangeFns + ";");
                            }
                        }
                        catch (Exception ee)
                        {
                            Console.WriteLine("Exception: " + ee.ToString());
                            throw new Exception(ee.Message);
                        }
                    }
                }
            }
            if (!_controlsHtml.IsEmpty())
                _ToolsHtml += HtmlConstants.TOOL_HTML.Replace("@id@", "toolb_basic_ctrls").Replace("@label@", "Basic Controls") + _controlsHtml + "</div>";
            if (!_containerControlsHtml.IsEmpty())
                _ToolsHtml += HtmlConstants.TOOL_HTML.Replace("@id@", "toolb_cont_ctrls").Replace("@label@", "Layout Controls") + _containerControlsHtml + "</div>";
            if (!_specialContainerControlHtml.IsEmpty())
                _ToolsHtml += HtmlConstants.TOOL_HTML.Replace("@id@", "toolb_sp_cont_ctrls").Replace("@label@", "Advanced Controls") + _specialContainerControlHtml + "</div>";
            if (!_placeHolderControlsHtml.IsEmpty())
                _ToolsHtml += HtmlConstants.TOOL_HTML.Replace("@id@", "toolb_ph_cont_ctrls").Replace("@label@", "Platform Controls") + _placeHolderControlsHtml + "</div>";
            if (!_componentsHtml.IsEmpty())
                _ToolsHtml += HtmlConstants.TOOL_HTML.Replace("@id@", "toolb_ph_cont_ctrls").Replace("@label@", "Components") + _componentsHtml + "</div>";


            //_ToolsHtml = _controlsHtml + "</div>" + _containerControlsHtml + "</div>" + _specialContainerControlHtml + "</div>" + _placeHolderControlsHtml + "</div>";
            return _ToolsHtml;
        }

        private string GetToolHtml(string tool_name)
        {
            return @"<div eb-type='@toolName' class='tool'>@toolName</div>".Replace("@toolName", tool_name);
        }

        private void GetJsObject(object obj)
        {
            this.CtrlCounters += obj.GetType().GetTypeInfo().Name.Substring(2) + "Counter : 0,";
            string _props = string.Empty;

            PropertyInfo[] props = obj.GetType().GetAllProperties();

            //if (obj is EbControlContainer)
            //    _props += @"this.IsContainer = true;";

            foreach (PropertyInfo prop in props)
            {
                IEnumerable<Attribute> propattrs = prop.GetCustomAttributes();////////////////

                if (prop.IsDefined(typeof(EnableInBuilder), false)
                             && prop.GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(this.BuilderType))
                {
                    _props += JsVarDecl(prop, obj);
                }
            }


            this.AllMetas += @"
'@Name'  : @MetaCollection,"
.Replace("@Name", obj.GetType().Name)
.Replace("@MetaCollection", JsonConvert.SerializeObject(this.GetMetaCollection(obj)));
            try
            {
                EbObject EbO_obj = (obj as EbObject);
                bool isEbObject = obj is EbObject;
                EbControl sampOBJ = (obj as EbControl);
                string AssemblyQname = obj.GetType().AssemblyQualifiedName;

                this.JsObjects += @"
EbObjects.@Name = function @Name(id, jsonObj) {
    this.$type = '@Type';
    this.EbSid = id;
    @Props
    this.EbSid_CtxId = id;
    @InitFunc
    @4botHtml
    this.$Control = $( @html.replace(/@id/g, this.EbSid) );
    this.BareControlHtml = `@bareHtml`.replace(/@id/g, this.EbSid);
	this.DesignHtml = @html;
    var MyName = this.constructor.name;
    this.RenderMe = function () { 
var NewHtml = this.$BareControl.outerHTML(), me = this, metas = AllMetas[MyName];
    $.each(metas, function (i, meta) { 
        var name = meta.name;
        if (meta.IsUIproperty){
            NewHtml = NewHtml.replace('@' + name + ' ', me[name]);
        }
    });
    if(!this.IsContainer)
        $('#' + id).html($(NewHtml).html());
};
    if (jsonObj){
        jsonObj.RenderMe  = this.RenderMe;
        jsonObj.Html  = this.Html;
        jsonObj.Init   = this.Init;
        $.extend(this, jsonObj);
        //_.mergeWith(
	       // {}, this, jsonObj,
        //  (a, b) => b === null ? a : undefined
        //)
        if(jsonObj.IsContainer)
            this.Controls  = new EbControlCollection( {} );
        //if(this.Init)
        //    jsonObj.Init(id);
    }
    else{
        if(this.Init)
            this.Init(id);
    }
};"
.Replace("@Name", obj.GetType().Name)
.Replace("@Type", AssemblyQname.Split(",")[0] + "," + AssemblyQname.Split(",")[1])
.Replace("@Props", _props)
.Replace("@InitFunc", isEbObject ? EbO_obj.GetJsInitFunc() : string.Empty)
.Replace("@html", isEbObject ? EbO_obj.GetDesignHtml() : "``")
.Replace("@4botHtml", (obj is EbControl) ? ("this.$WrapedCtrl4Bot = $(`" + (obj as EbControl).GetWrapedCtrlHtml4bot(ref sampOBJ) + "`);") : string.Empty)
.Replace("@bareHtml", isEbObject ? EbO_obj.GetBareHtml() : string.Empty);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.ToString());
            }
        }

        private string Get_EbObjTypesStr()
        {
            Dictionary<string, int> _dic = new Dictionary<string, int>();
            foreach (Structures.EbObjectType objectType in Structures.EbObjectTypes.Enumerator)
                _dic.Add(objectType.Name, objectType.IntCode);

            return EbSerializers.Json_Serialize(_dic);
        }

        private IEnumerable<Meta> GetMetaCollection(object obj)
        {
            PropertyInfo[] props = obj.GetType().GetAllProperties();
            foreach (PropertyInfo prop in props)
            {
                if (prop.IsDefined(typeof(EnableInBuilder), false) && prop.GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(this.BuilderType))
                {
                    if (!prop.IsDefined(typeof(HideInPropertyGrid)))
                        yield return GetMeta(obj, prop);
                }
            }
        }

        private Meta GetMeta(object obj, PropertyInfo prop)
        {
            string _name = prop.Name;
            if (prop.IsDefined(typeof(JsonPropertyAttribute)))
            {
                _name = prop.GetCustomAttribute<JsonPropertyAttribute>().PropertyName;
            }
            Meta meta = new Meta { name = _name };
            IEnumerable<Attribute> propattrs = prop.GetCustomAttributes();
            foreach (Attribute attr in propattrs)
            {
                if (attr is Alias)
                    meta.alias = (attr as Alias).Name;
                if (attr is PropertyPriority)
                    meta.Priority = (attr as PropertyPriority).Priority;
                else if (attr is PropertyGroup)
                    meta.group = (attr as PropertyGroup).Name;
                else if (attr is HelpText)
                    meta.helpText = (attr as HelpText).value;
                else if (attr is CEOnSelectFn)
                    meta.CEOnSelectFn = "function(Parent){" + (attr as CEOnSelectFn).JsCode + "}";
                else if (attr is CEOnDeselectFn)
                    meta.CEOnDeselectFn = "function(Parent){" + (attr as CEOnDeselectFn).JsCode + "}";
                else if (attr is OnChangeExec)
                    meta.OnChangeExec = "function(pg){" + (attr as OnChangeExec).JsCode + "}";
                else if (attr is PropDataSourceJsFn)
                    meta.PropDataSourceJsFn = "function(pg){" + (attr as PropDataSourceJsFn).JsCode + "}";
                else if (attr is OnChangeUIFunction)
                    meta.UIChangefn = (attr as OnChangeUIFunction).FunctionName;
                else if (attr is Attributes.EbRequired)
                    meta.IsRequired = true;
                else if (attr is UIproperty)
                    meta.IsUIproperty = true;
                else if (attr is Unique)
                    meta.IsUnique = true;
                else if (attr is HideForUser)
                    meta.HideForUser = true;
                else if (attr is MetaOnly)
                    meta.MetaOnly = true;
                else if (attr is InputMask)
                    meta.MaskPattern = (attr as InputMask).MaskPattern;
                if (attr is ReservedValues)
                    meta.Dprop = String.Join(", ", (attr as ReservedValues).Values);
                else if (attr is PropertyEditor)
                {
                    PropertyEditor PropertyEditorAttr = (attr as PropertyEditor);
                    meta.editor = PropertyEditorAttr.PropertyEditorType;
                    meta.source = PropertyEditorAttr.PropertyEditorSource;
                    meta.Limit = PropertyEditorAttr.Limit;
                    meta.Dprop = PropertyEditorAttr.DependantProp;
                    meta.Dprop2 = PropertyEditorAttr.DependantProp2;

                    if (PropertyEditorAttr.BooleanOption && (PropertyEditorAttr.PropertyEditorType == (int)PropertyEditorType.CollectionProp ||
                        PropertyEditorAttr.PropertyEditorType == (int)PropertyEditorType.CollectionABCpropToggle ||
                        PropertyEditorAttr.PropertyEditorType == (int)PropertyEditorType.CollectionABCFrmSrc))// collection editor - toggles a property, disable a prop (A - B - C)(if the property value is true it come))
                        meta.Dprop2 = PropertyEditorAttr.BooleanOption.ToString();

                    if (PropertyEditorAttr.PropertyEditorType == (int)PropertyEditorType.DropDown && PropertyEditorAttr.BooleanOption)
                        meta.Dprop = PropertyEditorAttr.BooleanOption.ToString();

                    if (prop.PropertyType.GetTypeInfo().IsEnum)
                    {
                        this.EbEnums += "'" + prop.PropertyType.GetTypeInfo().Name + "': {";
                        foreach (dynamic enumStr in Enum.GetValues(prop.PropertyType))
                        {
                            meta.enumoptions.Add((int)enumStr, enumStr.ToString());
                            this.EbEnums += "'" + enumStr.ToString() + "':" + "'" + (int)enumStr + "', ";
                        }
                        this.EbEnums += "}, ";
                    }
                    else if (meta.editor == (int)PropertyEditorType.ObjectSelector)
                    {
                        if (prop.IsDefined(typeof(OSE_ObjectTypes)))
                            meta.options = prop.GetCustomAttribute<OSE_ObjectTypes>().ObjectTypes.Select(a => ((EbObjectType)a).Name).ToArray();
                    }
                    else if (meta.editor == (int)PropertyEditorType.Expandable && prop.PropertyType.GetTypeInfo().IsClass)
                        meta.submeta = this.GetMetaCollection(Activator.CreateInstance(prop.PropertyType)).ToList<Meta>();
                    else if (meta.editor == (int)PropertyEditorType.CollectionABCpropToggle && prop.PropertyType.GetTypeInfo().BaseType.IsGenericType &&
                                prop.PropertyType.GetTypeInfo().BaseType.GetGenericTypeDefinition() == typeof(List<>))
                    {
                        Type itemType = prop.PropertyType.GetTypeInfo().BaseType.GetGenericArguments()[0];
                        meta.options = getOptions(itemType);
                    }
                    else if (meta.editor == (int)PropertyEditorType.ObjectSelectorCollection)
                    {
                        if (prop.IsDefined(typeof(OSE_ObjectTypes)))
                            meta.options = prop.GetCustomAttribute<OSE_ObjectTypes>().ObjectTypes.Select(a => ((EbObjectType)a).Name).ToArray();
                    }
                    else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
                    {
                        Type itemType = prop.PropertyType.GetGenericArguments()[0];
                        meta.options = getOptions(itemType);
                    }

                }
                if (attr is ListType)
                {
                    if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
                    {
                        Type itemType = null;
                        itemType = (attr as ListType).TypeOfList;
                        meta.options = getOptions(itemType);
                    }
                }
            }

            //if prop is of primitive type set corresponding editor  
            if (!prop.IsDefined(typeof(PropertyEditor)))
            {
                if (prop.PropertyType.GetTypeInfo().IsEnum)
                {
                    meta.editor = (int)PropertyEditorType.DropDown;
                    this.EbEnums += "'" + prop.PropertyType.GetTypeInfo().Name + "': {";
                    foreach (dynamic enumStr in Enum.GetValues(prop.PropertyType))
                    {
                        meta.enumoptions.Add((int)enumStr, enumStr.ToString());
                        this.EbEnums += "'" + enumStr.ToString() + "':" + "'" + (int)enumStr + "', ";
                    }
                    this.EbEnums += "}, ";
                }
                else if (prop.PropertyType != typeof(List<EbControl>))
                    meta.editor = (int)this.GetTypeOf(prop);
            }

            //if no helpText attribut is set, set as empty string
            if (!prop.IsDefined(typeof(HelpText)))
                meta.helpText = string.Empty;
            return meta;
        }

        private string[] getOptions(Type itemType)
        {
            if (itemType.Name != typeof(EbControl).Name)
            {
                IEnumerable<Type> subClasses = itemType.Assembly.GetTypes().Where(type => type.IsSubclassOf(itemType));
                List<string> _sa = new List<string>();
                if (!itemType.IsAbstract && !itemType.IsDefined(typeof(HideInPropertyGrid)))
                    _sa.Add(itemType.Name + "-/-" + itemType.Name);
                foreach (Type type in subClasses)
                {
                    string _Alias = null;
                    foreach (Attribute attribute in type.GetCustomAttributes())
                    {
                        if (attribute is Alias)
                            _Alias = (attribute as Alias).Name.Trim();
                    }
                    _sa.Add(type.Name + "-/-" + (_Alias ?? type.Name));
                }
                return _sa.ToArray<string>();
            }
            return (new string[] { });
        }

        private PropertyEditorType GetTypeOf(PropertyInfo prop)
        {
            Type type = prop.PropertyType;

            if (type == typeof(int) || type == typeof(Int16) || type == typeof(Int32) || type == typeof(Int64) || type == typeof(Decimal) || type == typeof(Double) || type == typeof(Single))
                return PropertyEditorType.Number;

            else if (type == typeof(string))
                return PropertyEditorType.Text;

            else if (type == typeof(bool))
                return PropertyEditorType.Boolean;

            return PropertyEditorType.Text;
        }

        private string JsVarDecl(PropertyInfo prop, object obj)
        {
            string s = @"this.{0} = {1};";
            string _c = @"this.Controls = new EbControlCollection(JSON.parse('{0}'));";
            string _name = prop.Name;
            if (prop.IsDefined(typeof(JsonPropertyAttribute)))
            {
                _name = prop.GetCustomAttribute<JsonPropertyAttribute>().PropertyName;
            }
            if (prop.IsDefined(typeof(DefaultPropValue)) && (prop.PropertyType.IsPrimitive || prop.PropertyType == typeof(string) || prop.PropertyType.IsEnum))
            {

                string DefaultVal = prop.GetCustomAttribute<DefaultPropValue>().Value;
                // For Object Selector
                if (prop.GetType().GetTypeInfo().IsDefined(typeof(PropertyEditor)) && prop.GetCustomAttribute<PropertyEditor>().PropertyEditorType == (int)PropertyEditorType.ObjectSelector)
                {
                    Attribute EditorAttr = prop.GetCustomAttribute<PropertyEditor>();
                    PropertyEditorType EditorType = (PropertyEditorType)(EditorAttr as PropertyEditor).PropertyEditorType;

                    if (EditorType is PropertyEditorType.ObjectSelector)
                        DefaultVal = DefaultVal.SingleQuoted();
                }
                //for Others
                else if (prop.PropertyType == typeof(string) || prop.PropertyType == typeof(DateTime))
                    DefaultVal = DefaultVal.SingleQuoted();

                return string.Format(s, _name, DefaultVal);
            }

            if (prop.PropertyType == typeof(string))
            {
                if (!string.IsNullOrEmpty((string)prop.GetValue(obj)))
                    return string.Format(s, _name, string.Format("'{0}'", prop.GetValue(obj)));
                if (prop.Name.EndsWith("Color"))
                    return string.Format(s, _name, "'#FFFFFF'");
                else
                    return string.Format(s, _name, (prop.Name == "Name" || prop.Name == "EbSid") ? "id" : "''");
            }
            else if (prop.Name == "Controls")
                return string.Format(_c, JsonConvert.SerializeObject((obj as EbControlContainer).Controls, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All }));
            else if (prop.PropertyType == (typeof(int)) || prop.PropertyType == (typeof(float)))
                return string.Format(s, _name, ((prop.Name == "Id") ? "id" : "0"));
            else if (prop.PropertyType == typeof(bool))
                return string.Format(s, _name, prop.GetValue(obj).ToString().ToLower());
            else if (prop.PropertyType.GetTypeInfo().IsEnum)
            {
                if (prop.IsDefined(typeof(PropertyEditor)) && prop.GetCustomAttribute<PropertyEditor>().BooleanOption)
                {
                    Type[] args = prop.PropertyType.GetGenericArguments();
                    Type itemType = args[0];
                    return string.Format(s, _name, "{\"$type\":\"System.Collections.Generic.List`1[[@typeName, @nameSpace]], System.Private.CoreLib\",\"$values\":[]}".Replace("@typeName", itemType.FullName).Replace("@nameSpace", itemType.AssemblyQualifiedName.Split(",")[1]));
                }
                return string.Format(s, _name, ((int)prop.GetValue(obj)).ToString());
            }
            else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition().Name == "IDictionary`2")
                return string.Format(s, _name, "{\"$type\": \"System.Collections.Generic.Dictionary`2[[System.String, System.Private.CoreLib],[System.Object, System.Private.CoreLib]], System.Private.CoreLib\",\"$values\": {}}");//need to recheck format
            else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
            {
                Type[] args = prop.PropertyType.GetGenericArguments();
                if (args.Length > 0)
                {
                    Type itemType = args[0];
                    return string.Format(s, _name, "{\"$type\":\"System.Collections.Generic.List`1[[@typeName, @nameSpace]], System.Private.CoreLib\",\"$values\":[]}".Replace("@typeName", itemType.FullName).Replace("@nameSpace", itemType.AssemblyQualifiedName.Split(",")[1]));
                }
                else
                {
                    return string.Format(s, _name, "[]");
                }
            }
            else if (prop.PropertyType.IsClass && !prop.PropertyType.IsPrimitive)
            {
                if (prop.PropertyType == typeof(EbFont))
                {
                    return string.Format(s, _name, "null");
                }
                else
                {
                    try
                    {
                        object Obj = Activator.CreateInstance(prop.PropertyType);
                        SetAllDefaultPropVals(prop, Obj);
                        return string.Format(s, _name, EbSerializers.Json_Serialize(Obj));
                    }
                    catch (Exception e)
                    {
                        Console.Write(e.Message);
                        return "";
                    }
                }
            }
            else
                return string.Format(s, _name, "null");
        }

        private dynamic SetAllDefaultPropVals(PropertyInfo prop, object Obj)
        {
            PropertyInfo[] props = Obj.GetType().GetProperties();
            int i = 0;
            if (prop.GetCustomAttribute<DefaultPropValue>() != null && prop.GetCustomAttribute<DefaultPropValue>().Values.Count != 0)
            {
                List<Object> vals = prop.GetCustomAttribute<DefaultPropValue>().Values;

                foreach (object val in vals)
                {
                    try
                    {
                        PropertyInfo propInfo = props[i];
                        if (val != null)
                            propInfo.SetValue(Obj, val, null);
                        else
                            break;
                    }
                    catch (Exception e)
                    {
                        Console.WriteLine(e.Message);
                    }
                    i++;
                }
            }
            return Obj;
        }
    }
}
