using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Messaging
{
    public interface ISMSConnection
    {
        Dictionary<string, string> SendSMS(string to, string from, string body);
    }
}