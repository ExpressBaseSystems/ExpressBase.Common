using ExpressBase.Common.EbServiceStack.ReqNRes;
using ServiceStack;
using System.Runtime.Serialization;

namespace ExpressBase.Common.ServerEvents_Artifacts
{
    [DataContract]
    public class NotifyUserIdRequest : EbServiceStackRequest, IReturn<bool>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public string Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToUserAuthId { get; set; }

    }

    [DataContract]
    public class NotifyChannelRequest : EbServiceStackRequest, IReturn<bool>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public string Msg { get; set; }
    }

    [DataContract]
    public class NotifySubsribtionRequest : EbServiceStackRequest, IReturn<bool>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public string Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToSubId { get; set; }
    }

    [DataContract]
    public class NotifyAllRequest : EbServiceStackRequest, IReturn<bool>
    {
        [DataMember(Order = 0)]
        public string Selector { get; set; }

        [DataMember(Order = 1)]
        public string Msg { get; set; }
    }
}

