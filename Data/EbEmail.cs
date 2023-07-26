using ExpressBase.Common.Connections;
using ExpressBase.Common.Constants;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Messaging;
using ExpressBase.Common.ServiceClients;
using S22.Imap;
using S22.Pop3;
using SendGrid;
using SendGrid.Helpers.Mail;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Net;
using System.Net.Mail;
using System.Text;
using Attachment = System.Net.Mail.Attachment;

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

        public SentStatus Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname, string replyto)
        {
            bool status;
            string responseMesage = string.Empty;
            try
            {
                MailMessage mm = new MailMessage(Config.EmailAddress, to)
                {
                    Subject = subject,
                    IsBodyHtml = true,
                    Body = message,
                };

                if (!string.IsNullOrWhiteSpace(replyto))
                    mm.ReplyToList.Add(replyto);
                if (attachment != null)
                    mm.Attachments.Add(new System.Net.Mail.Attachment(new MemoryStream(attachment), attachmentname));
                if (cc?.Length > 0)
                    foreach (string item in cc)
                        if (item != "") mm.CC.Add(item);
                if (bcc?.Length > 0)
                    foreach (string item in bcc)
                        if (item != "") mm.Bcc.Add(item);

                Client.Send(mm);
                status = true;
                responseMesage = "Smtp Send success";
            }
            catch (Exception e)
            {
                responseMesage = "Smtp Send Exception : Port" + " - " + Config.Port + " :  " + e.Message + e.StackTrace;
                status = false;
            }
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(message);
            string message64 = System.Convert.ToBase64String(plainTextBytes);
            SentStatus SentStatus = new SentStatus
            {
                Status = status.ToString(),
                To = to,
                From = Config.EmailAddress,
                Body = message64,
                ConId = Config.Id,
                Result = responseMesage,
                Recepients = new EmailRecepients
                {
                    To = to,
                    Cc = (cc == null) ? "" : string.Join(",", cc),
                    Bcc = (bcc == null) ? "" : string.Join(",", bcc),
                    Replyto = (replyto == null) ? "" : replyto,
                },
                Subject = subject,
                AttachmentName = attachmentname
            };
            return SentStatus;
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
        public SentStatus Send(string to, string subject, string message, string[] cc, string[] bcc, byte[] attachment, string attachmentname, string replyto)
        {
            bool status;
            string responseMesage = string.Empty;
            try
            {
                SendGridMessage msg = new SendGridMessage
                {
                    From = new EmailAddress(Config.EmailAddress, Config.Name),
                    Subject = subject,
                    PlainTextContent = message,
                    ReplyTo = new EmailAddress(replyto)
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
                responseMesage = "SendGrid Send success";
                status = true;
            }
            catch (Exception e)
            {
                responseMesage = "SendGrid Send Exception" + e.Message + e.StackTrace;
                status = false;
            }
            var plainTextBytes = Encoding.UTF8.GetBytes(message);
            string message64 = Convert.ToBase64String(plainTextBytes);
            SentStatus SentStatus = new SentStatus
            {
                Status = status.ToString(),
                To = to,
                From = Config.EmailAddress,
                Body = message64,
                ConId = Config.Id,
                Result = responseMesage,
                Recepients = new EmailRecepients
                {
                    To = to,
                    Cc = (cc == null) ? "" : string.Join(",", cc),
                    Bcc = (bcc == null) ? "" : string.Join(",", bcc),
                    Replyto = (replyto == null) ? "" : replyto,
                },
                Subject = subject,
                AttachmentName = attachmentname
            };
            return SentStatus;
        }
    }

    public class EbImap : IEmailRetrieveConnection
    {
        public EbImapConfig Config { get; set; }

        public int ConId { get; set; }

        uint MaxUid = 0;

        int uidsCount = 0;

        uint LastSyncedUid = 0;

        public EbImap(EbImapConfig config)
        {
            try
            {
                if (config != null)
                {
                    this.ConId = config.Id;
                    this.Config = config;
                }
                else
                    Console.WriteLine("ERROR: Imap Config Error, config is null");
            }
            catch (Exception e)
            {
                Console.WriteLine("ERROR: Imap Config Error2 - " + e.Message + e.StackTrace);
                Console.WriteLine(Config.Host + "  " + Config.Port + "  " + Config.EmailAddress);
            }
        }

        public RetrieverResponse Retrieve(Service service, DateTime DefaultSyncDate, EbStaticFileClient FileClient, string SolnId, bool isMq, bool SubmitAttachmentAsMultipleForm)
        {
            RetrieverResponse response = new RetrieverResponse();

            using (ImapClient Client = new ImapClient(Config.Host, Config.Port, Config.EmailAddress, Config.Password, S22.Imap.AuthMethod.Login, true))
            {
                try
                {
                    LastSyncedUid = service.Redis.Get<uint>("MailRetrieve_LastsyncedId_" + this.ConId);

                    if (LastSyncedUid == 0)// if value is not in redis
                    {
                        IEnumerable<uint> x = Client.Search(SearchCondition.SentSince(DefaultSyncDate));
                        uidsCount = x.Count();
                        if (uidsCount > 0)
                            LastSyncedUid = x.Min();
                    }

                    uidsCount = (uidsCount == 0) ? Client.Search(SearchCondition.GreaterThan(LastSyncedUid)).Where(a => a != MaxUid)
                        .Where(a => a != LastSyncedUid).Count() : uidsCount;

                    if (uidsCount > 0)
                    {
                        MaxUid = LastSyncedUid;

                        for (int i = 0; i <= uidsCount / 50; i++)
                        {
                            IEnumerable<uint> uids = Client.Search(SearchCondition.GreaterThan(MaxUid).And(SearchCondition.LessThan(MaxUid + 51)));

                            MaxUid = uids.Count() > 0 ? uids.Max() : MaxUid;

                            IEnumerable<MailMessage> messages = Client.GetMessages(uids);

                            foreach (MailMessage m in messages)
                            {
                                List<int> _attachments = new List<int>();
                                List<string> attachment_names = new List<string>(); ;

                                foreach (System.Net.Mail.Attachment _a in m.Attachments)
                                {
                                    int fileId = UploadAttachment(_a, service, SolnId, isMq);

                                    _attachments.Add(fileId);
                                    if (SubmitAttachmentAsMultipleForm)
                                    {
                                        response.RetrieverMessages.Add(new RetrieverMessage
                                        {
                                            Message = m,
                                            Attachemnts = _attachments,
                                            AttachmentsName = _a.Name
                                        });

                                        _attachments = new List<int>();
                                    }
                                    else
                                    {
                                        attachment_names.Add(_a.Name);
                                    }

                                }

                                if (!SubmitAttachmentAsMultipleForm || m.Attachments.Count == 0)
                                {
                                    response.RetrieverMessages.Add(new RetrieverMessage
                                    {
                                        Message = m,
                                        Attachemnts = _attachments,
                                        AttachmentsName = string.Join(',', attachment_names)
                                    });
                                }
                            }

                        }

                        service.Redis.Set("MailRetrieve_LastsyncedId_" + this.ConId, MaxUid);
                    }
                }
                catch (S22.Imap.InvalidCredentialsException)
                {
                    Console.WriteLine("The server rejected the supplied credentials.");
                }
            }
            return response;
        }

        public int UploadAttachment(Attachment _a, Service service, string SolnId, bool isMq)
        {
            FileUploadResponse resp;

            _a.ContentStream.Seek(0, SeekOrigin.Begin);
            byte[] myFileContent = new byte[_a.ContentStream.Length];
            _a.ContentStream.Read(myFileContent, 0, myFileContent.Length);

            FileMeta meta = new FileMeta
            {
                FileName = _a.Name,
                FileType = _a.Name.Split('.').Last(),
                Length = myFileContent.Length,
                FileCategory = Enums.EbFileCategory.File,
                MetaDataDictionary = new Dictionary<String, List<string>>(),
            };

            if (isMq)
            {
                FileUploadRequest request = new FileUploadRequest
                {
                    FileByte = myFileContent,
                    FileDetails = meta
                };

                request.SolnId = SolnId;

                resp = service.Gateway.Send<FileUploadResponse>(request);
            }
            else
            {
                FileUploadInternalRequest request = new FileUploadInternalRequest
                {
                    FileByte = myFileContent,
                    FileDetails = meta
                };
                request.SolnId = SolnId;

                resp = service.Gateway.Send<FileUploadResponse>(request);

            }

            return resp.FileRefId;
        }
    }

    public class EbPOP3 : IEmailRetrieveConnection
    {
        public EbPop3Config Config { get; set; }

        public int ConId { get; set; }

        public EbPOP3(EbPop3Config config)
        {
            try
            {
                if (config != null)
                {
                    this.ConId = config.Id;
                    this.Config = config;
                }

                else
                    Console.WriteLine("ERROR: POP3 Config Error, config is null");
            }
            catch (Exception e)
            {
                Console.WriteLine("ERROR: POP3 Config Error2 - " + e.Message + e.StackTrace);
                Console.WriteLine(Config.Host + "  " + Config.Port + "  " + Config.EmailAddress);
            }
        }

        public RetrieverResponse Retrieve(Service service, DateTime DefaultSyncDate, EbStaticFileClient FileClient, string SolnId, bool isMq, bool SubmitAttachmentAsMultipleForm)
        {
            RetrieverResponse response = new RetrieverResponse();
            using (Pop3Client Client = new Pop3Client(Config.Host, Config.Port, Config.EmailAddress, Config.Password, S22.Pop3.AuthMethod.Login, true))
            {
                try
                {
                    uint[] u = Client.GetMessageNumbers();
                    MailMessage[] messages = Client.GetMessages(new uint[] { 1 }, S22.Pop3.FetchOptions.Normal);
                }
                catch (S22.Pop3.InvalidCredentialsException)
                {
                    Console.WriteLine("The server rejected the supplied credentials.");
                }
            }
            return response;
        }
    }
}
