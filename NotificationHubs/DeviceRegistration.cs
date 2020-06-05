using Newtonsoft.Json;
using Newtonsoft.Json.Converters;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.NotificationHubs
{
    public enum MobilePlatform
    {
        // Summary:
        //     Windows Notification Service
        wns,

        // Summary:
        //     Apple Push Notifications Service
        apns,

        // Summary:
        //     Google Cloud Messaging
        gcm
    }

    public class DeviceRegistration
    {
        [JsonConverter(typeof(StringEnumConverter))]
        public MobilePlatform Platform { get; set; }

        public string Handle { get; set; }

        public List<string> Tags { get; set; }
    }

    public class Notification : DeviceRegistration
    {
        public string Content { get; set; }
    }
}
