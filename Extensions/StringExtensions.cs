﻿using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;

namespace ExpressBase.Common.Extensions
{
    public static class StringExtensions
    {
        public static string SingleQuoted(this string str)
        {
            return "'" + str + "'";
        }

        public static string DoubleQuoted(this string str)
        {
            return '"' + str + '"';
        }

        public static string GraveAccentQuoted(this string str)
        {
            return '`' + str + '`';
        }

        public static string RemoveCR(this string str)
        {
            return str.Replace("\r\n", string.Empty).Replace("\n", string.Empty);
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

        public static string ToBase64(this string plainText)
        {
            return System.Convert.ToBase64String(System.Text.Encoding.UTF8.GetBytes(plainText));
        }

        public static string FromBase64(this string base64EncodedData)
        {
            return System.Text.Encoding.UTF8.GetString(System.Convert.FromBase64String(base64EncodedData));
        }

        public static string Truncate(this string str, int length)
        {
            if (length == 0 || str.Length <= length)
                return str;
            else
                return str.Substring(0, length) + "...";
        }

        #region RefId related string operations

        public static EbObjectType GetEbObjectType(this string RefId)
        {
            return EbObjectTypes.Get(Convert.ToInt32(RefId.Split("-")[2]));
        }

        #endregion

        public static TEnum ToEnum<TEnum>(this string value, bool ignoreCase = false) where TEnum : struct
        {
            TEnum tenumResult;
            Enum.TryParse<TEnum>(value, ignoreCase, out tenumResult);
            return tenumResult;
        }

        public static string RemoveSpecialCharacters(this string str)
        {
            StringBuilder sb = new StringBuilder();
            foreach (char c in str)
            {
                if ((c >= '0' && c <= '9') || (c >= 'A' && c <= 'Z') || (c >= 'a' && c <= 'z'))
                {
                    sb.Append(c);
                }
            }
            return sb.ToString();
        }
    }
}
