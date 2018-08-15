using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using ServiceStack.Redis;
using ExpressBase.Common.Objects.Attributes;
using ServiceStack;

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

        public override string LabelForeColor { get; set; }

        public override string LabelBackColor { get; set; }

        public override string HelpText { get; set; }

        public override string ForeColor { get; set; }

        public override string FontFamily { get; set; }

        public override float FontSize { get; set; }

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        public virtual bool IsContainer { get {
                return true; }
            private set { } }

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
