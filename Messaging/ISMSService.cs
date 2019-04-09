using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Messaging
{
    public interface ISMSConnection 
    {     
        Dictionary<string, string> SendSMS(string To, string Body);
    }
}