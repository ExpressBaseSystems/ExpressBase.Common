using System;
using ServiceStack.Caching;
using ServiceStack.Redis;

namespace ExpressBase.Common.Helpers
{
    /// <summary>
    /// Static helper class to simplify caching with Redis using ServiceStack's PooledRedisClientManager.
    /// Provides typed Set/Get, GetOrSet, Remove, Exists, and raw string operations.
    /// 
    /// Usage:
    ///     var redisManager = new PooledRedisClientManager(listRW, listRO);
    ///     RedisCacheHelper.SetManager(redisManager);
    /// 
    ///     RedisCacheHelper.Set("foo", "bar", TimeSpan.FromMinutes(5));
    ///     var value = RedisCacheHelper.Get<string>("foo");
    /// </summary>
    public static class RedisCacheHelper
    {
        // Holds the shared PooledRedisClientManager instance (set once at startup).
        // This is a reference to the object created outside; we don't create or dispose it here.
        private static PooledRedisClientManager _manager;

        /// <summary>
        /// Assign the Redis connection manager that this helper will use.
        /// Must be called once on application startup with a preconfigured manager.
        /// 
        /// Note: Classes in C# are reference types — when you pass a manager here,
        /// you are passing a reference to the same object, not a copy.
        /// </summary>
        public static void SetManager(PooledRedisClientManager manager)
        {
            _manager = manager ?? throw new ArgumentNullException(nameof(manager));
        }

        /// <summary>
        /// Store a typed object in Redis. Overwrites if the key exists.
        /// Uses ICacheClient for serialization/deserialization.
        /// </summary>
        public static void Set<T>(string key, T value, TimeSpan? expiry = null)
        {
            ValidateManager(); // Ensure SetManager was called
            ValidateKey(key);  // Ensure key is valid

            using (var cache = _manager.GetCacheClient())
            {
                if (expiry.HasValue)
                    cache.Set(key, value, expiry.Value); // Set with TTL
                else
                    cache.Set(key, value); // Set without TTL
            }
        }

        /// <summary>
        /// Get a typed object from Redis. Returns default(T) if not found.
        /// </summary>
        public static T Get<T>(string key)
        {
            ValidateManager();
            ValidateKey(key);

            using (var cache = _manager.GetReadOnlyCacheClient())
            {
                return cache.Get<T>(key);
            }
        }

        /// <summary>
        /// Get a value from Redis or set it if missing.
        /// Executes valueFactory() only if the key is absent.
        /// </summary>
        public static T GetOrSet<T>(string key, Func<T> valueFactory, TimeSpan? expiry = null)
        {
            ValidateManager();
            ValidateKey(key);
            if (valueFactory == null) throw new ArgumentNullException(nameof(valueFactory));

            using (var cache = _manager.GetCacheClient())
            {
                var existing = cache.Get<T>(key);
                if (existing != null && !existing.Equals(default(T)))
                    return existing; // Found in cache

                // Compute new value outside of cache call
                var newValue = valueFactory();

                // Store only if not null
                if (newValue != null)
                {
                    if (expiry.HasValue)
                        cache.Set(key, newValue, expiry.Value);
                    else
                        cache.Set(key, newValue);
                }

                return newValue;
            }
        }

        /// <summary>
        /// Remove an entry by key.
        /// Returns true if removed, false if not found.
        /// </summary>
        public static bool Remove(string key)
        {
            ValidateManager();
            ValidateKey(key);

            using (var cache = _manager.GetCacheClient())
            {
                return cache.Remove(key);
            }
        }

        /// <summary>
        /// Check if a key exists in Redis.
        /// Uses safe Get first, falls back to raw Redis ContainsKey.
        /// </summary>
        public static bool Exists(string key)
        {
            ValidateManager();
            ValidateKey(key);

            try
            {
                using (var cache = _manager.GetReadOnlyCacheClient())
                {
                    return cache.Get<object>(key) != null;
                }
            }
            catch
            {
                // Fallback in case cache client errors
                using (var client = _manager.GetClient())
                {
                    return client.ContainsKey(key);
                }
            }
        }

        /// <summary>
        /// Get the raw string value stored at a key (no deserialization).
        /// </summary>
        public static string GetRaw(string key)
        {
            ValidateManager();
            ValidateKey(key);

            using (var client = _manager.GetClient())
            {
                return client.GetValue(key);
            }
        }

        /// <summary>
        /// Set a raw string value in Redis (no serialization).
        /// Uses atomic SetValue(key, value, TimeSpan) when expiry is provided.
        /// </summary>
        public static void SetRaw(string key, string rawValue, TimeSpan? expiry = null)
        {
            ValidateManager();
            ValidateKey(key);

            using (var client = _manager.GetClient())
            {
                if (expiry.HasValue)
                    client.SetValue(key, rawValue ?? string.Empty, expiry.Value);
                else
                    client.SetValue(key, rawValue ?? string.Empty);
            }
        }

        /// <summary>
        /// Ensure the key is valid (not null/empty).
        /// </summary>
        private static void ValidateKey(string key)
        {
            if (string.IsNullOrWhiteSpace(key))
                throw new ArgumentException("Cache key must not be null or empty.", nameof(key));
        }

        /// <summary>
        /// Ensure that SetManager has been called before using this helper.
        /// </summary>
        private static void ValidateManager()
        {
            if (_manager == null)
                throw new InvalidOperationException("RedisCacheHelper not initialized. Call RedisCacheHelper.SetManager() first.");
        }
    }
}
