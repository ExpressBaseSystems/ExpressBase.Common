﻿using ExpressBase.Common.EbServiceStack.ReqNRes;
using ServiceStack;
using System.Runtime.Serialization;

namespace ExpressBase.Common.ServerEvents_Artifacts
{
    [DataContract]
    public class NotifyUserIdRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToUserAuthId { get; set; }

    }

    public class NotifyResponse : IEbSSResponse
    {
        public ResponseStatus ResponseStatus { get; set; }
    }

    [DataContract]
    public class NotifyChannelRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }
    }

    [DataContract]
    public class NotifySubsribtionRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToSubId { get; set; }
    }

    [DataContract]
    public class NotifyAllRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string Selector { get; set; }

        [DataMember(Order = 1)]
        public object Msg { get; set; }
    }
}

