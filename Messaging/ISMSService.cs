using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Net.Mail;
using System.Text;

namespace ExpressBase.Common.Messaging
{
    public interface ISMSConnection 
    {     
        Dictionary<string, string> SendSMS(string To, string Body);
    }

    public interface IEmailConnection
    {
         bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname);
    }
}