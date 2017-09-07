using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Reflection;
using ServiceStack.Redis;
using ExpressBase.Common.Objects.Attributes;

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

    public class EbControlContainer : EbControl
    {
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog)]
        //[HideInPropertyGrid]
        public virtual List<EbControl> Controls { get; set; }

        [HideInPropertyGrid]
        //public EbTable Table { get; set; }

        public EbControlContainer()
        {
            this.Controls = new List<EbControl>();
        }

        public override void Init4Redis(IRedisClient redisclient, ServiceStack.IServiceClient serviceclient)
        {
            base.Redis = redisclient;
            base.ServiceStackClient = serviceclient;
        }

        public override string GetHtml() { return string.Empty; }
    }
}
