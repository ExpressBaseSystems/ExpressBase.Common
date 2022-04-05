using ExpressBase.Common.ServiceClients;
using ServiceStack;
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

    public interface IEmailRetrieveConnection
    {
        int ConId { get; set; }

        RetrieverResponse Retrieve(Service service, System.DateTime DefaultSyncDate, EbStaticFileClient FileClient, string SolnId, bool isMq, bool SubmitAttachmentAsMultipleForm);
    }

    public class RetrieverMessage
    {
        public System.Net.Mail.MailMessage Message { get; set; }

        public List<int> Attachemnts { get; set; }
    }

    public class RetrieverResponse
    {
        public List<RetrieverMessage> RetrieverMessages { get; set; }

        public RetrieverResponse()
        {
            this.RetrieverMessages = new List<RetrieverMessage>();
        }
    }
}