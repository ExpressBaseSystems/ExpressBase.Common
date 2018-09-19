using ExpressBase.Common.Data;
using System.Data.Common;

namespace ExpressBase.Common.Connections
{
    public class SMTPConnection : IEbConnection
    {
        public string ProviderName { get; set; }

        public string Host { get; set; }

        public int Port { get; set; }

        public string EmailAddress { get; set; }

        public string Password { get; set; }

        public bool EnableSsl { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMTP; } }
    }
}
