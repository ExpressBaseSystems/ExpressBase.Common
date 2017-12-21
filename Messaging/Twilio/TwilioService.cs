using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace ExpressBase.Common.Messaging.Twilio
{
    public class TwilioService : ISMSService
    {
        private string accountSid { get; set; }
        private string authToken { get; set; }
        private PhoneNumber from { get; set; }

        private List<Uri> mediaUrl;

        private MessageResource messageResource { get; set; }

        public TwilioService(SMSConnection SMSConnection)
        {
            accountSid = SMSConnection.UserName;
            authToken = SMSConnection.Password;
            from = new PhoneNumber(SMSConnection.From);
        }

        public Dictionary<string, string> SentSMS(string sTo, string sFrom, string body)
        {
            Dictionary<string, string> msgStatus = new Dictionary<string, string>();
            try
            {
                TwilioClient.Init(accountSid, authToken);
                PhoneNumber to = new PhoneNumber(sTo);
                MessageResource msg = MessageResource.Create(to,
                                             from: from,
                                             body: body,
                                             statusCallback: new Uri("http://eb_roby_dev.expressbase.azurewebsites.net/smscallback?apikey=GATblcTqWNFI9ljZRWX-aUtidVYjJwoj")
                                             );
                msgStatus.Add("To", msg.To.ToString());
                msgStatus.Add("From", msg.From.ToString());
                msgStatus.Add("Uri", msg.Uri);
                msgStatus.Add("Body", msg.Body);
                msgStatus.Add("Status", msg.Status.ToString());
                msgStatus.Add("SentTime", msg.DateSent.ToString());
                msgStatus.Add("ErrorMessage", msg.ErrorMessage);
            }
            catch (Exception e)
            {
                msgStatus.Add("ErrorMessage", e.ToString());
            }
            
            return msgStatus;
        }
    }
}
