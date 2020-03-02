using ExpressBase.Common.Constants;
using ExpressBase.Common.Extensions;
using ExpressBase.Common.Objects;
using ExpressBase.Common.Objects.Attributes;
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
        [EnableInBuilder(BuilderType.WebForm, BuilderType.FilterDialog, BuilderType.EmailBuilder, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.Report, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.SqlFunctions, BuilderType.UserControl, BuilderType.ApiBuilder, BuilderType.DVBuilder, BuilderType.Calendar,BuilderType.MobilePage, BuilderType.SqlJob, BuilderType.DashBoard)]

        [EbRequired]
        [Unique]
        [regexCheck]
        [PropertyGroup(PGConstants.CORE)]
        [InputMask("[a-z][a-z0-9]*(_[a-z0-9]+)*")]
        [PropertyPriority(100)]
        [HideForUser]
        [ReservedValues("review", "Review")]
        public virtual string Name { get; set; }

        public EbObject() { }

        public virtual string RefId { get; set; }

        [PropertyGroup(PGConstants.CORE)]
        [EbRequired]
        [Unique]
        [HideForUser]
        [PropertyPriority(99)]
        public virtual string DisplayName { get; set; }

        [PropertyGroup(PGConstants.HELP)]
        public virtual string Description { get; set; }

        public virtual string VersionNumber { get; set; }

        public virtual string Status { get; set; }

        // methods

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

        public virtual List<string> DiscoverRelatedRefids() { return null; }

        public virtual void BeforeSave(IServiceClient serviceClient, IRedisClient redis) { }

    }

    public interface IEBRootObject
    {
        //[EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        //string RefId { get; set; }

        //[Description("Core")]
        //[EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        //[EbRequired]
        //[Unique]
        //string DisplayName { get; set; }

        //[EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        //string Description { get; set; }

        ////public string ChangeLog { get; set; }

        //[EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        //string VersionNumber { get; set; }

        //[EnableInBuilder(BuilderType.DisplayBlock, BuilderType.DataReader, BuilderType.DataWriter, BuilderType.SqlFunctions, BuilderType.FilterDialog, BuilderType.WebForm, BuilderType.MobileForm, BuilderType.UserControl, BuilderType.Report, BuilderType.DVBuilder, BuilderType.EmailBuilder, BuilderType.BotForm, BuilderType.SmsBuilder, BuilderType.ApiBuilder)]
        //string Status { get; set; }
    }
}