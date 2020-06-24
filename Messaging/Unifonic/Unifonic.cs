using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Net;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Text;
using Twilio.Jwt.AccessToken;

namespace ExpressBase.Common.Messaging
{
    public class UnifonicConnection : ISMSConnection
    {
        private EbUnifonicConfig Config { get; set; }

        private const string Unifonic_base_url = "http://api.unifonic.com/wrapper/sendSMS.php";

        private string url;
        public WebClient Client { get; set; }
        public NameValueCollection Data { get; set; }

        public UnifonicConnection(EbUnifonicConfig con)
        {
            Data = new NameValueCollection();
            Client = new WebClient();
            Config = con;
            Data["userid"] = Config.UserName;
            Data["password"] = Config.Password;
            Data["sender"] = Config.From;

        }

        public Dictionary<string, string> SendSMS(string To, string Body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                Data["msg"] = Body;
                Data["to"] = To;
                var response = Client.UploadValues(Unifonic_base_url, "POST", Data);
                string responseInString = Encoding.UTF8.GetString(response);
                Console.WriteLine(responseInString);
                if (response != null)
                {
                    msgStatus = new Dictionary<string, string>{
                                    { "To", To},
                                    { "From", Config.From },
                                    { "Uri", url },
                                    { "Body", Body },
                                    { "ErrorMessage", "" },
                                    { "ConId", Config.Id.ToString() },
                                    { "Result", responseInString}
                                };
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
