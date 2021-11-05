using System.Collections.Generic;
namespace ExpressBase.Common.Messaging
{
    public interface ISMSConnection
    {
        Dictionary<string, string> SendSMS(string To, string Body);
    }

    public interface IEmailConnection
    {
        SentStatus Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname, string replyto);
    }
}