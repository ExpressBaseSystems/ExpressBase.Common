using ServiceStack.Redis;
using ServiceStack.Auth;
using System.Collections.Generic;
using System.Linq;
using System;

namespace ExpressBase.ServiceStack
{
    public class EbApiRedisAuthRepository : IManageApiKeys
    {
        private readonly IRedisClientsManager factory;

        public string NamespacePrefix { get; set; }

        private string UsePrefix => NamespacePrefix ?? "";

        private string IndexUserAuthAndApiKeyIdsSet(string userAuthId) { return UsePrefix + "urn:UserAuth>ApiKey:" + userAuthId; }

        public EbApiRedisAuthRepository(IRedisClientsManager factory)
        {
            this.factory = factory;
        }

        public bool ApiKeyExists(string apiKey)
        {
            using (var redis = factory.GetClient())
                return redis.As<ApiKey>().GetById(apiKey) != null;
        }

        public ApiKey GetApiKey(string apiKey)
        {
            using (var redis = factory.GetClient())
                return redis.As<ApiKey>().GetById(apiKey);
        }

        public List<ApiKey> GetUserApiKeys(string userId)
        {
            using (var redis = factory.GetClient())
            {
                var idx = IndexUserAuthAndApiKeyIdsSet(userId);
                var authProviderIds = redis.GetAllItemsFromSet(idx);
                var apiKeys = redis.As<ApiKey>().GetByIds(authProviderIds);
                return apiKeys
                    .Where(x => x.CancelledDate == null
                        && (x.ExpiryDate == null || x.ExpiryDate >= DateTime.UtcNow))
                    .OrderByDescending(x => x.CreatedDate).ToList();
            }
        }

        public void InitApiKeySchema()
        {
            throw new System.NotImplementedException();
        }

        public void StoreAll(IEnumerable<ApiKey> apiKeys)
        {
            using (var redis = factory.GetClient())
            {
                foreach (var apiKey in apiKeys)
                {
                    var userAuthId = apiKey.UserAuthId;
                    redis.Store(apiKey);
                    redis.AddItemToSet(IndexUserAuthAndApiKeyIdsSet(userAuthId), apiKey.Id.ToString());
                }
            }

        }
    }
}