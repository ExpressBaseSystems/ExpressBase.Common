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

        private string _uname { get; set; }
        private string _pwd { get; set; }
        private string _apiKey { get; set; }

        private const string URL_TEXT = "https://www.experttexting.com/exptapi/exptsms.asmx/SendSMS?Userid={0}&pwd={1}&APIKEY={2}&FROM=DEFAULT&To={3}&MSG={4}";

        public ExpertTextingConnection(ISMSConnection SMSConnection)
        {
            _uname = SMSConnection.UserName;
            _pwd = SMSConnection.Password;
            _apiKey = "2qz5bdjn789uopj";//SMSConnection.ApiKey;
            ProviderName = SmsVendors.EXPERTTEXTING;
        }
        public ExpertTextingConnection()
        {
            ProviderName = SmsVendors.EXPERTTEXTING; 
        }
        public Dictionary<string, string> SendSMS(string sTo, string body)
        {
            Dictionary<string, string> msgStatus = null;
            
            string url = string.Format(URL_TEXT, _uname, _pwd, _apiKey, sTo, body);
            HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
            var x = request.GetResponse();
            return msgStatus;
        }
    }
}
