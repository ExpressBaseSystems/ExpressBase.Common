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
    // Base class for all eb Components
    public class EbObject
    {

        [Description("Identity")]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.EmailBuilder, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.Report, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.SqlFunctions, BuilderType.UserControl, BuilderType.ApiBuilder)]
        [EbRequired]
        [Unique]
        [regexCheck]
        [InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        public virtual string Name { get; set; }

        [HideInPropertyGrid]
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.BotForm, BuilderType.UserControl)]
        public virtual string UIchangeFns { get; set; }

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

    public interface IEBRootObject
    {
        //int Id { get; set; }

        [EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        string RefId { get; set; }

        [EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        string Name { get; set; }

        //public EbObjectType EbObjectType { get; set; }

        [Description("Identity")]
        [EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        [EbRequired]
        [Unique]
        string DisplayName { get; set; }

        [EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        string Description { get; set; }

        //public string ChangeLog { get; set; }

        [EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        string VersionNumber { get; set; }

        [EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        string Status { get; set; }
    }
}
