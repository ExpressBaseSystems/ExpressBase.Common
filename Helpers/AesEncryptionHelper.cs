using System;
using System.Collections.Generic;
using System.Security.Cryptography;
using System.Text;
using Newtonsoft.Json;

namespace ExpressBase.Common.Helpers
{
    /// <summary>
    /// Static AES-256-CBC + HMAC-SHA256 helper.
    /// - All methods are static.
    /// - Keys must be provided as base64 strings (32 bytes when decoded).
    /// - Payload = base64( utf8(json { iv, ct, mac }) )
    /// Compatible with .NET Core 2.1.
    /// </summary>
    public static class AesEncryptionHelper
    {
        private const int IvLength = 16;              // AES block size
        private const int RequiredKeyLength = 32;     // 256-bit key

        /// <summary>
        /// Generates a new 32-byte random key (base64 encoded).
        /// </summary>
        public static string GenerateKey()
        {
            using (var rng = new RNGCryptoServiceProvider())
            {
                var key = new byte[RequiredKeyLength];
                rng.GetBytes(key);
                return Convert.ToBase64String(key);
            }
        }

        /// <summary>
        /// Encrypts a string and returns a base64 payload.
        /// </summary>
        public static string EncryptString(string base64CurrentKey, string plainText)
        {
            if (plainText == null) throw new ArgumentNullException(nameof(plainText));
            var key = DecodeAndValidateKey(base64CurrentKey);

            var plainBytes = Encoding.UTF8.GetBytes(plainText);

            var iv = new byte[IvLength];
            using (var rng = new RNGCryptoServiceProvider())
            {
                rng.GetBytes(iv);
            }

            byte[] cipherBytes;
            using (var aes = Aes.Create())
            {
                aes.KeySize = 256;
                aes.BlockSize = 128;
                aes.Mode = CipherMode.CBC;
                aes.Padding = PaddingMode.PKCS7;
                aes.Key = key;
                aes.IV = iv;

                using (var encryptor = aes.CreateEncryptor())
                {
                    cipherBytes = encryptor.TransformFinalBlock(plainBytes, 0, plainBytes.Length);
                }
            }

            var mac = ComputeHmac(key, iv, cipherBytes);

            var payload = new Payload
            {
                iv = Convert.ToBase64String(iv),
                ct = Convert.ToBase64String(cipherBytes),
                mac = Convert.ToBase64String(mac)
            };

            var json = JsonConvert.SerializeObject(payload);
            return Convert.ToBase64String(Encoding.UTF8.GetBytes(json));
        }

        /// <summary>
        /// Decrypts a payload using current + optional previous keys.
        /// </summary>
        public static string DecryptString(string base64CurrentKey, IEnumerable<string> base64PreviousKeys, string base64Payload)
        {
            if (string.IsNullOrWhiteSpace(base64Payload)) throw new ArgumentNullException(nameof(base64Payload));
            var currentKey = DecodeAndValidateKey(base64CurrentKey);

            var previousKeys = new List<byte[]>();
            if (base64PreviousKeys != null)
            {
                foreach (var k in base64PreviousKeys)
                {
                    if (string.IsNullOrWhiteSpace(k)) continue;
                    previousKeys.Add(DecodeAndValidateKey(k));
                }
            }

            string json;
            try
            {
                var bytes = Convert.FromBase64String(base64Payload);
                json = Encoding.UTF8.GetString(bytes);
            }
            catch (FormatException)
            {
                throw new CryptographicException("Payload is not valid base64.");
            }

            var payload = JsonConvert.DeserializeObject<Payload>(json);
            if (payload == null || string.IsNullOrEmpty(payload.iv) || string.IsNullOrEmpty(payload.ct) || string.IsNullOrEmpty(payload.mac))
                throw new CryptographicException("Invalid payload structure.");

            var iv = Convert.FromBase64String(payload.iv);
            var ct = Convert.FromBase64String(payload.ct);
            var mac = Convert.FromBase64String(payload.mac);

            if (TryValidateAndDecrypt(currentKey, iv, ct, mac, out var plain))
                return Encoding.UTF8.GetString(plain);

            foreach (var pk in previousKeys)
            {
                if (TryValidateAndDecrypt(pk, iv, ct, mac, out plain))
                    return Encoding.UTF8.GetString(plain);
            }

            throw new CryptographicException("Unable to decrypt payload with any known key (invalid MAC or corrupted data).");
        }

        /// <summary>
        /// Overload when no previous keys are needed.
        /// </summary>
        public static string DecryptString(string base64CurrentKey, string base64Payload)
        {
            return DecryptString(base64CurrentKey, null, base64Payload);
        }

        // ----------------- Internal helpers -----------------

        private static bool TryValidateAndDecrypt(byte[] key, byte[] iv, byte[] ciphertext, byte[] mac, out byte[] plain)
        {
            plain = null;
            try
            {
                var expectedMac = ComputeHmac(key, iv, ciphertext);
                if (!FixedTimeEquals(expectedMac, mac))
                    return false;

                using (var aes = Aes.Create())
                {
                    aes.KeySize = 256;
                    aes.BlockSize = 128;
                    aes.Mode = CipherMode.CBC;
                    aes.Padding = PaddingMode.PKCS7;
                    aes.Key = key;
                    aes.IV = iv;

                    using (var decryptor = aes.CreateDecryptor())
                    {
                        plain = decryptor.TransformFinalBlock(ciphertext, 0, ciphertext.Length);
                        return true;
                    }
                }
            }
            catch
            {
                return false;
            }
        }

        private static byte[] ComputeHmac(byte[] key, byte[] iv, byte[] ciphertext)
        {
            byte[] hmacKey;
            using (var h = new HMACSHA256(key))
            {
                hmacKey = h.ComputeHash(Encoding.UTF8.GetBytes("LaravelCompatibleHMACKey"));
            }

            using (var hmac = new HMACSHA256(hmacKey))
            {
                var input = new byte[iv.Length + ciphertext.Length];
                Buffer.BlockCopy(iv, 0, input, 0, iv.Length);
                Buffer.BlockCopy(ciphertext, 0, input, iv.Length, ciphertext.Length);
                return hmac.ComputeHash(input);
            }
        }

        private static bool FixedTimeEquals(byte[] a, byte[] b)
        {
            if (a == null || b == null || a.Length != b.Length) return false;
            var result = 0;
            for (var i = 0; i < a.Length; i++)
                result |= a[i] ^ b[i];
            return result == 0;
        }

        private static byte[] DecodeAndValidateKey(string base64Key)
        {
            if (string.IsNullOrWhiteSpace(base64Key))
                throw new ArgumentException("Encryption key must be provided (base64).");

            byte[] key;
            try
            {
                key = Convert.FromBase64String(base64Key);
            }
            catch (FormatException ex)
            {
                throw new ArgumentException("Encryption key must be a valid base64 string.", ex);
            }

            if (key.Length != RequiredKeyLength)
                throw new ArgumentException($"Encryption key must be {RequiredKeyLength} bytes (base64-encoded). Use GenerateKey() to produce one.");

            return key;
        }

        private class Payload
        {
            [JsonProperty("iv")] public string iv { get; set; }
            [JsonProperty("ct")] public string ct { get; set; }
            [JsonProperty("mac")] public string mac { get; set; }
        }
    }
}
