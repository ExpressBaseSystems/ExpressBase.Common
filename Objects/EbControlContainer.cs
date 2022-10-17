using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using ServiceStack.Redis;
using ExpressBase.Common.Objects.Attributes;
using ServiceStack;
using ExpressBase.Common.Extensions;
using System.Linq;
using Newtonsoft.Json;
using System.Runtime.Serialization;
using ExpressBase.Objects;
using ExpressBase.Common.Constants;

namespace ExpressBase.Common.Objects
{
    public enum EnumOperator
    {
        Equal,
        NotEqual,
        StartsWith,
        Contains,
        GreaterThan,
        GreaterThanOrEqual,
        LessThan,
        LessThanOrEqual
    }

    [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
    public class EbControlContainer : EbControlUI
    {

        [OnDeserialized]
        public void OnDeserializedMethod(StreamingContext context)
        {
            if (this.Padding == null)
                this.Padding = new UISides();
        }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl, BuilderType.SurveyControl)]
        [HideInPropertyGrid]
        [PropertyPriority(70)]
        [PropertyGroup("Behavior")]
        public virtual List<EbControl> Controls { get; set; }

        //[HideInPropertyGrid]
        //public EbTable Table { get; set; }

        public EbControlContainer()
        {
            this.Controls = new List<EbControl>();
        }

        public override string BackColor { get; set; }

        public override string ForeColor { get; set; }

        //[JsonIgnore]
        public override bool Hidden { get; set; }

        //[JsonIgnore]
        public override EbScript HiddenExpr { get; set; }

        [JsonIgnore]
        public override EbScript DisableExpr { get; set; }

        [JsonIgnore]
        public override EbScript ValueExpr { get; set; }

        public override bool SelfTrigger { get; set; }

        //[JsonIgnore] //this prop using in DG -to prevent attribute propagation
        public override bool IsDisable { get; set; }

        public override bool DoNotPersist { get; set; }

        public override bool DoNotImport { get; set; }

        public override EbScript OnChangeFn { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual bool IsSpecialContainer { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual bool isTableNameFromParent { get; set; }


        [EnableInBuilder(BuilderType.WebForm, BuilderType.BotForm, BuilderType.UserControl)]
        [PropertyEditor(PropertyEditorType.Expandable)]
        [PropertyGroup(PGConstants.APPEARANCE)]
        [UIproperty]
        [OnChangeUIFunction("Common.PADDING")]
        //[DefaultPropValue(4, 4, 4, 4)]
        public virtual UISides Padding { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.UserControl)]
        [PropertyGroup(PGConstants.DATA)]
        [PropertyPriority(70)]
        [HelpText("Name Of database-table Which you want to store Data collected using this Form")]
        [InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        public virtual string TableName { get; set; }

        [JsonIgnore]
        public override bool Required { get; set; }

        [JsonIgnore]
        public override bool Unique { get; set; }

        [JsonIgnore]
        public override string ToolTipText { get; set; }

        //[JsonIgnore]
        //public override string FontFamily { get; set; }

        public override List<EbValidator> Validators { get; set; }

        [JsonIgnore]
        public override EbScript DefaultValueExpression { get; set; }


        [JsonIgnore]
        public override string GetValueJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string GetValueFromDOMJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string GetDisplayMemberFromDOMJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string GetDisplayMemberJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string IsRequiredOKJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string SetValueJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string SetDisplayMemberJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string JustSetValueJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string IsEmptyJSfn { get { return string.Empty; } set { } }

        //[JsonIgnore]
        //public override string HideJSfn { get { return string.Empty; } set { } }

        //[JsonIgnore]
        //public override string ShowJSfn { get { return string.Empty; } set { } }

        //[JsonIgnore]
        //public override string EnableJSfn { get { return string.Empty; } set { } }

        //[JsonIgnore]
        //public override string DisableJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string ResetJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string RefreshJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string ClearJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string OnChangeBindJSFn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string AddInvalidStyleJSFn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string RemoveInvalidStyleJSFn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string GetColumnJSfn { get { return string.Empty; } set { } }

        [JsonIgnore]
        public override string StyleJSFn { get { return string.Empty; } set { } }

        //methods

        public void SetContextId(string ContextId)
        {
            this.ContextId = ContextId;
            for (int i = 0; i < Controls.Count; i++)
            {
                EbControl control = Controls[i];
                control.ContextId = ContextId;
                if (control is EbControlContainer)
                    (control as EbControlContainer).SetContextId(ContextId);

            }
        }
        public virtual string GetHtml(bool isRootObj)
        {
            return string.Empty;
        }

        public EbControlContainer Localize(Dictionary<string, string> Keys)
        {
            EbControl[] controls = this.Controls.FlattenAllEbControls();

            foreach (EbControl control in controls)
            {
                PropertyInfo[] props = control.GetType().GetProperties();

                foreach (PropertyInfo prop in props)
                {
                    if (prop.DeclaringType == typeof(string))
                    {
                        if (prop.IsDefined(typeof(PropertyEditor))
                            && prop.GetCustomAttribute<PropertyEditor>().PropertyEditorType == (int)PropertyEditorType.MultiLanguageKeySelector)
                        {

                            string oldVal = prop.GetValue(control, null) as string;
                            string newVal = (Keys.ContainsKey(oldVal)) ? Keys[oldVal] : oldVal;

                            prop.SetValue(control, newVal, null);
                        }
                    }
                }
            }

            return this;
        }

        //Get all proprty value which 
        public static string[] GetKeys(object formObj)
        {
            EbControlContainer _formObj = formObj as EbControlContainer;
            List<string> templist = new List<string>();
            EbControl[] controls = _formObj.Controls.FlattenAllEbControls();// get all objects in the form

            foreach (EbControl control in controls)
            {
                PropertyInfo[] props = control.GetType().GetProperties();
                foreach (PropertyInfo prop in props)
                {
                    if (prop.IsDefined(typeof(PropertyEditor)) && prop.GetCustomAttribute<PropertyEditor>().PropertyEditorType == (int)PropertyEditorType.MultiLanguageKeySelector)
                    {
                        string val = control.GetType().GetProperty(prop.Name).GetValue(control, null) as String;
                        if (!val.IsNullOrEmpty() && !templist.Contains(val))
                            templist.Add(val); ;
                    }
                }
            }
            return templist.ToArray();
        }

        //foreach (EbControl control in Controls)
        //{
        //    if (control is EbControlContainer)
        //    {
        //        EbControlContainer Cont = control as EbControlContainer;
        //        if (Cont.TableName.IsNullOrEmpty()|| Cont.TableName.Trim() == string.Empty)
        //        {
        //            Cont.TableName = TableName;
        //        }
        //    }
        //}

        //public virtual string GetSelectQuery(string _parentTblName)
        //{
        //	string ColoumsStr = Get1stLvlColNames();
        //	string qry = string.Empty;
        //	if (ColoumsStr.Length > 0)
        //	{
        //		if (TableName == _parentTblName)
        //			qry = string.Format("SELECT id, {0} FROM {1} WHERE {3} = {2};", ColoumsStr, TableName, TableRowId, "id");
        //		else
        //			qry = string.Format("SELECT id, {0} FROM {1} WHERE {3}={2};", ColoumsStr, TableName, TableRowId, _parentTblName + "_id");

        //	}

        //	foreach (EbControl control in Controls)
        //	{
        //		if (control is EbControlContainer)
        //		{
        //			EbControlContainer _control = (control as EbControlContainer);
        //			if (_control.TableName.IsNullOrEmpty())
        //			{
        //				_control.TableName = TableName;
        //			}
        //			//_control.TableName = _control.TableName.IsNullOrEmpty() ? TableName : _control.TableName;
        //			_control.TableRowId = (_control.TableRowId == 0) ? TableRowId : _control.TableRowId;
        //			qry += _control.GetSelectQuery(_parentTblName);
        //		}
        //	}
        //	return qry;
        //}

        public static string GetControlOpsJS(EbControlContainer ebControlContainer, BuilderType FormTypeEnum)
        {
            string JSCode = "var ControlOps = {}";
            Type[] _typeArray = (ebControlContainer.GetType().GetTypeInfo().Assembly.GetTypes());
            Dictionary<string, string> DictControlOps = new Dictionary<string, string>();

            foreach (Type ctrlType in _typeArray)
            {
                try
                {
                    TypeInfo _typeInfo = ctrlType.GetTypeInfo();
                    var _enableInBuider = _typeInfo.GetCustomAttribute<EnableInBuilder>();
                    string TypeName = ctrlType.Name.Substring(2, ctrlType.Name.Length - 2);

                    if (_enableInBuider != null && _enableInBuider.BuilderTypes.Contains(FormTypeEnum))
                    {
                        object ctrlObj = Activator.CreateInstance(ctrlType);
                        if (
                            //(!_typeInfo.IsDefined(typeof(HideInToolBox))) && // temp 
                            ctrlObj is EbControl)
                            if (!DictControlOps.ContainsKey(TypeName))
                            {
                                EbControl _ctrlObj = (ctrlObj as EbControl);
                                string opFnsJs = string.Empty;
                                opFnsJs += GetOpFnJs("getValue", _ctrlObj.GetValueJSfn, TypeName);
                                opFnsJs += GetOpFnJs("getPreviousValue", _ctrlObj.GetPreviousValueJSfn, TypeName);
                                opFnsJs += GetOpFnJs("getValueFromDOM", _ctrlObj.GetValueFromDOMJSfn, TypeName);
                                opFnsJs += GetOpFnJs("getDisplayMember", _ctrlObj.GetDisplayMemberJSfn, TypeName);
                                opFnsJs += GetOpFnJs("getDisplayMemberFromDOM", _ctrlObj.GetDisplayMemberFromDOMJSfn, TypeName);
                                opFnsJs += GetOpFnJs("isRequiredOK", _ctrlObj.IsRequiredOKJSfn, TypeName);
                                opFnsJs += GetOpFnJs("isEmpty", _ctrlObj.IsEmptyJSfn, TypeName);
                                opFnsJs += GetOpFnJs("setValue", _ctrlObj.SetValueJSfn, TypeName);
                                opFnsJs += GetOpFnJs("setDisplayMember", _ctrlObj.SetDisplayMemberJSfn, TypeName);
                                opFnsJs += GetOpFnJs("justSetValue", _ctrlObj.JustSetValueJSfn, TypeName);
                                opFnsJs += GetOpFnJs("hide", _ctrlObj.HideJSfn, TypeName);
                                opFnsJs += GetOpFnJs("show", _ctrlObj.ShowJSfn, TypeName);
                                opFnsJs += GetOpFnJs("enable", _ctrlObj.EnableJSfn, TypeName);
                                opFnsJs += GetOpFnJs("disable", _ctrlObj.DisableJSfn, TypeName);
                                opFnsJs += GetOpFnJs("reset", _ctrlObj.ResetJSfn, TypeName);
                                opFnsJs += GetOpFnJs("refresh", _ctrlObj.RefreshJSfn, TypeName);
                                opFnsJs += GetOpFnJs("clear", _ctrlObj.ClearJSfn, TypeName);
                                opFnsJs += GetOpFnJs("addInvalidStyle", _ctrlObj.AddInvalidStyleJSFn, TypeName);
                                opFnsJs += GetOpFnJs("removeInvalidStyle", _ctrlObj.RemoveInvalidStyleJSFn, TypeName);
                                opFnsJs += GetOpFnJs("bindOnChange", _ctrlObj.OnChangeBindJSFn, TypeName);

                                if (_ctrlObj.ObjType == "DGPowerSelectColumn")
                                {
                                    opFnsJs += GetOpFnJs("getColumn", _ctrlObj.GetColumnJSfn, TypeName);
                                }

                                string fn = string.Concat("function ", TypeName, "(jsonObj){ $.extend(this, jsonObj);", opFnsJs, "}");//.RemoveCR();

                                JSCode += string.Concat(@"
                                                        ControlOps.", TypeName, " = ", fn); ;

                                DictControlOps.Add(TypeName, "fn placeholder");
                            }
                    }
                }
                catch (Exception e)
                {
                    Console.WriteLine(e.Message);
                }
            }
            return JSCode;
        }

        private static string GetOpFnJs(string opFnName, string JSfn, string TypeName)
        {
            return string.Concat(@"
                                    this.", opFnName, " = function(p1, p2, p3, p4) { ", JSfn, "};");//.RemoveCR();
        }

        public static void SetContextId(EbControlContainer FormObj, string contextId)
        {

            try
            {
                FormObj.ContextId = contextId;
                foreach (EbControl control in FormObj.Controls)
                {
                    if (control is EbControlContainer)
                    {
                        EbControlContainer.SetContextId(control as EbControlContainer, contextId);
                    }
                    else
                    {
                        control.ContextId = contextId;
                    }
                }
            }
            catch (Exception e)
            {
                if (FormObj == null)
                    throw new NullReferenceException();
                else throw e;
            }
        }

        public virtual string Get1stLvlColNames()
        {
            string ColoumsStr = String.Empty;
            IEnumerable<EbControl> controls = Controls.Get1stLvlControls();
            foreach (var control in controls)
            {
                ColoumsStr += control.Name + ", ";
            }
            return (ColoumsStr.Length > 0) ? ColoumsStr.Substring(0, ColoumsStr.Length - 2) : string.Empty;
        }

        public virtual int TableRowId { get; set; }

        public override string HelpText { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [HideInPropertyGrid]
        public virtual bool IsContainer { get { return true; } private set { } }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        [Alias("Title")]
        public override string Label { get; set; }

        public override void Init4Redis(IRedisClient redisclient, IServiceClient serviceclient)
        {
            base.Redis = redisclient;
            base.ServiceStackClient = serviceclient;
        }

        public override string GetHtml() { return string.Empty; }

        public string GetInsertQry()
        {
            string qry = string.Empty;

            return qry;
        }

        public string GetCtrlNamesOfTable(string tableName)
        {
            string cols = string.Empty;
            if (TableName == tableName)
            {
                string _1stLvlColNames = Get1stLvlColNames();
                if (!_1stLvlColNames.IsNullOrEmpty())
                    cols += string.Concat(_1stLvlColNames, ", ");
            }
            GetCtrlNamesOfTableRec(tableName, ref cols);
            return cols.Substring(0, cols.Length - 2);
        }

        private void GetCtrlNamesOfTableRec(string tableName, ref string cols)
        {
            foreach (EbControl control in Controls)
            {
                if (control is EbControlContainer)
                {
                    EbControlContainer Cont = control as EbControlContainer;
                    Cont.TableName = Cont.TableName.IsNullOrEmpty() ? TableName : Cont.TableName;
                    if (Cont.TableName == tableName)
                    {
                        string _1stLvlColNames = Cont.Get1stLvlColNames();
                        if (!_1stLvlColNames.IsNullOrEmpty())
                            cols += string.Concat(_1stLvlColNames, ", ");
                    }
                    Cont.GetCtrlNamesOfTableRec(tableName, ref cols);
                }
            }
        }

    }
}
