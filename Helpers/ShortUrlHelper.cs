using ExpressBase.Common.Constants;
using ExpressBase.Common.Data;
using ExpressBase.Common.Extensions;
using Microsoft.AspNetCore.WebUtilities;
using Newtonsoft.Json;
using ServiceStack.Redis;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace ExpressBase.Common.Helpers
{
    public static class ShortUrlHelper
    {
        private const string chars = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";

        private static string Encode(long value)
        {
            if (value == 0) return chars[0].ToString();

            var result = new StringBuilder();
            while (value > 0)
            {
                result.Insert(0, chars[(int)(value % 62)]);
                value /= 62;
            }
            return result.ToString();
        }

        private static long Decode(string input)
        {
            long result = 0;
            foreach (char c in input)
            {
                result = result * 62 + chars.IndexOf(c);
            }
            return result;
        }

        // Add a static object for locking
        private static readonly object idLock = new object();

        public static string CreateShortUrl(string RefId, string parameters, int mode, RedisClient Redis, TimeSpan expiry)
        {
            if (expiry == null)
            {
                expiry = new TimeSpan(1, 0, 0);
            }

            long id = 0;

            lock (idLock)
            {
                id = Redis.Get<long>(RedisKeyPrefixConstants.EbShortUrlCounter);
                Redis.Set(RedisKeyPrefixConstants.EbShortUrlCounter, id + 1);
            }

            if (id == 0)
            {
                id = 1; // Starting point for IDs
            }

            string base62Id = Encode(id);
            string secret = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_URL_HASH_SALT);

            using (HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(secret)))
            {
                byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(base62Id));
                string hashvalue = Convert.ToBase64String(hash).Replace("+", "").Replace("/", "").Substring(0, 8);

                string longUrl = $"/PublicForm?id={RefId}&p={parameters}&m={mode}&s={id}";

                Redis.Set(string.Format(RedisKeyPrefixConstants.EbShortUrlItem, id), longUrl, expiry);

                return $"/tiny/{base62Id}.{hashvalue}";
            }
        }

        public static string GetOriginalUrl(string shortUrlId, RedisClient Redis)
        {
            string[] parts = shortUrlId.Split('.');
            if (parts.Length != 2)
            {
                return "/StatusCode/404?m=invalid_format"; // Invalid format
            }
            string base62Id = parts[0];
            string providedHash = parts[1];
            long id = Decode(base62Id);
            string secret = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_URL_HASH_SALT);
            using (HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(secret)))
            {
                byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(base62Id));
                string expectedHash = Convert.ToBase64String(hash).Replace("+", "").Replace("/", "").Substring(0, 8);
                if (expectedHash != providedHash)
                {
                    return "/StatusCode/404?m=invalid_url"; // Hash mismatch, invalid URL
                }
                string originalUrl = Redis.Get<string>(string.Format(RedisKeyPrefixConstants.EbShortUrlItem, id));
                if (originalUrl == null)
                    originalUrl = "/StatusCode/404?m=not_found";
                return originalUrl;
            }
        }

        public static void MarkShortUrlProcessed(long shortUrlId, RedisClient Redis)
        {
            try
            {
                string originalUrl = Redis.Get<string>(string.Format(RedisKeyPrefixConstants.EbShortUrlItem, shortUrlId));
                if (originalUrl != null)
                {
                    Redis.Set(string.Format(RedisKeyPrefixConstants.EbShortUrlItem, shortUrlId), $"/StatusCode/703", new TimeSpan(1, 0, 0));
                }
            }
            catch (Exception ex)
            {

            }
        }

        public static bool CheckEditPermissionForAnonymUser(int userId, string refId, int dataId, long shortUrlId, RedisClient Redis)
        {
            if (userId > 1 || dataId <= 0) return true;
            if (shortUrlId == 0) return false;

            try
            {
                string originalUrl = Redis.Get<string>(string.Format(RedisKeyPrefixConstants.EbShortUrlItem, shortUrlId));
                if (string.IsNullOrEmpty(originalUrl) || !originalUrl.Contains($"/PublicForm?id={refId}&p="))
                    return false;

                string query = originalUrl.Substring(originalUrl.IndexOf('?'));
                Dictionary<string, string> query_params = QueryHelpers.ParseQuery(query).ToDictionary(x => x.Key, x => x.Value.ToString());

                if (query_params["s"] != shortUrlId.ToString())
                    return false;

                List<Param> ob = JsonConvert.DeserializeObject<List<Param>>(query_params["p"].FromBase64());
                if (ob.Count == 1 && ob[0].Name == "id")
                {
                    if (ob[0].Value == dataId.ToString())
                        return true;
                }
            }
            catch (Exception ex) { }
            return false;
        }
    }
}
