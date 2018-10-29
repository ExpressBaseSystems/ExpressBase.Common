using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using ServiceStack.Redis;
using ExpressBase.Common.Objects.Attributes;
using ServiceStack;
using ExpressBase.Common.Extensions;
using System.Linq;

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

    public class EbControlContainer : EbControlUI
    {
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        [HideInPropertyGrid]
        public virtual List<EbControl> Controls { get; set; }

        [HideInPropertyGrid]
        //public EbTable Table { get; set; }

        public EbControlContainer()
        {
            this.Controls = new List<EbControl>();
        }

        [EnableInBuilder(BuilderType.WebForm)]
        [PropertyGroup("Data")]
        [HelpText("Name Of database-table Which you want to store Data collected using this Form")]
        public virtual string TableName { get; set; }

        public static T Localize<T>(T formObj, JsonServiceClient serviceClient)
        {
            EbControlContainer _formObj = formObj as EbControlContainer;// need to change

            List<KeyValuePair<EbControl, string>> MLKeys = new List<KeyValuePair<EbControl, string>>();
            //{
            //    { _formObj.Controls[0], "Label" }
            //}; // hard coding
            System.Collections.IEnumerable controls = _formObj.Controls.FlattenAllEbControls();

            foreach (EbControl control in controls)
            {
                PropertyInfo[] props = control.GetType().GetProperties();

                foreach (PropertyInfo prop in props)
                {
                    if (prop.IsDefined(typeof(PropertyEditor))
                        && prop.GetCustomAttribute<PropertyEditor>().PropertyEditorType == PropertyEditorType.MultiLanguageKeySelector)
                    {
                        MLKeys.Insert(0, new KeyValuePair<EbControl, string>(control, prop.Name));
                    }
                }
            }

            Dictionary<string, string> Keys = new Dictionary<string, string>
                                                    {
                                                        { "Name", "اسم" }
                                                    }; // hard coding

            foreach (KeyValuePair<EbControl, string> MLKey in MLKeys)
            {
                EbControl Obj = MLKey.Key;
                string prop = MLKey.Value;
                string newVal = string.Empty;
                PropertyInfo propertyInfo = Obj.GetType().GetProperty(prop);
                string oldVal = propertyInfo.GetValue(Obj, null) as String;
                if (Keys.ContainsKey(oldVal))
                    newVal = Keys[oldVal];
                else
                    newVal = oldVal;
                propertyInfo.SetValue(Obj, newVal, null);
            }
            return formObj;
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

        public virtual string GetSelectQuery(string _masterTblName)
        {
            string ColoumsStr = Get1stLvlColNames();
            string qry = string.Empty;
            if (ColoumsStr.Length > 0)
            {
                if (TableName == _masterTblName)
                    qry = string.Format("SELECT {0} FROM {1} WHERE {3} = {2};", ColoumsStr, TableName, TableRowId, "id");
                else
                    qry = string.Format("SELECT {0} FROM {1} WHERE {3}={2};", ColoumsStr, TableName, TableRowId, _masterTblName + "_id");

            }

            foreach (EbControl control in Controls)
            {
                if (control is EbControlContainer)
                {
                    EbControlContainer _control = (control as EbControlContainer);
                    _control.TableName = _control.TableName.IsNullOrEmpty() ? TableName : _control.TableName;
                    _control.TableRowId = (_control.TableRowId == 0) ? TableRowId : _control.TableRowId;
                    qry += _control.GetSelectQuery(_masterTblName);
                }
            }
            return qry;
        }

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
                        if ((!_typeInfo.IsDefined(typeof(HideInToolBox))) && ctrlObj is EbControl)
                            if (!DictControlOps.ContainsKey(TypeName))
                            {
                                EbControl _ctrlObj = (ctrlObj as EbControl);
                                string opFnsJs = string.Empty;
                                opFnsJs += GetOpFnJs("getValue", _ctrlObj.GetValueJSfn, TypeName);
                                opFnsJs += GetOpFnJs("setValue", _ctrlObj.SetValueJSfn, TypeName);
                                opFnsJs += GetOpFnJs("hide", _ctrlObj.HideJSfn, TypeName);
                                opFnsJs += GetOpFnJs("show", _ctrlObj.ShowJSfn, TypeName);
                                opFnsJs += GetOpFnJs("enable", _ctrlObj.EnableJSfn, TypeName);
                                opFnsJs += GetOpFnJs("disable", _ctrlObj.DisableJSfn, TypeName);
                                opFnsJs += GetOpFnJs("reset", _ctrlObj.ResetJSfn, TypeName);
                                opFnsJs += GetOpFnJs("refresh", _ctrlObj.RefreshJSfn, TypeName);
                                opFnsJs += GetOpFnJs("clear", _ctrlObj.ClearJSfn, TypeName);


                                string fn = string.Concat("function ", TypeName, "(jsonObj){ $.extend(this, jsonObj);", opFnsJs, "}").RemoveCR();

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
                                    this.", opFnName, " = function(p1) { ", JSfn, "};").RemoveCR();
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

        public override string LabelForeColor { get; set; }

        public virtual int TableRowId { get; set; }

        public override string LabelBackColor { get; set; }

        public override string HelpText { get; set; }

        public override string ForeColor { get; set; }

        public override string FontFamily { get; set; }

        public override float FontSize { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        public virtual bool IsContainer
        {
            get
            {
                return true;
            }
            private set { }
        }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
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
