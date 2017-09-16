using ExpressBase.Common.Connections;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.GridFS;

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

        public ObjectId UploadFile(string filename, byte[] bytea, BsonDocument metaData = null)
        {
            var options = new GridFSUploadOptions
            {
                ChunkSizeBytes = 64512, // 63KB
                Metadata = metaData
            };

            return bucket.UploadFromBytes(filename, bytea, options);
        }

        public byte[] DownloadFile(string objectid)
        {
            return bucket.DownloadAsBytes(new ObjectId(objectid), new GridFSDownloadOptions() { CheckMD5 = true });
        }
    }
}
