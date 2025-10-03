using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Models
{
    public class InternalExceptionView
    {
        public bool IsDevelopment { get; set; }
        public string RequestPath { get; set; }
        public InternalExceptioninfo Exception { get; set; }
        public string TicketId { get; set; }
        public bool TicketExpiredOrMissing { get; set; }
    }
}
