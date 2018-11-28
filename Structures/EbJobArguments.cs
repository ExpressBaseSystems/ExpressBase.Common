using ExpressBase.Common.Data;
using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Structures
{
     public class EbJobArguments
    {
        public int ObjId { get; set; }

        public List<Param> Params { get; set; }

        public string SolnId { get; set; }

        public int UserId { get; set; }

        public string UserAuthId { get; set; }

        public string ToUserIds { get; set; }

        public string ToUserGroupIds { get; set; }

    }
}
