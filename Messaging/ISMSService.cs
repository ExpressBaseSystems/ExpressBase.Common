using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Messaging
{
    public interface ISMSService
    {
        Dictionary<string, string> SentSMS(string to, string from, string body);
    }
}