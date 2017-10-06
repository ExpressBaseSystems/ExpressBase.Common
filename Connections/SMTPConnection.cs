namespace ExpressBase.Common.Connections
{
    public class SMTPConnection
    {
        public string ProviderName { get; set; }

        public string Smtp { get; set; }

        public int Port { get; set; }

        public string NickName { get; set; }

        public string EmailAddress { get; set; }

        public string Password { get; set; }
    }
}
