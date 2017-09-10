using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public static class StringExtensions
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

        public static string ToMD5Hash(this string str)
        {
            var md5 = MD5.Create();

            //compute hash from the bytes of text
            byte[] result = md5.ComputeHash(ASCIIEncoding.ASCII.GetBytes(str));

            StringBuilder strBuilder = new StringBuilder();
            for (int i = 0; i < result.Length; i++)
            {
                //change it into 2 hexadecimal digits for each byte
                strBuilder.Append(result[i].ToString("x2"));
            }

            return strBuilder.ToString();
        }
    }
}
