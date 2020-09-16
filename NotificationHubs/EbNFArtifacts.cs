using Newtonsoft.Json;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace ExpressBase.Common.NotificationHubs
{
    public enum PNSPlatforms
    {
        GCM = 1,
        APNS = 2,
        WNS = 3,
        ALL = 4
    }

    public enum EbAppVendors
    {
        ExpressBase = 1,
        MoveOn = 2,
        kudumbaShree = 3
    }

    public class DeviceRegistration
    {
        public PNSPlatforms Platform { get; set; }

        public string Handle { get; set; }

        public List<string> Tags { get; set; }

        public EbAppVendors Vendor { set; get; }
    }

    public class EbNFRegisterResponse
    {
        public string Message { set; get; }

        public bool Status { set; get; }

        public EbNFRegisterResponse() { }

        public EbNFRegisterResponse(string message)
        {
            Message = message;
        }
    }

    public class EbNFRequest : DeviceRegistration
    {
        public string PayLoad { set; get; }
    }

    [DataContract]
    public class EbNFResponse
    {
        [DataMember(Order = 1)]
        public bool Status { set; get; }

        [DataMember(Order = 2)]
        public string Message { set; get; }

        public EbNFResponse() { }

        public EbNFResponse(string message)
        {
            Message = message;
        }
    }

    public class EbNFDataTemplate 
    {

    }

    public class EbNFData
    {
        public string Title { set; get; }

        public string Message { set; get; }
    }

    public class EbNFDataTemplateAndroid : EbNFDataTemplate
    {
        [JsonProperty("data")]
        public EbNFData Data { set; get; }
    }
}
