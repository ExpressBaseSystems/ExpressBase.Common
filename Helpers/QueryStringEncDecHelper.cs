using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Web;

namespace ExpressBase.Common.Helpers
{
    /// <summary>
    /// Builds/parses a single encrypted query parameter:
    ///   ?{paramName}=UrlEncode( AesEncryptionHelper.EncryptString(key, json(obj)) )
    /// Decrypt reverses to a typed object.
    /// </summary>
    public static class QueryStringEncDecHelper
    {

        public static string ToEncryptedString<T>(
            T obj,
            string base64CurrentKey,
            JsonSerializerSettings jsonSettings = null
        )
        {
            if (obj == null) throw new ArgumentNullException(nameof(obj));
            if (string.IsNullOrWhiteSpace(base64CurrentKey)) throw new ArgumentNullException(nameof(base64CurrentKey));

            var json = JsonConvert.SerializeObject(obj, jsonSettings ?? DefaultJsonSettings());
            var payload = AesEncryptionHelper.EncryptString(base64CurrentKey, json);
            var valEsc = Uri.EscapeDataString(payload);
            return valEsc;
        }

        /// <summary>
        /// Serialize object to JSON, encrypt once, and return "paramName=..." ready to append.
        /// </summary>
        public static string ToEncryptedQueryParam<T>(
            T obj,
            string base64CurrentKey,
            string paramName = "p",
            JsonSerializerSettings jsonSettings = null)
        {
            if (obj == null) throw new ArgumentNullException(nameof(obj));
            if (string.IsNullOrWhiteSpace(base64CurrentKey)) throw new ArgumentNullException(nameof(base64CurrentKey));
            if (string.IsNullOrWhiteSpace(paramName)) throw new ArgumentNullException(nameof(paramName));
            var keyEsc = Uri.EscapeDataString(paramName);
            return keyEsc + "=" + QueryStringEncDecHelper.ToEncryptedString(obj,base64CurrentKey, jsonSettings);
        }

        /// <summary>
        /// Same as ToEncryptedQueryParam, but returns a full "?paramName=..." string.
        /// </summary>
        public static string ToEncryptedQueryString<T>(
            T obj,
            string base64CurrentKey,
            string paramName = "p",
            JsonSerializerSettings jsonSettings = null)
        {
            return "?" + ToEncryptedQueryParam(obj, base64CurrentKey, paramName, jsonSettings);
        }

        /// <summary>
        /// Given the full query string or just the value of paramName, decrypt to T.
        /// Tries current key, then optional previous keys (for key rotation).
        /// </summary>
        public static T FromEncryptedQuery<T>(
            string queryOrParamValue,
            string base64CurrentKey,
            IEnumerable<string> base64PreviousKeys = null,
            string paramName = "p",
            JsonSerializerSettings jsonSettings = null) where T : new()
        {
            if (string.IsNullOrWhiteSpace(queryOrParamValue))
                throw new ArgumentNullException(nameof(queryOrParamValue));
            if (string.IsNullOrWhiteSpace(base64CurrentKey))
                throw new ArgumentNullException(nameof(base64CurrentKey));

            // If string looks like a query (?a=...&p=...), extract param; else treat as raw value.
            var encVal = LooksLikeQuery(queryOrParamValue)
                ? ExtractParam(queryOrParamValue, paramName)
                : queryOrParamValue;

            if (string.IsNullOrWhiteSpace(encVal))
                throw new ArgumentException($"Parameter '{paramName}' not found or empty.");

            var encDecoded = Uri.UnescapeDataString(encVal);

            string json;
            try
            {
                json = AesEncryptionHelper.DecryptString(base64CurrentKey, base64PreviousKeys, encDecoded);
            }
            catch
            {
                // If no previousKeys passed, the above already tried and failed.
                throw;
            }

            return JsonConvert.DeserializeObject<T>(json, jsonSettings ?? DefaultJsonSettings());
        }

        /// <summary>
        /// Try-pattern variant (no exceptions on failure).
        /// </summary>
        public static bool TryFromEncryptedQuery<T>(
            string queryOrParamValue,
            string base64CurrentKey,
            out T result,
            IEnumerable<string> base64PreviousKeys = null,
            string paramName = "p",
            JsonSerializerSettings jsonSettings = null) where T : new()
        {
            result = default(T);
            try
            {
                result = FromEncryptedQuery<T>(queryOrParamValue, base64CurrentKey, base64PreviousKeys, paramName, jsonSettings);
                return true;
            }
            catch
            {
                return false;
            }
        }

        // ----------------- internals -----------------

        private static bool LooksLikeQuery(string s)
        {
            // naive check: starts with '?' or contains '&' and '='
            return s.StartsWith("?", StringComparison.Ordinal) || (s.IndexOf('&') >= 0 && s.IndexOf('=') >= 0);
        }

        private static string ExtractParam(string queryString, string paramName)
        {
            if (queryString.StartsWith("?", StringComparison.Ordinal))
                queryString = queryString.Substring(1);

            var parts = queryString.Split(new[] { '&' }, StringSplitOptions.RemoveEmptyEntries);
            for (int i = 0; i < parts.Length; i++)
            {
                var kv = parts[i];
                var eq = kv.IndexOf('=');
                if (eq <= 0) continue;

                var key = Uri.UnescapeDataString(kv.Substring(0, eq));
                if (!string.Equals(key, paramName, StringComparison.Ordinal)) continue;

                return kv.Substring(eq + 1); // still URL-escaped; caller will unescape
            }
            return null;
        }

        private static JsonSerializerSettings DefaultJsonSettings()
        {
            return new JsonSerializerSettings
            {
                NullValueHandling = NullValueHandling.Ignore
            };
        }
    }
}
