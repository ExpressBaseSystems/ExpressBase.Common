using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Messaging
{
    public interface ISMSConnection  : IEbConnection
    {
        SmsVendors ProviderName { get; set; }

        string UserName { get; set; }

        string Password { get; set; }

        string From { get; set; }

        ConPreferences Preference { get; set; }

        Dictionary<string, string> SendSMS(string To, string Body);
    }
}