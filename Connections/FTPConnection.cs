using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Connections
{
    public class EbFTPConnection : IEbConnection
    {
        public string Host { get; set; }

        public string Username { get; set; }

        public string Password { get; set; }

        public EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.FTP; } }

        public int Id { get; set; }
        public bool IsDefault { get; set; }
        public string NickName { get; set; }

    }
}
