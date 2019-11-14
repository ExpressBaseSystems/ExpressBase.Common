using ExpressBase.Common.Constants;
using ExpressBase.Common.Data;
using System;
using System.Collections.Generic;
using System.Text;
using ExpressBase.Security;

namespace ExpressBase.Common.Extensions
{
    public static class ApiExtensions
    {
        public static List<Param> Merge(this List<Param> to, List<Param> from)
        {
            foreach (Param p1 in from)
            {
                if (to.Find(x => x.Name == p1.Name) == null)
                    to.Add(p1);
            }
            return to;
        }

        public static string B2S(this string b64)
        {
            byte[] data = Convert.FromBase64String(b64);
            return Encoding.UTF8.GetString(data);
        }

        public static string[] GetAccessIds(this User UserObject, int LocationId = 1)
        {
            List<string> ObjIds = new List<string>();
            foreach (string perm in UserObject.Permissions)
            {
                int id = Convert.ToInt32(perm.Split(CharConstants.DASH)[2]);
                int locid = Convert.ToInt32(perm.Split(CharConstants.COLON)[1]);
                if ((LocationId == locid || locid == -1) && !ObjIds.Contains(id.ToString()))
                    ObjIds.Add(id.ToString());
            }
            return ObjIds.ToArray();
        }
    }
}
