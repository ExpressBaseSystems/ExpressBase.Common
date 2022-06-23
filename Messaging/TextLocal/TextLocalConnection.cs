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
using System.Text.RegularExpressions;
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
                body += " -" + Config.BrandName;
                var status = string.Empty;
                IEnumerable<string> matches = Regex.Matches(To, @"[1-9]").OfType<Match>()
                 .Select(m => m.Groups[0].Value)
                 .Distinct();
                if (matches.Count() > 0)
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
                       // {"test" , "1"}
                    });
                        result = System.Text.Encoding.UTF8.GetString(response);
                    }
                    status = JsonConvert.DeserializeObject<Dictionary<string, dynamic>>(result)["status"];
                }
                else
                {
                    status = "FAILED";
                    result = "'To' is not a Valid number.";
                }
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
                Console.WriteLine("Exception:" + e.Message);
                if (!(msgStatus is null))
                    msgStatus.Add("ErrorMessage", e.Message);
            }
            Console.WriteLine(" --- SMS msg" + EbSerializers.Json_Serialize(msgStatus));
            return msgStatus;
        }
    }
}
