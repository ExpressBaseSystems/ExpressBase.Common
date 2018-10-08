using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Net;
using System.Text;

namespace ExpressBase.Common.Messaging.ExpertTexting
{
    public class ExpertTextingConnection : ISMSConnection
    {
        public EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMS; } }

        public int Id { get; set; }

        public bool IsDefault { get; set; }

        public string NickName { get; set; }

        public SmsVendors ProviderName { get; set; }

        public ConPreferences Preference { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public string From { get; set; }

        public string ApiKey { get; set; }

        private const string URL_TEXT = "https://www.experttexting.com/exptapi/exptsms.asmx/SendSMS?Userid={0}&pwd={1}&APIKEY={2}&FROM=DEFAULT&To={3}&MSG={4}";

      
        public ExpertTextingConnection()
        {
            ProviderName = SmsVendors.EXPERTTEXTING; 
        }
        public Dictionary<string, string> SendSMS(string sTo, string body)
        {
            Dictionary<string, string> msgStatus = null;
            string url = string.Format(URL_TEXT, UserName, Password, ApiKey, sTo, body);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            var x = request.GetResponse();
            return msgStatus;
        }
    }
}
