using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class EbSmtp
    {
        public EbSmtp(EbSmtpConfig config)
        {
            try
            {
                if (config != null)
                {
                    Console.WriteLine("EbSmtp Config host,port,address - " + config.Host + "  " + config.Port + "  " + config.EmailAddress);
                    Config = config;
                    Client = new SmtpClient
                    {
                        Host = Config.Host,
                        Port = Config.Port,
                        Credentials = new NetworkCredential { UserName = Config.EmailAddress, Password = Config.Password },
                        EnableSsl = Config.EnableSsl
                    };
                }
                else
                    Console.WriteLine("ERROR: EbSmtp Config Error........config is null");
            }
            catch (Exception e)
            {
                Console.WriteLine("         ERROR: EbSmtp Config Error2 - " + e.Message + e.StackTrace);
                Console.WriteLine(Config.Host + "  " + Config.Port + "  " + Config.EmailAddress);
            }

        }

        public EbSmtpConfig Config { get; set; }

        private SmtpClient Client { get; set; }



        public bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname)
        {

            bool sentStatus;
            try
            {
                MailMessage mm = new MailMessage(Config.EmailAddress, to)
                {
                    Subject = subject,
                    IsBodyHtml = true,
                    Body = message

                };
                if (attachment != null)
                    mm.Attachments.Add(new Attachment(new MemoryStream(attachment), attachmentname + ".pdf"));
                if (cc != null)
                    if (cc.Length > 0)
                        foreach (string item in cc)
                            if (item != "") mm.CC.Add(item);
                if (bcc != null)
                    if (bcc.Length > 0)
                        foreach (string item in bcc)
                            if (item != "") mm.Bcc.Add(item);
                Client.Send(mm);
                sentStatus = true;
                Console.WriteLine("Smtp Send success" + to);
            }
            catch (Exception e)
            {
                Console.WriteLine("Smtp Send Exception" + e.Message + e.StackTrace);
                sentStatus = false;
            }
            return sentStatus;
        }
    }
}
