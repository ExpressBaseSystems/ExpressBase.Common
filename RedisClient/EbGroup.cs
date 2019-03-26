using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public class EbGroup
    {
        public string Name { get; set; }
        public string Pattern { get; set; }

        public EbGroup(string textgroup, string textpattern)
        {
            Name = textgroup;
            Pattern = textpattern;
        }
    }

    public class FindValClass
    {
        public string Key { set; get; }
        public object Obj { set; get; }
        public string Type { set; get; }
        public long Idltm { get; set; }
    }

    public class EbRedisLogs
    {
        public string Operation { get; set; }
        public string Key { get; set; }
        public int LogId { get; set; }
        public int ChangedBy { get; set; }
        public DateTime ChangedAt { get; set; }
    }
    public class EbRedisLogValues
    {
        public object Prev_val { get; set; }
        public object New_val { get; set; }
    }

    public class EbRedisGroupDetails
    {
        public string Refid { get; set; }
        public string Disp_Name { get; set; }
        public Int32 Obj_Type { get; set; }
        public string Version { get; set; }
    }
}
