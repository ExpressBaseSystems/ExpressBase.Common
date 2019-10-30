using ExpressBase.Common.Connections;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.Net;
using System.Reflection;
using System.Text;

namespace ExpressBase.Common.Messaging.Slack
{
    class EbSlack : IChatConnection
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

        public void Send(string channel, string Message)
        {
            Data["text"] = Message;
            Data["channel"] = channel;
            var response = Client.UploadValues("https://slack.com/api/chat.postMessage", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            Console.WriteLine(responseInString);
        }
         public void SendAttachment(string channel, string Message, byte[] bytea)
        {
            Data["channels"] = channel;
            Data["text"] = Message;
            Client.QueryString = Data;
            string boundary = "------------------------" + DateTime.Now.Ticks.ToString("x");
            Client.Headers.Add("Content-Type", "multipart/form-data; boundary=" + boundary);
            var fileData = Client.Encoding.GetString(bytea);
            var package = string.Format("--{0}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"{1}\"\r\nContent-Type: {2}\r\n\r\n{3}\r\n--{0}--\r\n", boundary, "Testing.txt", "multipart/form-data", fileData);

            var nfile = Client.Encoding.GetBytes(package);
            byte[] responseBytes = Client.UploadFile(
                    "https://slack.com/api/files.upload",
                    package
            );
            String responseString = Encoding.UTF8.GetString(responseBytes);
            Console.WriteLine(responseString);
        }

        public List<string> GetAllUsers()
        {
            List<string> Userlist = new List<string>();
            var response = Client.UploadValues("https://slack.com/api/User.list", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            SlackUserJsonResponse JsonData = JsonConvert.DeserializeObject<SlackUserJsonResponse>(responseInString);

            foreach (object member in JsonData.members)
            {
                PropertyInfo info = member.GetType().GetProperty("name");
                string ee = info.GetValue(member).ToString();
                Userlist.Add(ee);
            }
            return (Userlist);
        }

        public List<string> GetAllGroups()
        {
            List<string> Channellist = new List<string>();
            var response = Client.UploadValues("https://slack.com/api/channels.list", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            SlackChannelJsonResponse JsonData = JsonConvert.DeserializeObject<SlackChannelJsonResponse>(responseInString);

            foreach (object member in JsonData.channels)
            {
                PropertyInfo info = member.GetType().GetProperty("name");
                string ee = info.GetValue(member).ToString();
                Channellist.Add(ee);
            }
            return (Channellist);
        }

        internal class SlackUserJsonResponse
        {
            public memberobject[] members { get; set; }
            public SlackUserJsonResponse()
            {
                new memberobject();
            }
        }

        internal class SlackChannelJsonResponse
        {
            public memberobject[] channels { get; set; }
            public SlackChannelJsonResponse()
            {
                new memberobject();
            }
        }

        internal class memberobject
        {
            public dynamic id { get; set; }
            public dynamic team_id { get; set; }
            public dynamic name { get; set; }
        }
    }
}
    
