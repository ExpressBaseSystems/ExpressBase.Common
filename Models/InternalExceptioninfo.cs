using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Models
{
    public class InternalExceptioninfo
    {
        public const string ENTITY = "internal_exception_info";

        public string Type { get; set; }
        public string Message { get; set; }
        public string StackTrace { get; set; }

        public static InternalExceptioninfo From(Exception ex) => new InternalExceptioninfo
        {
            Type = ex?.GetType().FullName,
            Message = ex?.Message,
            StackTrace = ex?.StackTrace
        };
    }
}
