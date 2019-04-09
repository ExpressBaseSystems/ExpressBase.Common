using ExpressBase.Common.Data;
using ExpressBase.Common.Messaging;
using ExpressBase.Common.Messaging.ExpertTexting;
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
                    Console.WriteLine("SMS Sending Failed: " + e.StackTrace);
                }
            }
            return resp;
        }
    }
    public class EbMailConCollection : List<EbSmtp>
    {
        public EbMailConCollection(EmailConfigCollection conf)
        {
            if (conf.Primary != null)
                Primary = new EbSmtp(conf.Primary);
            if (conf.FallBack != null)
                FallBack = new EbSmtp(conf.FallBack);
        }

        public EbSmtp Primary { get; set; }

        public EbSmtp FallBack { get; set; }

        public bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname)
        {
            bool resp = false;
            try
            {
                Console.WriteLine("Inside Mail Sending to " + to);
                if (Primary != null)
                {
                    resp = Primary.Send(to, subject, message, cc, bcc, attachment, attachmentname);
                    Console.WriteLine("Mail Send With Primary :" + Primary.Config.EmailAddress);

                }
                else if (this.Capacity != 0)
                {
                    Console.WriteLine("Mail Send using First Element" + this[0].Config.EmailAddress);
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
                        resp = FallBack.Send(to, subject, message, cc, bcc, attachment, attachmentname);
                        Console.WriteLine("Mail Send With FallBack : " + FallBack.Config.EmailAddress);
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
}
