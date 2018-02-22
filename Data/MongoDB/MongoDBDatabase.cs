using ExpressBase.Common.Connections;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.GridFS;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;

namespace ExpressBase.Common.Data.MongoDB
{
    public class MongoDBDatabase : INoSQLDatabase
    {
        private MongoClient mongoClient;
        private IMongoDatabase mongoDatabase;
        private IGridFSBucket Bucket;
        private string TenantId { get; set; }
        private BsonDocument Metadata { get; set; }

        public MongoDBDatabase(EbFilesDbConnection dbconf)
        {
            this.TenantId = EnvironmentConstants.EB_INFRASTRUCTURE;
            mongoClient = new MongoClient(dbconf.FilesDB_url);
            mongoDatabase = mongoClient.GetDatabase(this.TenantId);
        }

        public MongoDBDatabase(string tenantId, EbFilesDbConnection dbconf)
        {
            this.TenantId = tenantId;
            mongoClient = new MongoClient(dbconf.FilesDB_url);
            mongoDatabase = mongoClient.GetDatabase(this.TenantId);
        }

        public ObjectId UploadFile(string filename, IDictionary<string, List<string>> MetaDataPair, byte[] bytea, string bucketName)
        {
            Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = bucketName,
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            this.Metadata = new BsonDocument();

            if(MetaDataPair != null)
                this.Metadata.AddRange(MetaDataPair as IDictionary);

            var options = new GridFSUploadOptions
            {
                ChunkSizeBytes = 64512, // 63KB
                Metadata = Metadata
            };
            try
            {
                return Bucket.UploadFromBytes(filename, bytea, options);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                return new ObjectId("Error");
            }
        }

        public byte[] DownloadFile(ObjectId objectid, string bucketName)
        {
            Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = bucketName,
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            return Bucket.DownloadAsBytes(objectid, new GridFSDownloadOptions() { CheckMD5 = true });
        }

        public byte[] DownloadFile(string filename, string bucketName)
        {
            try
            {
                Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
                {
                    BucketName = bucketName,
                    ChunkSizeBytes = 1048576, // 1MB
                    WriteConcern = WriteConcern.WMajority,
                    ReadPreference = ReadPreference.Secondary
                });

                return Bucket.DownloadAsBytesByName(filename);

            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                return null;
            }
            
            }

        public async Task<bool> DeleteFileAsync(ObjectId objectid, string bucketName)
        {
            try
            {
                Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions { BucketName = bucketName });
                await Bucket.DeleteAsync(objectid);
                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                return false;
            }
        }

        public List<GridFSFileInfo> FindFilesByTags(KeyValuePair<string, List<string>> Filter, string Bucketname)
        {
            List<FilterDefinition<GridFSFileInfo>> FilterDef = new List<FilterDefinition<GridFSFileInfo>>();

            foreach (string tag in Filter.Value)
            {
                FilterDef.Add(Builders<GridFSFileInfo>.Filter.AnyEq(Filter.Key, tag));
            }

            IEnumerable<FilterDefinition<GridFSFileInfo>> FilterFinal = new List<FilterDefinition<GridFSFileInfo>>(FilterDef);

            var filter = Builders<GridFSFileInfo>.Filter.And(FilterFinal);
            var sort = Builders<GridFSFileInfo>.Sort.Descending(x => x.UploadDateTime);
            var options = new GridFSFindOptions
            {
                Limit = 20,
                Sort = sort
            };

            Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions { BucketName = Bucketname });

            using (var cursor = Bucket.Find(filter, options))
            {
                var fileInfo = cursor.ToList();
                return fileInfo;
            }
        }
        
    }
}
