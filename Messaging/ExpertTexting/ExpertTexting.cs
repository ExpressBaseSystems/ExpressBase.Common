using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Net;
using System.Text;

namespace ExpressBase.Common.Messaging.ExpertTexting
{
    public class ExpertTextingConnection : ISMSConnection
    {
        public string UserName { get; set; }

        public string Password { get; set; }

        public string From { get; set; }

        public string ApiKey { get; set; }

        public int Id { get; set; }

        public bool IsDefault { get; set; }

        public string NickName { get; set; }

        public SmsVendors ProviderName { get; set; }

        public ConPreferences Preference { get; set; }

        public EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMS; } }

        private const string SMS_URL = "https://www.experttexting.com/exptapi/exptsms.asmx/SendSMS?Userid={0}&pwd={1}&APIKEY={2}&FROM=DEFAULT&To={3}&MSG={4}";

        public ExpertTextingConnection()
        {
            ProviderName = SmsVendors.EXPERTTEXTING;
        }

        public Dictionary<string, string> SendSMS(string To, string body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                string url = string.Format(SMS_URL, UserName, Password, ApiKey, To, body);
                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                var resp = request.GetResponse();
                msgStatus = new Dictionary<string, string>
                {
                    { "To", To},
                    { "From", From },
                    { "Uri", url },
                    { "Body", body },
                    { "Status", resp.ToString() }
                   // { "SentTime", msg.DateSent.ToString() },
                   // { "ErrorMessage", msg.ErrorMessage }
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
