using ExpressBase.Common.Extensions;
using ExpressBase.Common.Objects;
using ExpressBase.Common.Objects.Attributes;
using ExpressBase.Objects;
using ServiceStack;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.ComponentModel;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Objects
{
    public class EbObject
    {
        //public int Id { get; set; }

        public string RefId { get; set; }

        //public EbObjectType EbObjectType { get; set; }

        [Description("Identity")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.EmailBuilder, BuilderType.DataReader,BuilderType.DataWriter, BuilderType.Report, BuilderType.BotForm, BuilderType.SmsBuilder)]
        [EbRequired]
        [Unique]
        [regexCheck]
        //[InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        public virtual string Name { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm)]
        public virtual string UIchangeFns { get; set; }  

        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.EmailBuilder, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.Report, BuilderType.SmsBuilder)]
        public string Description { get; set; }

        //public string ChangeLog { get; set; }

        public string VersionNumber { get; set; }

        public string Status { get; set; }

        public EbObject() { }

        public virtual void BeforeRedisSet() { }

        public virtual void AfterRedisGet(RedisClient Redis) { }

        public virtual void AfterRedisGet(RedisClient Redis, IServiceClient client) { }

        public virtual void Init4Redis(IRedisClient redisclient, IServiceClient serviceclient) { }

        protected IRedisClient Redis { get; set; }

        protected IServiceClient ServiceStackClient { get; set; }

        public virtual string GetJsInitFunc() { return null; }

        public virtual string GetDesignHtml() { return "<div class='btn btn-default'> GetDesignHtml() not implemented </div>".RemoveCR().DoubleQuoted(); }

        public virtual string GetBareHtml() { return "<div class='btn btn-default'> GetBareHtml() not implemented </div>".RemoveCR(); }

        //public virtual OrderedDictionary DiscoverRelatedObjects(IServiceClient ServiceClient, OrderedDictionary obj_dict) { return new OrderedDictionary(); }

        public virtual void ReplaceRefid(Dictionary<string, string> RefidMap) { }

        public virtual string DiscoverRelatedRefids() { return ""; }

    }
}
