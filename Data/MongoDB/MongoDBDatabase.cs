using ExpressBase.Common.Connections;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;
using System.Linq;

namespace ExpressBase.Common.Data.MongoDB
{
    public class MongoDBDatabase : INoSQLDatabase
    {
        private MongoUrl mongoUrl;
        private MongoClient mongoClient;
        private IMongoDatabase mongoDatabase;
        private IGridFSBucket bucket;
        private string TenantId { get; set; }

        public MongoDBDatabase(string tenantId, EbFilesDbConnection dbconf)
        {
            this.TenantId = tenantId;
            //mongodb_url = "mongodb://ahammedunni:Opera754$@cluster0-shard-00-00-lbath.mongodb.net:27017,cluster0-shard-00-01-lbath.mongodb.net:27017,cluster0-shard-00-02-lbath.mongodb.net:27017/admin?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin";
            mongoUrl = new MongoUrl("mongodb://ahammedunni:Opera754$@cluster0-shard-00-00-lbath.mongodb.net:27017,cluster0-shard-00-01-lbath.mongodb.net:27017,cluster0-shard-00-02-lbath.mongodb.net:27017/admin?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin");

            mongoClient = new MongoClient(mongoUrl);
            mongoDatabase = mongoClient.GetDatabase(tenantId);
            bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = "files",
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });
        }

        public ObjectId UploadFile(string filename, byte[] bytea, BsonDocument metaData)
        {
            var options = new GridFSUploadOptions
            {
                ChunkSizeBytes = 64512, // 63KB
                Metadata = metaData
            };

            return bucket.UploadFromBytes(filename, bytea, options);
        }

        public byte[] DownloadFile(ObjectId objectid)
        {
            return bucket.DownloadAsBytes(objectid, new GridFSDownloadOptions() { CheckMD5 = true });
        }

        public byte[] DownloadFile(string filename)
        {
            return bucket.DownloadAsBytesByName(filename);
        }

        public List<GridFSFileInfo> FindFilesByTags(KeyValuePair<string, string> Filter)
        {
            var filter = Builders<GridFSFileInfo>.Filter.And(Builders<GridFSFileInfo>.Filter.AnyEq(Filter.Key, Filter.Value));

            var sort = Builders<GridFSFileInfo>.Sort.Descending(x => x.UploadDateTime);

            var options = new GridFSFindOptions
            {
                Limit = 20,
                Sort = sort
            };

            using (var cursor = bucket.Find(filter, options))
            {
                var fileInfo = cursor.ToList();

                return fileInfo;
            }
        }
    }
}
