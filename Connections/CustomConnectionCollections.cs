using ExpressBase.Common.Data;
using ExpressBase.Common.Messaging;
using ExpressBase.Common.Messaging.ExpertTexting;
using ExpressBase.Common.Messaging.Slack;
using ExpressBase.Common.Messaging.Twilio;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public class EbSmsConCollection : List<ISMSConnection>
    {
        public EbSmsConCollection(SmsConfigCollection conf)
        {
            if (conf.Primary.Type == EbIntegrations.Twilio)
                Primary = new Messaging.TwilioConnection(conf.Primary as EbTwilioConfig);
            else if (conf.Primary.Type == EbIntegrations.ExpertTexting)
                Primary = new Messaging.ExpertTextingConnection(conf.Primary as EbExpertTextingConfig);
            if (conf.FallBack != null)
            {
                if (conf.FallBack.Type == EbIntegrations.Twilio)
                    FallBack = new Messaging.TwilioConnection(conf.FallBack as EbTwilioConfig);
                else if (conf.FallBack.Type == EbIntegrations.ExpertTexting)
                    FallBack = new Messaging.ExpertTextingConnection(conf.FallBack as EbExpertTextingConfig);
            }
        }

        public ISMSConnection Primary { get; set; }

        public ISMSConnection FallBack { get; set; }

        public Dictionary<string, string> SendSMS(string To, string Body)
        {
            Dictionary<string, string> resp = null;
            try
            {
                //  resp = this[2].SendSMS(To, Body);
                resp = Primary.SendSMS(To, Body);
                Console.WriteLine("SMS Send With Primary");
            }
            catch (Exception e)
            {
                try
                {
                    if (FallBack != null)
                    {
                        resp = FallBack.SendSMS(To, Body);
                        Console.WriteLine("SMS Send With Secondary");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("SMS Sending Failed: " + ex.StackTrace);
                }
            }
            return resp;
        }
    }

    public class ChatConCollection : List<IChatConnection>
    {
        public ChatConCollection(ChatConfigCollection conf)
        {
            if (conf.Default.Type == EbIntegrations.Slack)
                Default = new EbSlack(conf.Default as EbSlackConfig);
            //if (conf.Fallback != null)
            //{
            //    if (conf.Fallback.Type == EbIntegrations.Slack)
            //        FallBack.Add(new Messaging.Slack.Slack(conf.Fallback as EbSlackConfig));
            //}
        }
        public ChatConCollection() { }
        public IChatConnection Default { get; set; }

        public List<IChatConnection> FallBack { get; set; }

        public void Send(string channel, string Message)
        {
            try
            {
                Console.WriteLine("Inside Chat Sending to " + channel);
                if (Default != null)
                {
                    Default.Send(channel, Message);
                    Console.WriteLine("Chat Send With Default :");

                }
                else if (this.Capacity != 0)
                {
                    Console.WriteLine("Chat Send using First Element");
                    this[0].Send(channel, Message);
                }
                else
                    Console.WriteLine("Chat Connection Empty!");

            }
            catch (Exception e)
            {
                //try
                //{
                //    if (FallBack != null)
                //    {
                //        FallBack.Send(channel, Message, _infraConId);
                //        Console.WriteLine("Chat Send With FallBack : ");
                //    }
                //}
                //catch (Exception ex)
                //{
                //    Console.WriteLine("Chat Sending Failed: " + ex.StackTrace);
                //}
            }
        }
    }
    public class EbMailConCollection : List<IEmailConnection>
    {
        public EbMailConCollection(EmailConfigCollection conf)
        {
            if (conf.Primary != null)
                if (conf.Primary.Type == EbIntegrations.SMTP)
                    Primary = new EbSmtp(conf.Primary as EbSmtpConfig);
                else if (conf.Primary.Type == EbIntegrations.SendGrid)
                    Primary = new EbSendGridMail(conf.Primary as EbSendGridConfig);
            if (conf.FallBack != null)
                if (conf.FallBack.Type == EbIntegrations.SMTP)
                    FallBack = new EbSmtp(conf.FallBack as EbSmtpConfig);
                else if (conf.FallBack.Type == EbIntegrations.SendGrid)
                    FallBack = new EbSendGridMail(conf.FallBack as EbSendGridConfig);
        }

        public IEmailConnection Primary { get; set; }

        public IEmailConnection FallBack { get; set; }

        public bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname)
        {
            bool resp = false;
            try
            {
                Console.WriteLine("Inside Mail Sending to " + to);
                if (Primary != null)
                {
                    Primary.Send(to, subject, message, cc, bcc, attachment, attachmentname);
                    Console.WriteLine("Mail Send With Primary :");

                }
                else if (this.Capacity != 0)
                {
                    Console.WriteLine("Mail Send using First Element");
                    this[0].Send(to, subject, message, cc, bcc, attachment, attachmentname);
                }
                else
                    Console.WriteLine("Email Connection Empty!");

            }
            catch (Exception e)
            {
                try
                {
                    if (FallBack != null)
                    {
                        FallBack.Send(to, subject, message, cc, bcc, attachment, attachmentname);
                        Console.WriteLine("Mail Send With FallBack : ");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Mail Sending Failed: " + ex.StackTrace);
                }
            }
            return resp;
        }

    }
    public class EbMapConCollection : List<EbMaps>
    {
        public int DefaultConId { get; set; }
        private EbMaps _defaultmap = null;
        public EbMaps DefaultMapApi
        {
            get
            {
                if (_defaultmap == null)
                {
                    foreach (EbMaps item in this)
                    {
                        if (item.ConId == DefaultConId)
                            _defaultmap = item;
                    }
                }
                return _defaultmap;
            }
        }
        public string GetDefaultApikey()
        {
            return DefaultMapApi.Apikey;
        }
    }
}
