using ExpressBase.Common.Data;
using ExpressBase.Common.Messaging;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public class EbSmsConCollection : List<ISMSConnection>
    {
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

        //[OnDeserializing]
        //public void Process(StreamingContext context)
        //{            
        //    foreach (ISMSConnection con in this)
        //    {
        //        if (con.Preference == ConPreferences.PRIMARY)
        //            Primary = con;
        //        else if (con.Preference == ConPreferences.FALLBACK)
        //            FallBack = con;
        //    }
        //}
        public void Process()
        {
            foreach (ISMSConnection con in this)
            {
                if (con.Preference == ConPreferences.PRIMARY)
                    Primary = con;
                else if (con.Preference == ConPreferences.FALLBACK)
                    FallBack = con;
            }
        }
    }
    public class EbMailConCollection : List<EbEmail>
    {
        public EbEmail Primary { get; set; }

        public EbEmail FallBack { get; set; }

        public bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname)
        {
            bool resp =false;
            try
            {              
                resp = Primary.Send(to, subject,message,cc,bcc,attachment,attachmentname);
                Console.WriteLine("Mail Send With Primary");
            }
            catch (Exception e)
            {
                try
                {
                    if (FallBack != null)
                    {
                        resp = FallBack.Send(to, subject, message, cc, bcc, attachment, attachmentname);
                        Console.WriteLine("Mail Send With Secondary");
                    }
                }
                catch (Exception ex)
                {
                    Console.WriteLine("Mail Sending Failed: " + ex.StackTrace);
                }
            }
            return resp;
        }
        public void Process()
        {
            foreach (EbEmail con in this)
            {
                if (con.Preference == ConPreferences.PRIMARY)
                    Primary = con;
                else if (con.Preference == ConPreferences.FALLBACK)
                    FallBack = con;
            }
        }
    }
}
