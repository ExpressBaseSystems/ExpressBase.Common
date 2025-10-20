using Newtonsoft.Json;
using System;

namespace ExpressBase.Common.Helpers
{

    public static class QueryStringEncDecHelper
    {

        public static string EncryptString<T>(
            T obj,
            string base64CurrentKey,
            JsonSerializerSettings jsonSettings = null)
        {
            if (obj == null) throw new ArgumentNullException(nameof(obj));
            if (string.IsNullOrWhiteSpace(base64CurrentKey)) throw new ArgumentNullException(nameof(base64CurrentKey));

            var json = JsonConvert.SerializeObject(obj, jsonSettings ?? DefaultJsonSettings());
            var cipher = AesEncryptionHelper.EncryptString(base64CurrentKey, json);
            return Uri.EscapeDataString(cipher);
        }

        public static T DecryptEncryptedString<T>(
            string encryptedOrEscaped,
            string base64CurrentKey,
            JsonSerializerSettings jsonSettings = null)
        {
            if (string.IsNullOrWhiteSpace(encryptedOrEscaped)) throw new ArgumentNullException(nameof(encryptedOrEscaped));
            if (string.IsNullOrWhiteSpace(base64CurrentKey)) throw new ArgumentNullException(nameof(base64CurrentKey));

            var unescaped = Uri.UnescapeDataString(encryptedOrEscaped);
            try
            {
                var json = AesEncryptionHelper.DecryptString(base64CurrentKey, unescaped);
                return JsonConvert.DeserializeObject<T>(json, jsonSettings ?? DefaultJsonSettings());
            }
            catch
            {
                var json = AesEncryptionHelper.DecryptString(base64CurrentKey, encryptedOrEscaped);
                return JsonConvert.DeserializeObject<T>(json, jsonSettings ?? DefaultJsonSettings());
            }
        }

        private static JsonSerializerSettings DefaultJsonSettings() =>
            new JsonSerializerSettings { NullValueHandling = NullValueHandling.Ignore };
    }
}
