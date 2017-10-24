using ExpressBase.Objects;
using ExpressBase.Common.Objects.Attributes;
using Newtonsoft.Json;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using ExpressBase.Common.Extensions;

namespace ExpressBase.Common.Objects
{
    public class CSharpToJs
    {
        public struct JsResult
        {
            public string Meta;
            public string JsObjects;
            public string TypeRegister; // Factory method to create appropriate JsObj
            public string ToolBoxHtml;
            public string JsonToJsObjectFuncs; //Attach functions etc. in edit mode
            public string EbObjectTypes; // EbObjectType enum as JSobject
        }

        public static JsResult GenerateJs<T>(BuilderType _builderType, Type[] types)
        {
            JsResult _result = new JsResult();

            string _toolsHtml = string.Empty;

            string _metaStr = "AllMetas = {";

            string _controlsStr = "var EbObjects = {};";

            string __jsonToJsObjectFunc = @"
function Proc(jsonObj, rootContainerObj) {
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
            string _typeInfos = "function ObjectFactory(jsonObj) { ";

            foreach (var tool in types)
            {
                if (tool.GetTypeInfo().IsSubclassOf(typeof(T)))
                {
                    if (tool.GetTypeInfo().IsDefined(typeof(EnableInBuilder))
                         && tool.GetTypeInfo().GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(_builderType))
                    {
                        if (!tool.GetTypeInfo().IsDefined(typeof(HideInToolBox)))
                            _toolsHtml += GetToolHtml(tool.Name.Substring(2));

                        var toolObj = (T)Activator.CreateInstance(tool);
                        _typeInfos += string.Format("if (jsonObj['$type'].includes('{0}')) return new EbObjects.{1}(jsonObj.EbSid, jsonObj); ", toolObj.GetType().FullName, toolObj.GetType().Name);
                        GetJsObject(_builderType, toolObj, ref _metaStr, ref _controlsStr);
                    }
                }
            }




            _metaStr += "}";
            _controlsStr += "";

            _result.Meta = _metaStr;
            _result.JsObjects = _controlsStr;
            _result.ToolBoxHtml = _toolsHtml;
            _result.TypeRegister = _typeInfos + " };";

            _result.EbObjectTypes = "var EbObjectTypes = " + Get_EbObjTypesStr();

            _result.JsonToJsObjectFuncs = __jsonToJsObjectFunc;

            return _result;
        }

        private static string Get_EbObjTypesStr()
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

        private static string GetToolHtml(string tool_name)
        {
            return @"<div eb-type='@toolName' class='tool'>@toolName</div>".Replace("@toolName", tool_name);
        }

        private static List<Meta> GetMetaCollection(BuilderType bType, object obj)
        {
            List<Meta> MetaCollection = new List<Meta>();

            var props = obj.GetType().GetAllProperties();
            foreach (var prop in props)
            {
                Meta _meta = null;
                if (prop.IsDefined(typeof(EnableInBuilder)) && prop.GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(bType))
                {
                    _meta = GetMeta(bType, obj, prop);
                    if (!prop.IsDefined(typeof(HideInPropertyGrid)))
                        MetaCollection.Add(_meta);
                }
            }

            return MetaCollection;
        }

        private static Meta GetMeta(BuilderType bType, object obj, PropertyInfo prop)
        {
            var meta = new Meta { name = prop.Name };

            var propattrs = prop.GetCustomAttributes();
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
                else if (attr is Attributes.Required)
                    meta.IsRequired = true;
                else if (attr is UIproperty)
                    meta.IsUIproperty = true;
                else if (attr is PropertyEditor)
                {
                    meta.editor = (attr as PropertyEditor).PropertyEditorType;
                    meta.source = (attr as PropertyEditor).PropertyEditorSource;

                    if (prop.PropertyType.GetTypeInfo().IsEnum)
                    {
                        foreach (dynamic enumStr in Enum.GetValues(prop.PropertyType))
                            meta.enumoptions.Add((int)enumStr, enumStr.ToString());
                    }
                    else if (meta.editor == PropertyEditorType.ObjectSelector)
                    {
                        if (prop.IsDefined(typeof(OSE_ObjectTypes)))
                            meta.options = prop.GetCustomAttribute<OSE_ObjectTypes>().ObjectTypes.Select(a => a.ToString()).ToArray();
                    }
                    else if (meta.editor == PropertyEditorType.Expandable && prop.PropertyType.GetTypeInfo().IsClass)
                        meta.submeta = GetMetaCollection(bType, Activator.CreateInstance(prop.PropertyType));
                    else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
                    {
                        Type itemType = prop.PropertyType.GetGenericArguments()[0];
                        if (itemType.Name != typeof(EbControl).Name)
                        {
                            var subClasses = itemType.Assembly.GetTypes().Where(type => type.IsSubclassOf(itemType));
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
                    foreach (dynamic enumStr in Enum.GetValues(prop.PropertyType))
                        meta.enumoptions.Add((int)enumStr, enumStr.ToString());
                }
                else if (prop.PropertyType != typeof(List<EbControl>))
                    meta.editor = GetTypeOf(prop);
            }

            //if no helpText attribut is set, set as empty string
            if (!prop.IsDefined(typeof(HelpText)))
                meta.helpText = string.Empty;

            return meta;
        }

        private static void GetJsObject(BuilderType _builderType, object obj, ref string MetaStr, ref string ControlsStr)
        {
            string _props = string.Empty;

            var props = obj.GetType().GetAllProperties();

            List<Meta> MetaCollection = GetMetaCollection(_builderType, obj);

            if (obj is EbControlContainer)
                _props += @"this.IsContainer = true;";

            foreach (var prop in props)
            {
                var propattrs = prop.GetCustomAttributes();

                if (prop.IsDefined(typeof(EnableInBuilder))
                             && prop.GetCustomAttribute<EnableInBuilder>().BuilderTypes.Contains(_builderType))
                {
                    _props += JsVarDecl(prop, obj);
                }
            }

            MetaStr += @"
'@Name'  : @MetaCollection,"
.Replace("@Name", obj.GetType().Name)
.Replace("@MetaCollection", JsonConvert.SerializeObject(MetaCollection));

            ControlsStr += @"
EbObjects.@Name = function @Name(id, jsonObj) {
    this.$type = '@Type, ExpressBase.Objects';
    this.EbSid = id;
    @Props
    @InitFunc
    this.Html = function () { return @html.replace(/@id/g, id); };
    var MyName = this.constructor.name;
    this.RenderMe = function () { var NewHtml = this.Html(), me = this, metas = AllMetas[MyName]; $.each(metas, function (i, meta) { var name = meta.name; if (meta.IsUIproperty) { NewHtml = NewHtml.replace('@' + name + ' ', me[name]); } }); if(!this.IsContainer) $('#' + id + ' .Eb-ctrlContainer').html($(NewHtml).html()); };
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

        private static string JsVarDecl(PropertyInfo prop, object obj)
        {
            string s = @"this.{0} = {1};";
            string _c = @"this.Controls = new EbControlCollection(JSON.parse('{0}'));";

            if (prop.IsDefined(typeof(DefaultPropValue)))
            {
                Attribute EditorAttr = prop.GetCustomAttribute<PropertyEditor>();
                PropertyEditorType EditorType = PropertyEditorType.DropDown;

                if (prop.PropertyType.GetTypeInfo().IsEnum)
                    EditorType = PropertyEditorType.DropDown;
                else
                    EditorType = (EditorAttr as PropertyEditor).PropertyEditorType;

                var DefaultAttr = prop.GetCustomAttribute<DefaultPropValue>();
                var Defaulval = (DefaultAttr as DefaultPropValue).Value;

                if (EditorType is PropertyEditorType.Text || EditorType is PropertyEditorType.Color || EditorType is PropertyEditorType.Label
                    || EditorType is PropertyEditorType.DateTime || EditorType is PropertyEditorType.ObjectSelector || EditorType is PropertyEditorType.FontSelector)
                    Defaulval = Defaulval.SingleQuoted();

                return string.Format(s, prop.Name, Defaulval);
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
            else if (prop.PropertyType == typeof(int) || prop.PropertyType == typeof(float) || prop.PropertyType == typeof(decimal))
                return string.Format(s, prop.Name, ((prop.Name == "Id") ? "id" : "0"));
            else if (prop.PropertyType == typeof(bool))
                return string.Format(s, prop.Name, "false");
            else if (prop.PropertyType.GetTypeInfo().IsEnum)
                return string.Format(s, prop.Name, "0");
            else if (prop.PropertyType.IsGenericType && prop.PropertyType.GetGenericTypeDefinition() == typeof(List<>))
            {
                var args = prop.PropertyType.GetGenericArguments();
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
                var Obj = Activator.CreateInstance(prop.PropertyType);
                return string.Format(s, prop.Name, EbSerializers.Json_Serialize(Obj));
            }
            else
                return string.Format(s, prop.Name, "null");
        }

        private static PropertyEditorType GetTypeOf(PropertyInfo prop)
        {
            var type = prop.PropertyType;

            if (type == typeof(int) || type == typeof(Int16) || type == typeof(Int32) || type == typeof(Int64) || type == typeof(decimal) || type == typeof(double) || type == typeof(Single))
                return PropertyEditorType.Number;

            else if (type == typeof(string))
                return PropertyEditorType.Text;

            else if (type == typeof(bool))
                return PropertyEditorType.Boolean;

            return PropertyEditorType.Text;
        }
    }
}
