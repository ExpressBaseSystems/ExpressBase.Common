using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Objects
{
    public static class Extensions
    {
        public static string Quoted(this string str)
        {
            return "'" + str + "'";
        }

        public static string DoubleQuoted(this string str)
        {
            return '"' + str + '"';
        }

        public static string RemoveCR(this string str)
        {
            return str.Replace("\r\n", string.Empty);
        }
    }
}
