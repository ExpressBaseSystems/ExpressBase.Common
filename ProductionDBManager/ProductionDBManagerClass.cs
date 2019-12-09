using System;
using System.Collections.Generic;
using System.Text;
using ServiceStack.Stripe.Types;


namespace ExpressBase.Common.ProductionDBManager
{
    public class Eb_FileDetails
    {
        public string Id { get; set; }

        public string FileHeader { get; set; }

        public DBManagerType Type { get; set; }

        public string FileType { get; set; }

        public string Vendor { get; set; }

        public string FilePath { get; set; }

        public string Content { get; set; }

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

    public class Eb_TableFieldChanges
    {
        public string Data_type { get; set; }

        public string Column_default { get; set; }

        public string Constraint_type { get; set; }

        public string Constraint_name { get; set; }
    }
    
    public class Eb_TableFieldChangesList
    {
        public string Table_name { get; set; }

        public Dictionary<string, List<Eb_TableFieldChanges>> Fields { get; set; }

        public Dictionary<string, string> Indexs { get; set; }
    }

    public enum DBManagerType
    {
        Function,
        Table,
        Procedure
    }
    
}
