using ExpressBase.Common.Connections;
using Newtonsoft.Json;
using ServiceStack.Configuration;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using System.Web;

namespace ExpressBase.Common.Messaging
{
    public class TextLocalConnection : ISMSConnection
    {
        private EbTextLocalConfig Config { get; set; }

        private const string SMS_BARE_URL = "https://api.textlocal.in/send/?apikey={0}&numbers={1}&message={2}&sender={3};";

        //private string url;
        public TextLocalConnection(EbTextLocalConfig con)
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
                    byte[] response = wb.UploadValues("https://api.textlocal.in/send/", new NameValueCollection()
                    {
                        {"apikey" , Config.ApiKey},
                        {"numbers" , To},
                        {"message" , msg},
                        {"sender" , Config.From}
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
