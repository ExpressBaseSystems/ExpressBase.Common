using ExpressBase.Common.Extensions;
using ExpressBase.Common.Objects;
using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Objects;
using ServiceStack;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Objects
{
    public class EbObject
    {
        //public int Id { get; set; }

        //public string RefId { get; set; }

        //public EbObjectType EbObjectType { get; set; }

        [Description("Identity")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.EmailBuilder, BuilderType.DataSource)]
        [Required]
        public virtual string Name { get; set; }

        //public string ChangeLog { get; set; }

        public string VersionNumber { get; set; }

        public string Status { get; set; }

        public EbObject() { }

        public virtual void BeforeRedisSet() { }

        public virtual void AfterRedisGet(RedisClient Redis) { }

        public virtual void Init4Redis(IRedisClient redisclient, IServiceClient serviceclient) { }

        protected IRedisClient Redis { get; set; }

        protected IServiceClient ServiceStackClient { get; set; }

        public virtual string GetJsInitFunc() { return null; }

        public virtual string GetDesignHtml() { return "<div class='btn btn-default'> GetDesignHtml() not implemented </div>".RemoveCR().DoubleQuoted(); }

    }
}
