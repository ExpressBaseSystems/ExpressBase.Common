using ExpressBase.Common.Data;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;

namespace ExpressBase.Common.Connections
{ 
    public class SMSConnection : IEbConnection
    {
        public string ProviderName { get; set; }

        public string UserName { get; set; }

        public string Password { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.SMS; } }
    }
}
