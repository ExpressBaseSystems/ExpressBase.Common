using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.SqlProfiler
{
    public class EbExecutionLogs
    {
        public int Id { get; set; }

        public string Rows { get; set; }

        public decimal Exec_time { get; set; }

        public int Created_by { get; set; }

        public string Username { get; set; }

        public DateTime Created_at { get; set; }

        public string Refid { get; set; }

        public List<JsonParams> Params { get; set; }

    }
}