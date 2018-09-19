using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.Net;
using System.Net.Mail;
using System.Text;

namespace ExpressBase.Common.Data
{
    public class EbSmtp
    {
        private SmtpClient _client = new SmtpClient();
        private string _from;
        public EbSmtp(SMTPConnection con)
        {
            _client.Host = con.Host;
            _client.Port = con.Port;
            _client.Credentials = new NetworkCredential { UserName = con.EmailAddress, Password = con.Password };
            _client.EnableSsl = con.EnableSsl;
            _from = con.EmailAddress;
        }

        public bool Send(string to, string subject, string message)
        {
            bool sentStatus;
            try
            {
                MailMessage mm = new MailMessage(_from, to)
                {
                    Subject = subject,
                    IsBodyHtml = true,
                    Body = message

                };
                //mm.Attachments.Add(new Attachment(new MemoryStream(request.AttachmentReport)/*Memorystream*/, request.AttachmentName + ".pdf"));
                //if (!request.Cc.IsEmpty())
                //    mm.CC.Add(request.Cc);
                //if (!request.Bcc.IsEmpty())
                //    mm.Bcc.Add(request.Bcc);
                _client.Send(mm);
                sentStatus = true;
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
