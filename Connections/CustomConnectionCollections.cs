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
            Primary = this[1];
            FallBack = this[0];
            Dictionary<string, string> resp = null;
            try
            {
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

        [OnSerializing]
        public void Process(StreamingContext context)
        {
            Primary = this[0];
            FallBack = this[1];
            //foreach (ISMSConnection con in this)
            //{
            // if (con.Preference == ConPreferences.PRIMARY)
            //Primary = con;
            //else if (con.Preference == ConPreferences.FALLBACK)
            //FallBack = con;
            //}
        }
    }
}
