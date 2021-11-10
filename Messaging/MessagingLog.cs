using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Messaging
{
    public class SentStatus
    {
        public string To { get; set; }

        public string From { get; set; }

        public string MessageId { get; set; }

        public string Body { get; set; }

        public string Status { get; set; }

        public DateTime SentTime { get; set; }

        public DateTime ReceivedTime { get; set; }

        public string ErrorMessage { get; set; }

        public string Uri { get; set; }

        public string Result { get; set; }

        public int ConId { get; set; }

        public string Subject { get; set; }

        public string AttachmentName { get; set; }

        public EmailRecepients Recepients { get; set; }
        //[DataMember(Order = 1)]
        //public string SolnId { get; set; }

        //[DataMember(Order = 2)]
        //public int UserId { get; set; }

        //[DataMember(Order = 3)]
        //public string UserAuthId { get; set; }

        //[DataMember(Order = 4)]
        //public string WhichConsole { get; set; }

    }

    public class EmailRecepients
    {
        public string To { get; set; }

        public string Cc { get; set; }

        public string Bcc { get; set; }

        public string Replyto { get; set; }
    }
}
