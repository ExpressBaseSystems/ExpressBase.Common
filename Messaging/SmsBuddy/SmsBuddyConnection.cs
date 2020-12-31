using ExpressBase.Common.Connections;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Net;
using System.Text;
using System.Web;

namespace ExpressBase.Common.Messaging
{
    public class SmsBuddyConnection : ISMSConnection
    {
        private EbSmsBuddyConfig Config { get; set; }

        private const string SMS_BARE_URL = "​http://thesmsbuddy.com/api/v1/sms/send?key={0}&type={1}&to={2}&sender={3}&message={4}&flash={5};";           
            
        //private string url;
        public SmsBuddyConnection(EbSmsBuddyConfig con)
        {
            Config = con;
        }

        public Dictionary<string, string> SendSMS(string To, string body)
        {
            Dictionary<string, string> msgStatus = null;
            string result;

            try
            {
                string msg = HttpUtility.UrlEncode(body);
                using (var wb = new WebClient())
                {
                    byte[] response = wb.UploadValues("http://thesmsbuddy.com/api/v1/sms/send?", new NameValueCollection()
                    {
                        {"key" , Config.ApiKey},
                        {"type", "1" },
                        {"to" , To},
                        {"sender", Config.From},
                        {"message" , msg} ,
                        {"flash", "0" }
                    });
                    result = System.Text.Encoding.UTF8.GetString(response);
                }

                var status = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(result)["status"];

                msgStatus = new Dictionary<string, string>
                {
                        {"ApiKey",  Config.ApiKey},
                        {"To" , To},
                        {"From" , Config.From},
                        {"Body" , body},
                        {"ConId", Config.Id.ToString() },
                        {"Status",  status},
                        {"Result", result}
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
