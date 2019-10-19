using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Net;
using System.Text;

namespace ExpressBase.Common.Messaging.Slack
{
    class EbSlack: IChatConnection
    {
        public int InfraConId { get; set; }
        public WebClient Client { get; set; }
        public NameValueCollection Data { get; set; }

        public EbSlack(EbSlackConfig Conf)
        {
            Data = new NameValueCollection();
            Client = new WebClient();
            Data["token"] = Conf.OAuthAccessToken;
            Data["as_user"] = "true";
        }

        public void Send(string channel,  string Message)
        {
            Data["text"] = Message;
            Data["channel"] = channel;
            var response = Client.UploadValues("https://slack.com/api/chat.postMessage", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            Console.WriteLine(responseInString);
        }
    }
}
