using ExpressBase.Common.Extensions;
using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Objects;
using Newtonsoft.Json;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;

namespace ExpressBase.Common.Objects
{
    public class Context2Js
    {
        private BuilderType BuilderType { get; set; }
        private Type[] TypeArray { get; set; }
        private Type TypeOfTopEbObjectParent { get; set; }

        private DateTime? start { get; set; }
        private DateTime? end { get; set; }
        public int MilliSeconds { get; private set; }

        public string AllMetas { get; private set; }
        public string EbEnums { get; private set; }
        public string JsObjects { get; private set; }
        public string ToolBoxHtml { get; private set; }
        public string TypeRegister { get; private set; }
        public string JsonToJsObjectFuncs { get; private set; }
        public string EbObjectTypes { get; private set; }

        public Context2Js(Type[] _typeArray, BuilderType _builderType, Type topObjectParentType)
        {
            this.BuilderType = _builderType;
            this.TypeArray = _typeArray;
            this.TypeOfTopEbObjectParent = topObjectParentType;

            this.AllMetas = string.Empty;
            this.EbEnums = string.Empty;
            this.JsObjects = string.Empty;
            this.ToolBoxHtml = string.Empty;
            this.TypeRegister = string.Empty;
            this.JsonToJsObjectFuncs = string.Empty;
            this.EbObjectTypes = string.Empty;

            DateTime start = DateTime.Now;
            this.GenerateJs();
            DateTime end = DateTime.Now;

            this.MilliSeconds = (end - start).Milliseconds;
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

            this.AllMetas = null;
            this.JsObjects = null;
            this.ToolBoxHtml = null;
            this.TypeRegister = null;
            this.JsonToJsObjectFuncs = null;
            this.EbObjectTypes = null;
        }

        private void GenerateJs()
        {
            this.AllMetas = "var AllMetas = {";
            this.EbEnums = "var EbEnums = {";
            this.JsObjects = "var EbObjects = {};";

            this.JsonToJsObjectFuncs = @"
function Proc(jsonObj, rootContainerObj) {
    $.extend(rootContainerObj, jsonObj);
    rootContainerObj.Controls = new EbControlCollection({});
    ProcRecur(jsonObj.Controls, rootContainerObj.Controls);
    setTimeout(function () {
        console.log(' attached rootContainerObj.Controls :' + JSON.stringify(rootContainerObj.Controls));
    }, 500);
};

function ProcRecur(src_controls, dest_controls) {
    $.each(src_controls.$values, function (i, control) {
        var newObj = ObjectFactory(control);
            dest_controls.Append  (newObj);
        if (control.IsContainer){
            newObj.Controls.$values=[];
            ProcRecur(control.Controls, newObj.Controls);
        }
    });
};";
            this.TypeRegister = "function ObjectFactory(jsonObj) { ";

            foreach (Type tool in this.TypeArray)
            {
                if (tool.GetTypeInfo().IsSubclassOf(this.TypeOfTopEbObjectParent))
                {
                    try
                    {
                        TypeInfo _typeInfo = tool.GetTypeInfo();
                        var _enableInBuider = _typeInfo.GetCustomAttribute<EnableInBuilder>();

                        if (_enableInBuider != null && _enableInBuider.BuilderTypes.Contains(this.BuilderType))
                        {
                            if (!_typeInfo.IsDefined(typeof(HideInToolBox)))
                                this.ToolBoxHtml += this.GetToolHtml(tool.Name.Substring(2));

                            object toolObj = Activator.CreateInstance(tool);
                            this.TypeRegister += string.Format("if (jsonObj['$type'].includes('{0}')) return new EbObjects.{1}(jsonObj.EbSid, jsonObj); ", toolObj.GetType().FullName, toolObj.GetType().Name);
                            this.GetJsObject(toolObj);
                        }
                    }
                    catch (Exception ee)
                    {

                    }
                }
            }

            this.AllMetas += "};" + this.EbEnums + "};";
            this.TypeRegister += " };";
            this.EbObjectTypes = "var EbObjectTypes = " + Get_EbObjTypesStr();
        }

        private string GetToolHtml(string tool_name)
        {
            return @"<div eb-type='@toolName' class='tool'>@toolName</div>".Replace("@toolName", tool_name);
        }

        private void GetJsObject(object obj)
        {
            string _props = string.Empty;

            PropertyInfo[] props = obj.GetType().GetAllProperties();

            if (obj is EbControlContainer)
                _props += @"this.IsContainer = true;";

            foreach (PropertyInfo prop in props)
            {
                IEnumerable<Attribute> propattrs = prop.GetCustomAttributes();////////////////

                if (prop.IsDefined(typeof(EnableInBuilder))
                             && prop.GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(this.BuilderType))
                {
                    _props += JsVarDecl(prop, obj);
                }
            }

            this.AllMetas += @"
'@Name'  : @MetaCollection,"
.Replace("@Name", obj.GetType().Name)
.Replace("@MetaCollection", JsonConvert.SerializeObject(this.GetMetaCollection(obj)));

            this.JsObjects += @"
EbObjects.@Name = function @Name(id, jsonObj) {
    this.$type = '@Type, ExpressBase.Objects';
    this.EbSid = id;
    @Props
    @InitFunc
    this.Html = function () { return @html.replace(/@id/g, this.EbSid); };
    var MyName = this.constructor.name;
    this.RenderMe = function () { 
var NewHtml = this.Html(), me = this, metas = AllMetas[MyName];
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
        if(jsonObj.IsContainer)
            jsonObj.Controls  = new EbControlCollection( {} );
        jsonObj.RenderMe  = this.RenderMe;
        jsonObj.Html  = this.Html;
        jsonObj.Init   = this.Init;
        $.extend(this, jsonObj);
        //if(this.Init)
        //    jsonObj.Init(id);
    }
    else{
        if(this.Init)
            this.Init(id);
    }
};"
.Replace("@Name", obj.GetType().Name)
.Replace("@Type", obj.GetType().FullName)
.Replace("@Props", _props)
.Replace("@InitFunc", (obj as EbObject).GetJsInitFunc())
.Replace("@html", (obj as EbObject).GetDesignHtml());

        }

        private string Get_EbObjTypesStr()
        {
            Dictionary<string, int> _dic = new Dictionary<string, int>();
            foreach (string enumString in Enum.GetNames(typeof(EbObjectType)))
            {
                EbObjectType _type;
                Enum.TryParse(enumString, out _type);
                _dic.Add(enumString, (int)_type);
            }

            return EbSerializers.Json_Serialize(_dic);
        }

        private IEnumerable<Meta> GetMetaCollection(object obj)
        {
            PropertyInfo[] props = obj.GetType().GetAllProperties();
            foreach (PropertyInfo prop in props)
            {
                if (prop.IsDefined(typeof(EnableInBuilder)) && prop.GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(this.BuilderType))
                {
                    if (!prop.IsDefined(typeof(HideInPropertyGrid)))
                        yield return GetMeta(obj, prop);
                }
            }
        }

        private Meta GetMeta(object obj, PropertyInfo prop)
        {
            Meta meta = new Meta { name = prop.Name };

            IEnumerable<Attribute> propattrs = prop.GetCustomAttributes();
            foreach (Attribute attr in propattrs)
            {
                if (attr is Alias)
                    meta.alias = (attr as Alias).Name;
                else if (attr is PropertyGroup)
                    meta.group = (attr as PropertyGroup).Name;
                else if (attr is HelpText)
                    meta.helpText = (attr as HelpText).value;
                else if (attr is OnChangeExec)
                    meta.OnChangeExec = "function(pg){" + (attr as OnChangeExec).JsCode + "}";
                else if (attr is Attributes.EbRequired)
                    meta.IsRequired = true;
                else if (attr is UIproperty)
                    meta.IsUIproperty = true;
                else if (attr is Unique)
                    meta.IsUnique = true;
                else if (attr is PropertyEditor)
                {
                    meta.editor = (attr as PropertyEditor).PropertyEditorType;
                    meta.source = (attr as PropertyEditor).PropertyEditorSource;

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
                    else if (meta.editor == PropertyEditorType.ObjectSelector)
                    {
                        if (prop.IsDefined(typeof(OSE_ObjectTypes)))
                            meta.options = prop.GetCustomAttribute<OSE_ObjectTypes>().ObjectTypes.Select(a => a.ToString()).ToArray();
                    }
                    else if (meta.editor == PropertyEditorType.Expandable && prop.PropertyType.GetTypeInfo().IsClass)
                        meta.submeta = this.GetMetaCollection(Activator.CreateInstance(prop.PropertyType)).ToList<Meta>();
                    else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
                    {
                        Type itemType = prop.PropertyType.GetGenericArguments()[0];
                        if (itemType.Name != typeof(EbControl).Name)
                        {
                            IEnumerable<Type> subClasses = itemType.Assembly.GetTypes().Where(type => type.IsSubclassOf(itemType));
                            List<string> _sa = new List<string>();
                            if (!itemType.IsAbstract)
                                _sa.Add(itemType.Name);
                            foreach (Type type in subClasses)
                                _sa.Add(type.Name);
                            meta.options = _sa.ToArray<string>();
                        }
                    }
                }
            }

            //if prop is of primitive type set corresponding editor  
            if (!prop.IsDefined(typeof(PropertyEditor)))
            {
                if (prop.PropertyType.GetTypeInfo().IsEnum)
                {
                    meta.editor = PropertyEditorType.DropDown;
                    this.EbEnums += "'" + prop.PropertyType.GetTypeInfo().Name + "': {";
                    foreach (dynamic enumStr in Enum.GetValues(prop.PropertyType))
                    {
                        meta.enumoptions.Add((int)enumStr, enumStr.ToString());
                        this.EbEnums += "'" + enumStr.ToString() + "':" + "'" + (int)enumStr + "', ";
                    }
                    this.EbEnums += "}, ";
                }
                else if (prop.PropertyType != typeof(List<EbControl>))
                    meta.editor = this.GetTypeOf(prop);
            }

            //if no helpText attribut is set, set as empty string
            if (!prop.IsDefined(typeof(HelpText)))
                meta.helpText = string.Empty;
            return meta;
        }

        private PropertyEditorType GetTypeOf(PropertyInfo prop)
        {
            Type type = prop.PropertyType;

            if (type == typeof(int) || type == typeof(Int16) || type == typeof(Int32) || type == typeof(Int64) || type == typeof(decimal) || type == typeof(double) || type == typeof(Single))
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

            if (prop.IsDefined(typeof(DefaultPropValue)))
            {

                string DefaultVal = prop.GetCustomAttribute<DefaultPropValue>().Value;
                if (prop.Name == "Text")
                    ;
                // For Object Selector
                if (prop.GetType().GetTypeInfo().IsDefined(typeof(PropertyEditor)) && prop.GetCustomAttribute<PropertyEditor>().PropertyEditorType == PropertyEditorType.ObjectSelector)
                {
                    Attribute EditorAttr = prop.GetCustomAttribute<PropertyEditor>();
                    PropertyEditorType EditorType = (EditorAttr as PropertyEditor).PropertyEditorType;

                    if (EditorType is PropertyEditorType.ObjectSelector)
                        DefaultVal = DefaultVal.SingleQuoted();
                }
                //for Others
                else if (prop.PropertyType == typeof(string) || prop.PropertyType == typeof(DateTime))
                    DefaultVal = DefaultVal.SingleQuoted();

                return string.Format(s, prop.Name, DefaultVal);
            }

            if (prop.PropertyType == typeof(string))
            {
                if (prop.Name.EndsWith("Color"))
                    return string.Format(s, prop.Name, "'#FFFFFF'");
                else
                    return string.Format(s, prop.Name, (prop.Name == "Name" || prop.Name == "EbSid") ? "id" : "''");
            }
            else if (prop.Name == "Controls")
                return string.Format(_c, JsonConvert.SerializeObject((obj as EbControlContainer).Controls, new JsonSerializerSettings { TypeNameHandling = TypeNameHandling.All }));
            else if (prop.PropertyType == (typeof(int)) || prop.PropertyType == (typeof(float)))
                return string.Format(s, prop.Name, ((prop.Name == "Id") ? "id" : "0"));
            else if (prop.PropertyType == typeof(bool))
                return string.Format(s, prop.Name, "false");
            else if (prop.PropertyType.GetTypeInfo().IsEnum)
                return string.Format(s, prop.Name, "0");
            else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
            {
                Type[] args = prop.PropertyType.GetGenericArguments();
                if (args.Length > 1)
                {
                    Type itemType = args[0];
                    return string.Format(s, prop.Name, "{\"$type\":\"System.Collections.Generic.List`1[[@typeName, ExpressBase.Objects]], System.Private.CoreLib\",\"$values\":[]}".Replace("@typeName", itemType.FullName));
                }
                else
                {
                    return string.Format(s, prop.Name, "[]");
                }
            }
            else if (prop.PropertyType.IsClass)
            {
                object Obj = Activator.CreateInstance(prop.PropertyType);
                return string.Format(s, prop.Name, EbSerializers.Json_Serialize(Obj));
            }
            else
                return string.Format(s, prop.Name, "null");
        }
    }
}
