using ExpressBase.Common.Models;
using ServiceStack.Redis;
using System;

namespace ExpressBase.Common.Helpers
{
    public class InternalExceptionHelper
    {
        private const string KeyPrefix = "errtk:InternalExceptioninfo:";

        public InternalExceptionHelper(PooledRedisClientManager pooledRedisClientManager)
        {
            if (pooledRedisClientManager == null) throw new ArgumentNullException(nameof(pooledRedisClientManager));
            RedisCacheHelper.SetManager(pooledRedisClientManager);
        }

        /// <summary>
        /// Create a ticket from a pre-built InternalExceptioninfo and store for a short TTL.
        /// </summary>
        public string Create(InternalExceptioninfo ex, TimeSpan ttl)
        {
            if (ex == null) throw new ArgumentNullException(nameof(ex));
            if (ttl <= TimeSpan.Zero) throw new ArgumentOutOfRangeException(nameof(ttl));

            var id = Guid.NewGuid().ToString("N");
            var key = KeyPrefix + id;

            RedisCacheHelper.Set(key, ex, ttl);

            return id;
        }

        /// <summary>
        /// Convenience overload: build InternalExceptioninfo from an Exception.
        /// </summary>
        public string Create(Exception ex, TimeSpan ttl)
        {
            if (ex == null) throw new ArgumentNullException(nameof(ex));
            return Create(new InternalExceptioninfo
            {
                Type = ex.GetType().FullName,
                Message = ex.Message,
                StackTrace = ex.StackTrace
            }, ttl);
        }

        /// <summary>
        /// Fetch ticket and delete it (delete-after-read).
        /// </summary>
        public InternalExceptioninfo Get(string ticketId)
        {
            if (string.IsNullOrWhiteSpace(ticketId)) return null;

            var key = KeyPrefix + ticketId;

            // If your helper returns default(T) when not found, this is safe.
            var info = RedisCacheHelper.Get<InternalExceptioninfo>(key);

            // delete after fetch (even if null: no-op for most helpers)
            RedisCacheHelper.Remove(key);

            return info;
        }


    }
}
