﻿using ExpressBase.Common.Connections;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;
using System.Linq;

namespace ExpressBase.Common.Data.MongoDB
{
    public class MongoDBDatabase : INoSQLDatabase
    {
        private MongoClient mongoClient;
        private IMongoDatabase mongoDatabase;
        private IGridFSBucket bucket;
        private string TenantId { get; set; }

        public MongoDBDatabase(string tenantId, EbFilesDbConnection dbconf)
        {
            this.TenantId = tenantId;
            mongoClient = new MongoClient(dbconf.FilesDB_url);
            mongoDatabase = mongoClient.GetDatabase(tenantId);
        }

        public ObjectId UploadFile(string filename, byte[] bytea, string bucketName, BsonDocument metaData)
        {
            bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = bucketName,
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            var options = new GridFSUploadOptions
            {
                ChunkSizeBytes = 64512, // 63KB
                Metadata = metaData
            };

            return bucket.UploadFromBytes(filename, bytea, options);
        }

        public byte[] DownloadFile(ObjectId objectid, string bucketName)
        {
            bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = bucketName,
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            return bucket.DownloadAsBytes(objectid, new GridFSDownloadOptions() { CheckMD5 = true });
        }

        public byte[] DownloadFile(string filename, string bucketName)
        {
            bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = bucketName,
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            return bucket.DownloadAsBytesByName(filename);
        }

        public List<GridFSFileInfo> FindFilesByTags(KeyValuePair<string, List<string>> Filter)
        {
            IEnumerable<FilterDefinition<GridFSFileInfo>> FilterDef = new List<FilterDefinition<GridFSFileInfo>>()
            {
                Builders<GridFSFileInfo>.Filter.AnyEq(Filter.Key, Filter.Value[0]),
                Builders<GridFSFileInfo>.Filter.AnyEq(Filter.Key, Filter.Value[1])
            };

            //FilterDef.Append(Builders<GridFSFileInfo>.Filter.AnyEq(Filter.Key, "test"));
            //foreach (string tag in Filter.Value)
            //{
            //    FilterDef.Append(Builders<GridFSFileInfo>.Filter.Eq(Filter.Key, tag));
            //}

            //var filter = Builders<GridFSFileInfo>.Filter.And(FilterDef);

            var filter = Builders<GridFSFileInfo>.Filter.And(FilterDef);
            //var filter = Builders<GridFSFileInfo>.Filter.And(Builders<GridFSFileInfo>.Filter.AnyEq(Filter.Key, Filter.Value));

            var sort = Builders<GridFSFileInfo>.Sort.Descending(x => x.UploadDateTime);

            var options = new GridFSFindOptions
            {
                Limit = 20,
                Sort = sort
            };

            bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions { BucketName = "images" });

            using (var cursor = bucket.Find(filter, options))
            {
                var fileInfo = cursor.ToList();

                return fileInfo;
            }
        }
    }
}
