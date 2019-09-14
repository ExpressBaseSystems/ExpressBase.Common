using System;
using System.Collections.Generic;
using System.Text;
using ServiceStack.Stripe.Types;


namespace ExpressBase.Common.ProductionDBManager
{
    public class Eb_FileChanges
    {
        public string Id { get; set; }

        public string FunctionHeader { get; set; }

        public string Vendor { get; set; }

        public string FilePath { get; set; }

        public string MD5 { get; set; }

        public bool NewItem { get; set; }

    }
    

    public class Eb_Changes_Log
    {
        public string Solution { get; set; }

        public string TenantName { get; set; }

        public string TenantEmail { get; set; }

        public string DBName { get; set; }

        public string Vendor { get; set; }

        public DateTime Last_Modified { get; set; }
    }
}
