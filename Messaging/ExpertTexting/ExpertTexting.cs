using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace ExpressBase.Common.Messaging
{
    public class ExpertTextingConnection : ISMSConnection
    {
        public EbExpertTextingConfig Config { get; set; }
        private const string SMS_URL_BARE = "https://www.experttexting.com/exptapi/exptsms.asmx/SendSMS?Userid={0}&pwd={1}&APIKEY={2}&FROM=DEFAULT&To={3}&MSG={4}";
        public ExpertTextingConnection(EbExpertTextingConfig conf)
        {
            Config = conf;
        }

        public Dictionary<string, string> SendSMS(string To, string body)
        {
            Dictionary<string, string> msgStatus = null;
            try
            {
                string status = string.Empty;
                string result = string.Empty;
                string url = string.Format(SMS_URL_BARE, Config.UserName, Config.Password, Config.ApiKey, To, body);

                IEnumerable<string> matches = Regex.Matches(To, @"[1-9]").OfType<Match>()
                 .Select(m => m.Groups[0].Value)
                 .Distinct();
                if (matches.Count() > 0)
                {
                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                    WebResponse resp = request.GetResponse();

                    WebHeaderCollection header = resp.Headers;
                    Encoding encoding = ASCIIEncoding.ASCII;
                    string responseText;
                    using (System.IO.StreamReader reader = new System.IO.StreamReader(resp.GetResponseStream(), encoding))
                    {
                        responseText = reader.ReadToEnd();
                    }
                    XmlDocument Doc = new XmlDocument();
                    Doc.LoadXml(responseText);
                    XmlNode node = Doc.GetElementsByTagName("ExpertTextAPI").Item(0);
                    foreach (XmlNode item in node.ChildNodes)
                    {
                        if ((item).NodeType == XmlNodeType.Element)
                        {
                            if (item.Name == "Status")
                                if (item.FirstChild.Value == "SUCCESS")
                                {
                                    status = item.FirstChild.Value;
                                }
                                else
                                {
                                    status = "FAILED";
                                    result = item.FirstChild.Value;
                                }
                        }
                    }
                }
                else
                {
                    status = "FAILED";
                    result = "'To' is not a Valid number.";
                }
                msgStatus = new Dictionary<string, string>
                {
                    { "To", To},
                    { "From", Config.From },
                    { "Uri", url },
                    { "Body", body },
                    { "Status", status.ToLower() },
                   // { "SentTime", msg.DateSent.ToString() },
                    // { "ErrorMessage", msg.ErrorMessage }
                    { "ConId", Config.Id.ToString() },
                    { "Result", result }
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
//namespace ExpressBase.Common.Messaging.ExpertTexting
//{
//    public class ExpertTextingConnection : ISMSConnection
//    {
//        public EbExpertTextingConfig Config { get; set; }
//        private const string SMS_URL_BARE = "https://www.experttexting.com/exptapi/exptsms.asmx/SendSMS?Userid={0}&pwd={1}&APIKEY={2}&FROM=DEFAULT&To={3}&MSG={4}";
//        public ExpertTextingConnection(EbExpertTextingConfig conf)
//        {
//            Config = conf;
//        }

//        public Dictionary<string, string> SendSMS(string To, string body)
//        {
//            Dictionary<string, string> msgStatus = null;
//            try
//            {
//                string url = string.Format(SMS_URL_BARE, Config.UserName, Config.Password, Config.ApiKey, To, body);
//                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
//                var resp = request.GetResponse();
//                msgStatus = new Dictionary<string, string>
//                {
//                    { "To", To},
//                    { "From", Config.From },
//                    { "Uri", url },
//                    { "Body", body },
//                    { "Status", resp.ToString() }
//                   // { "SentTime", msg.DateSent.ToString() },
//                   // { "ErrorMessage", msg.ErrorMessage }
//                };
//            }
//            catch (Exception e)
//            {
//                Console.WriteLine("Exception:" + e.ToString());
//                msgStatus.Add("ErrorMessage", e.ToString());
//            }
//            Console.WriteLine(" --- SMS msg" + EbSerializers.Json_Serialize(msgStatus));
//            return msgStatus;
//        }
//    }
//}
