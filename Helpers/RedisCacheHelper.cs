using ServiceStack.Redis;
using System;

namespace ExpressBase.Common.Helpers
{
    public static class RedisCacheHelper
    {
        
        private static void CheckManager(PooledRedisClientManager manager)
        {
            if (manager == null) throw new ArgumentNullException(nameof(manager));
        }
        

        public static void Set<T>(PooledRedisClientManager manager, string key, T value, TimeSpan? expiry = null)
        {
            ValidateKey(key);
            CheckManager(manager);

            using (var cache = manager.GetCacheClient())
            {
                if (expiry.HasValue) cache.Set(key, value, expiry.Value);
                else cache.Set(key, value);
            }
        }

        public static T Get<T>(PooledRedisClientManager manager, string key)
        {
            ValidateKey(key);
            CheckManager(manager);

            using (var cache = manager.GetReadOnlyCacheClient())
            {
                return cache.Get<T>(key);
            }
        }

        public static T GetOrSet<T>(PooledRedisClientManager manager, string key, Func<T> valueFactory, TimeSpan? expiry = null)
        {
            if (valueFactory == null) throw new ArgumentNullException(nameof(valueFactory));
            ValidateKey(key);
            CheckManager(manager);
           
            using (var client = manager.GetClient())
            {
                if (client.ContainsKey(key))
                {
                    using (var ro = manager.GetReadOnlyCacheClient())
                        return ro.Get<T>(key);
                }
            }

        
            var newValue = valueFactory();

            using (var cache = manager.GetCacheClient())
            {
                var added = expiry.HasValue
                    ? cache.Add(key, newValue, expiry.Value)
                    : cache.Add(key, newValue);

                return added ? newValue : cache.Get<T>(key);
            }
        }

        public static bool Remove(PooledRedisClientManager manager, string key)
        {
            ValidateKey(key);
            CheckManager(manager);

            using (var cache = manager.GetCacheClient())
            {
                return cache.Remove(key);
            }
        }

        public static bool Exists(PooledRedisClientManager manager, string key)
        {
            ValidateKey(key);
            CheckManager(manager);

            using (var client = manager.GetClient())
            {
                return client.ContainsKey(key);
            }
        }

      
        public static string GetRaw(PooledRedisClientManager manager, string key)
        {
            ValidateKey(key);
            CheckManager(manager);

            using (var client = manager.GetClient())
            {
                return client.GetValue(key);
            }
        }

        public static void SetRaw(PooledRedisClientManager manager, string key, string rawValue, TimeSpan? expiry = null)
        {
            ValidateKey(key);
            CheckManager(manager);

            using (var client = manager.GetClient())
            {
                var val = rawValue ?? string.Empty;
                if (expiry.HasValue) client.SetValue(key, val, expiry.Value);
                else client.SetValue(key, val);
            }
        }

        private static void ValidateKey(string key)
        {
            if (string.IsNullOrWhiteSpace(key))
                throw new ArgumentException("Key must not be null or empty.", nameof(key));
        }
    }
}
