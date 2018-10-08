using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Text;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace ExpressBase.Common.Messaging.Twilio
{
    public class TwilioConnection :  ISMSConnection
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string From { get; set; }

        private string _accountSid { get; set; }
        private string _authToken { get; set; }
        private PhoneNumber _from { get; set; }

        private MessageResource _messageResource { get; set; }
        public SmsVendors ProviderName { get; set; }
        public ConPreferences Preference { get; set; }

        public EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMS; } }

        public int Id { get ; set; }
        public bool IsDefault { get ; set ; }
        public string NickName { get ; set; }

        public TwilioConnection(ISMSConnection SMSConnection)
        {
            _accountSid = SMSConnection.UserName;
            _authToken = SMSConnection.Password;
            
            ProviderName = SmsVendors.TWILIO;
        }

        public TwilioConnection()
        {
            ProviderName = SmsVendors.TWILIO;
        }
        public Dictionary<string, string> SendSMS(string sTo, string body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                TwilioClient.Init(UserName, Password);
                PhoneNumber to = new PhoneNumber(sTo);
                PhoneNumber _from = new PhoneNumber(From);
                MessageResource msg = MessageResource.Create(to, from: _from, body: body, statusCallback: new Uri("https://eb-test.info")
                                             );
                msgStatus = new Dictionary<string, string>
                {
                    { "To", msg.To.ToString() },
                    { "From", msg.From.ToString() },
                    { "Uri", msg.Uri },
                    { "Body", msg.Body },
                    { "Status", msg.Status.ToString() },
                    { "SentTime", msg.DateSent.ToString() },
                    { "ErrorMessage", msg.ErrorMessage }
                };
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                msgStatus.Add("ErrorMessage", e.ToString());
            }
            Console.WriteLine(" --- SMS msg" + EbSerializers.Json_Serialize(msgStatus));
            return msgStatus;
        }
    }
}
