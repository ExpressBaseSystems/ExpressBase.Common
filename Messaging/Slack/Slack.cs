using ExpressBase.Common.Connections;
using ExpressBase.Common.Helpers;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Collections.Specialized;
using System.IO;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common.Messaging.Slack
{
    class EbSlack : IChatConnection
    {
        public int InfraConId { get; set; }
        public WebClient Client { get; set; }
        public NameValueCollection Data { get; set; }
        private EbSlackConfig Config { get; set; }
        private MultipartFormDataContent multiForm { get; set; }
        private HttpClient client { get; set; }

        public EbSlack(EbSlackConfig Conf)
        {
            Data = new NameValueCollection();
            Client = new WebClient();
            multiForm = new MultipartFormDataContent();
            client = new HttpClient();
            Config = Conf;
            Data["token"] = Conf.OAuthAccessToken;
            Data["as_user"] = "true";
            multiForm.Add(new StringContent(Config.OAuthAccessToken), "token");
        }

        public void Send(string channel, string Message, byte[] bytea, string AttachmentName)
        {
            if (bytea != null)
                AsyncHelper.RunSync(() => SendAttachmentAsync(channel, Message, bytea, AttachmentName));
            else
                SendMessage(channel, Message);
        }


        public void SendMessage(string channel, string Message)
        {
            Data["text"] = Message;
            Data["channel"] = channel;
            var response = Client.UploadValues("https://slack.com/api/chat.postMessage", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            Console.WriteLine(responseInString);
        }
        public async Task SendAttachmentAsync(string channel, string Message, byte[] bytea, string AttachmentName)
        {
            try
            {
                
                //FileStream str = File.OpenRead(@"\430831-most-popular-relaxing-desktop-background-1920x1080.jpg");
                //byte[] fBytes = new byte[str.Length];
                //str.Read(fBytes, 0, fBytes.Length);
                //str.Close();

                //Data["channels"] = channel;
                //Data["text"] = Message;
                //Client.QueryString = Data;
                //string boundary = "------------------------" + DateTime.Now.Ticks.ToString("x");
                //Client.Headers.Add("Content-Type", "multipart/form-data; boundary=" + boundary);
                //string fileData = Client.Encoding.GetString(bytea);
                //string package = string.Format("--{0}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"{1}\"\r\nContent-Type: {1}\r\n\r\n{3}\r\n--{0}--\r\n", boundary, AttachmentName, ".pdf", fileData);

                //var nfile = Client.Encoding.GetBytes(package);

                //string encodedfile = Encoding.ASCII.GetString(nfile);

                //string url = "https://slack.com/api/files.upload?token=" + Config.OAuthAccessToken + "&content=" + nfile + "&channels=" + channel + "&pretty=1";

                //byte[] responseBytes = Client.UploadData(url, nfile);

                //String responseString = Encoding.UTF8.GetString(responseBytes);
                //Console.WriteLine(responseString);               

                

                var ms = new System.IO.MemoryStream();
                ms.Write(bytea, 0, bytea.Length);
                ms.Position = 0;

                multiForm.Add(new StringContent(channel), "channels");
                multiForm.Add(new StringContent(Message), "initial_comment");
                multiForm.Add(new StreamContent(ms), "file", AttachmentName);

              
                var url = "https://slack.com/api/files.upload";
                var response = await client.PostAsync(url, multiForm);

                var responseJson = await response.Content.ReadAsStringAsync();
                
                SlackFileResponse fileResponse =
                    JsonConvert.DeserializeObject<SlackFileResponse>(responseJson);

                if (fileResponse.ok == false)
                {
                    throw new Exception(
                        "failed to upload message: " + fileResponse.error
                    );
                }
                else
                {
                    Console.WriteLine(
                            "Uploaded new file with id: " + fileResponse.file.id
                    );
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("SendAttachement Slack Exception" + e.Message + e.StackTrace);
            }


        }
        
        public Dictionary<int, string> GetAllUsers()
        {
            Dictionary<int, string> Userlist = new Dictionary<int, string>();
            int count = 0;
            var response = Client.UploadValues("https://slack.com/api/users.list", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            SlackUserJsonResponse JsonData = JsonConvert.DeserializeObject<SlackUserJsonResponse>(responseInString);

            foreach (object member in JsonData.members)
            {
                PropertyInfo info = member.GetType().GetProperty("name");
                string ee = info.GetValue(member).ToString();
                Userlist[count++] = ee;
            }
            return (Userlist);
        }

        public Dictionary<int, string> GetAllGroups()
        {
            Dictionary<int, string> Channellist = new Dictionary<int, string>();
            int count = 0;
            var response = Client.UploadValues("https://slack.com/api/channels.list", "POST", Data);
            string responseInString = Encoding.UTF8.GetString(response);
            SlackChannelJsonResponse JsonData = JsonConvert.DeserializeObject<SlackChannelJsonResponse>(responseInString);

            foreach (object member in JsonData.channels)
            {
                PropertyInfo info = member.GetType().GetProperty("name");
                string ee = info.GetValue(member).ToString();
                Channellist[count++] = ee;
            }
            return (Channellist);
        }

        internal class SlackFileResponse
        {
            public bool ok { get; set; }
            public String error { get; set; }
            public SlackFile file { get; set; }
        }
        internal class SlackFile
        {
            public String id { get; set; }
            public String name { get; set; }
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

