using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.SqlProfiler
{
    public class Profiler
    {
        public int Max_id { get; set; }
        public decimal Max_exectime { get; set; }
        public int Min_id { get; set; }
        public decimal Min_exectime { get; set; }
        public int Cur_Max_id { get; set; }
        public decimal Cur_Max_exectime { get; set; }
        public int Cur_Min_id { get; set; }
        public decimal Cur_Min_exectime { get; set; }
        public int Total_count { get; set; }
        public int Current_count { get; set; }
        public int Month_count { get; set; }
    }
}