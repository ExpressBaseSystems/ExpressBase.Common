﻿using ExpressBase.Common.EbServiceStack.ReqNRes;
using ServiceStack;
using System.Collections.Generic;
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

        [DataMember(Order = 4)]
        public string NotificationId { get; set; }

        [DataMember(Order = 5)]
        public int NotifyUserId { get; set; }
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
    public class NotifySubscriptionRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToSubscriptionId { get; set; }
    }
	
    [DataContract]
    public class NotifySingleSubscriptionRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToSubscriptionId { get; set; }
    }

	 [DataContract]
    public class NotifyUserAuthIdRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }

        [DataMember(Order = 3)]
        public string To_UserAuthId { get; set; }

    }

    [DataContract]
    public class NotifyAllRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string Selector { get; set; }

        [DataMember(Order = 1)]
        public object Msg { get; set; }
    }

    public class NotificationToDBRequest : EbServiceStackAuthRequest, IReturn<NotificationToDBResponse>
    {
        public object Notification { get; set; }

        public string NotificationId { get; set; }

        public int NotifyUserId { get; set; }
    }

    public class NotificationToDBResponse : IEbSSResponse
    {
        [DataMember(Order = 1)]
        public ResponseStatus ResponseStatus { get; set; }
    }

    [DataContract]
    public class NotifyUsersRequest : EbServiceStackAuthRequest, IReturn<NotifyResponse>
    {
        [DataMember(Order = 0)]
        public string[] ToChannel { get; set; }

        [DataMember(Order = 1)]
        public string Selector { get; set; }

        [DataMember(Order = 2)]
        public object Msg { get; set; }

        [DataMember(Order = 3)]
        public string ToUserAuthId { get; set; }

        [DataMember(Order = 4)]
        public string NotificationId { get; set; }

        [DataMember(Order = 5)]
        public Dictionary<int, string> UsersDetails { get; set; }

    }

	public class CheckSubscriptionId_IsActiveRequest : EbServiceStackAuthRequest, IReturn<CheckSubscriptionId_IsActiveResponse>
	{
		[DataMember(Order = 0)]
		public string ToSubscriptionId { get; set; }

	}
	public class CheckSubscriptionId_IsActiveResponse 
	{
		public bool IsActive { get; set; }
	}

	public class GetSubscriptionId_InfoRequest : EbServiceStackAuthRequest, IReturn<GetSubscriptionId_InfoResponse>
	{
		[DataMember(Order = 0)]
		public string ToSubscriptionId { get; set; }

	}
	public class GetSubscriptionId_InfoResponse
	{
		public string AuthId { get; set; }
		public string UserId { get; set; }
		public string SolnId { get; set; }
		public string Wc { get; set; }
	}

	public class NotificationInfo
    {
        public string Title { get; set; }

        public string Link { get; set; }

        public string NotificationId { get; set; }

        public string Duration { get; set; }

        public string CreatedDate { get; set; }
    }
}

