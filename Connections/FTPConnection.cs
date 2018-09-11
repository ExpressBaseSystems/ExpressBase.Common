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

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.FTP; } } 
    }
}
