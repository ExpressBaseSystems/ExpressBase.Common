using ExpressBase.Common.Data;
using System.Data.Common;

namespace ExpressBase.Common.Connections
{
    public class SMTPConnection : IEbConnection
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

        public EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMTP; } }
    }
}
