using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using ServiceStack.Redis;
using ExpressBase.Common.Objects.Attributes;
using ServiceStack;
using ExpressBase.Common.Extensions;

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

        public virtual string GetQuery()
        {
            string ColoumsStr = Get1stLvlColNames();
            string qry = string.Empty;
            if (ColoumsStr.Length > 0)
            {
                qry = string.Format("SELECT {0} FROM {1} WHERE id={2};", ColoumsStr, TableName, TableRowId);
            }

            foreach (EbControl control in Controls)
            {
                if (control is EbControlContainer)
                {
                    EbControlContainer _control = (control as EbControlContainer);
                    _control.TableName = _control.TableName.IsNullOrEmpty() ? TableName: _control.TableName;
                    _control.TableRowId= (_control.TableRowId == 0 ) ? TableRowId: _control.TableRowId;
                    qry += _control.GetQuery();
                }
            }
            return qry;
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
    }
}
