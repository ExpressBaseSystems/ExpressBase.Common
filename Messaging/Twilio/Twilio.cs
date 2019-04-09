using ExpressBase.Common.Connections;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;
using Twilio;
using Twilio.Rest.Api.V2010.Account;
using Twilio.Types;

namespace ExpressBase.Common.Messaging
{
    public class TwilioConnection : ISMSConnection
    {
        private EbTwilioConfig Config { get; set; }

        private const string SMS_BARE_URL = "https://api.twilio.com/2010-04-01/Accounts/{0}/Messages.json";

        private string url;
        public TwilioConnection(EbTwilioConfig con)
        {
            Config = con;
            url = string.Format(SMS_BARE_URL, Config.UserName);
        }

        public Dictionary<string, string> SendSMS(string To, string body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                var requestContent = new FormUrlEncodedContent(new[]
                {
                    new KeyValuePair<string, string>("From",Config.From),
                    new KeyValuePair<string, string>("To", To),
                    new KeyValuePair<string, string>("Body", body)
                  });

                using (var httpClient = new HttpClient())
                {
                    requestContent.Headers.Clear();
                    requestContent.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                    httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(
                                         System.Text.ASCIIEncoding.ASCII.GetBytes(
                                             string.Format("{0}:{1}", Config.UserName, Config.Password))));
                 
                    HttpResponseMessage response = httpClient.PostAsync(url, requestContent).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        msgStatus = new Dictionary<string, string>{
                                    { "To", To},
                                    { "From", Config.From },
                                    { "Uri", url },
                                    { "Body", body },
                                    { "Status", response.StatusCode.ToString() },
                                    { "SentTime", response.Headers.Date.ToString() },
                                    { "ErrorMessage", "" }
                                };
                    }
                }
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
namespace ExpressBase.Common.Messaging.Twilio
{
    public class TwilioConnection : ISMSConnection
    {
        private EbTwilioConfig Config { get; set; }

        private const string SMS_BARE_URL = "https://api.twilio.com/2010-04-01/Accounts/{0}/Messages.json";

        private string url;
        public TwilioConnection(EbTwilioConfig con)
        {
            Config = con;
            url = string.Format(SMS_BARE_URL, Config.UserName);
        }

        public Dictionary<string, string> SendSMS(string To, string body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                var requestContent = new FormUrlEncodedContent(new[]
                {
                    new KeyValuePair<string, string>("From",Config.From),
                    new KeyValuePair<string, string>("To", To),
                    new KeyValuePair<string, string>("Body", body)
                  });

                using (var httpClient = new HttpClient())
                {
                    requestContent.Headers.Clear();
                    requestContent.Headers.Add("Content-Type", "application/x-www-form-urlencoded");
                    httpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Basic", Convert.ToBase64String(
                                         System.Text.ASCIIEncoding.ASCII.GetBytes(
                                             string.Format("{0}:{1}", Config.UserName, Config.Password))));
                 
                    HttpResponseMessage response = httpClient.PostAsync(url, requestContent).Result;
                    if (response.IsSuccessStatusCode)
                    {
                        msgStatus = new Dictionary<string, string>{
                                    { "To", To},
                                    { "From", Config.From },
                                    { "Uri", url },
                                    { "Body", body },
                                    { "Status", response.StatusCode.ToString() },
                                    { "SentTime", response.Headers.Date.ToString() },
                                    { "ErrorMessage", "" }
                                };
                    }
                }
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
