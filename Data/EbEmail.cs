using ExpressBase.Common.Connections;
using ExpressBase.Common.Messaging;
using SendGrid;
using SendGrid.Helpers.Mail;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class EbSmtp : IEmailConnection
    {
        public EbSmtp(EbSmtpConfig config)
        {
            try
            {
                if (config != null)
                {
                    Config = config;
                    Client = new SmtpClient
                    {
                        Host = Config.Host,
                        Port = Config.Port,
                        UseDefaultCredentials = false,
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
                    mm.Attachments.Add(new System.Net.Mail.Attachment(new MemoryStream(attachment), attachmentname));
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

    public class EbSendGridMail : IEmailConnection
    {
        public EbSendGridMail(EbSendGridConfig config)
        {
            try
            {
                if (config != null)
                {
                    Config = config;
                    Client = new SendGridClient(config.ApiKey);
                }
                else
                    Console.WriteLine("ERROR: EbSmtp Config Error........config is null");
            }
            catch (Exception e)
            {
                Console.WriteLine("         ERROR: EbSmtp Config Error2 - " + e.Message + e.StackTrace);
            }

        }

        public EbSendGridConfig Config { get; set; }

        private SendGridClient Client { get; set; }
        public bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname)
        {
            bool sentStatus;
            try
            {

                var msg = new SendGridMessage
                {
                    From = new EmailAddress(Config.EmailAddress, Config.Name),
                    Subject = subject,
                    PlainTextContent = message
                };
                msg.AddTo(new EmailAddress(to, "User"));
                foreach (string i in cc)
                {
                    msg.AddBcc(new EmailAddress(i));
                }
                foreach (string i in bcc)
                {
                    msg.AddCc(new EmailAddress(i));
                }
                if (attachment != null)
                {
                    var file = Convert.ToBase64String(attachment);
                    msg.AddAttachment(attachmentname, file);
                }
                Client.SendEmailAsync(msg);
                Console.WriteLine("SendGrid Send success" + to);
                sentStatus = true;
            }
            catch (Exception e)
            {
                Console.WriteLine("SendGrid Send Exception" + e.Message + e.StackTrace);
                sentStatus = false;
                throw e;
            }
            return sentStatus;
        }
    }
}
