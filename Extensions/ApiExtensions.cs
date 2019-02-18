using ExpressBase.Common.Data;
using System;
using System.Collections.Generic;
using System.Text;

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
    }
}
