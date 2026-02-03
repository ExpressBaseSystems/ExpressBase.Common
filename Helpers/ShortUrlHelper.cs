using ExpressBase.Common.Constants;
using ServiceStack.Redis;
using System;
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

        public static string CreateShortUrl(string originalUrl, RedisClient Redis, TimeSpan expiry)
        {
            if (expiry == null)
            {
                expiry = new TimeSpan(1, 0, 0);
            }

            long id = Redis.Get<long>(RedisKeyPrefixConstants.EbShortUrlCounter);
            if (id == 0)
            {
                id = 1; // Starting point for IDs
            }

            string base62Id = Encode(id);
            string secret = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_URL_HASH_SALT) ??
                Environment.GetEnvironmentVariable(EnvironmentConstants.EB_EMAIL_PASSWORD);

            using (HMACSHA256 hmac = new HMACSHA256(Encoding.UTF8.GetBytes(secret)))
            {
                byte[] hash = hmac.ComputeHash(Encoding.UTF8.GetBytes(base62Id));
                string hashvalue = Convert.ToBase64String(hash).Replace("+", "").Replace("/", "").Substring(0, 8);

                Redis.Set(RedisKeyPrefixConstants.EbShortUrlCounter, id + 1);
                Redis.Set(string.Format(RedisKeyPrefixConstants.EbShortUrlItem, id), $"{originalUrl}&s={id}", expiry);

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
            string secret = Environment.GetEnvironmentVariable(EnvironmentConstants.EB_URL_HASH_SALT) ??
                Environment.GetEnvironmentVariable(EnvironmentConstants.EB_EMAIL_PASSWORD);
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
    }
}
