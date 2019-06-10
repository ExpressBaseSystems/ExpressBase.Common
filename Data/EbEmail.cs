using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class EbEmail : IEbConnection
    {
        public int Id { get; set; }

        public bool IsDefault { get; set; }

        public string NickName { get; set; }

        public string ProviderName { get; set; }

        public string Host { get; set; }

        public int Port { get; set; }

        public string EmailAddress { get; set; }

        public string Password { get; set; }

        public bool EnableSsl { get; set; }

        public ConPreferences Preference { get; set; }

        public EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMTP; } }

        private SmtpClient _client { get; set; }

        public bool Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname)
        {
            _client = new SmtpClient();
            _client.Host = Host;
            _client.Port = Port;
            _client.Credentials = new NetworkCredential { UserName = EmailAddress, Password = Password };
            _client.EnableSsl = EnableSsl;

            bool sentStatus;
            try
            {
                MailMessage mm = new MailMessage(EmailAddress, to)
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
                _client.Send(mm);
                sentStatus = true;
                Console.WriteLine("Smtp Send success" + to);
            }
            catch (Exception e)
            {
                Console.WriteLine("Smtp Send Exception" + e.Message);
                sentStatus = false;
            }
            return sentStatus;
        }
    }

    public class EbSmtp
    {
        public EbSmtp(EbSmtpConfig config)
        {
            try
            {
                Config = config;
                Client = new SmtpClient();
                Client.Host = Config.Host;
                Client.Port = Config.Port;
                Client.Credentials = new NetworkCredential { UserName = Config.EmailAddress, Password = Config.Password };
                Client.EnableSsl = Config.EnableSsl;
            }
            catch (Exception e)
            {
                Console.WriteLine("ERROR: EbSmtp Config Error");
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
                if (cc!=null)
                    if(cc.Length > 0)
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
                Console.WriteLine("Smtp Send Exception" + e.Message);
                sentStatus = false;
            }
            return sentStatus;
        }
    }
}
