﻿using ExpressBase.Common.Connections;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
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
        public MongoClient mongoClient;
        public IMongoDatabase mongoDatabase;
        public IGridFSBucket Bucket;
        public string TenantId { get; set; }
        public BsonDocument Metadata { get; set; }
        public int InfraConId { get; set; }

        private const string CONNECTION_STRING_BARE = "mongodb://{0}:{1}@{2}:{3}/admin?ssl=true&replicaSet=Cluster0-shard-0&authSource=admin";
        public MongoDBDatabase(EbMongoConfig dbconf)
        {
            InfraConId = dbconf.Id;
            this.TenantId = EnvironmentConstants.EB_INFRASTRUCTURE;
            string _cstr = string.Format(CONNECTION_STRING_BARE, dbconf.UserName, dbconf.Password, dbconf.Host, dbconf.Port);
            mongoClient = new MongoClient(_cstr);
            mongoDatabase = mongoClient.GetDatabase(this.TenantId);
        }

        public MongoDBDatabase(string tenantId, EbMongoConfig dbconf)
        {
            InfraConId = dbconf.Id;
            this.TenantId = tenantId;
            string _cstr = string.Format(CONNECTION_STRING_BARE, dbconf.UserName, dbconf.Password, dbconf.Host, dbconf.Port);
            mongoClient = new MongoClient(_cstr);
            mongoDatabase = mongoClient.GetDatabase(this.TenantId);
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory cat)
        {
            Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = cat.ToString(),
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            var options = new GridFSUploadOptions
            {
                ChunkSizeBytes = 64512, // 63KB
                Metadata = Metadata
            };
            try
            {
                return Bucket.UploadFromBytes(filename, bytea, options).ToString();
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                return "Error";
            }
        }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory cat)
        {
            byte[] res = null;

            try
            {
                Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
                {
                    BucketName = cat.ToString(),
                    ChunkSizeBytes = 1048576, // 1MB
                    WriteConcern = WriteConcern.WMajority,
                    ReadPreference = ReadPreference.Secondary
                });
                ObjectId objId = new ObjectId(filestoreid);
                res = Bucket.DownloadAsBytes(objId, new GridFSDownloadOptions() { CheckMD5 = true });
            }

            catch (GridFSFileNotFoundException e)
            {
                Console.WriteLine("MongoDB File Not Found: " + filestoreid.ToString() + e.Message + e.StackTrace);
            }

            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.Message + e.StackTrace);
            }
            return res;
        }

        public byte[] DownloadFileByName(string filename, EbFileCategory cat)
        {
            byte[] res = null;

            try
            {
                Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
                {
                    BucketName = cat.ToString(),
                    ChunkSizeBytes = 1048576, // 1MB
                    WriteConcern = WriteConcern.WMajority,
                    ReadPreference = ReadPreference.Secondary
                });

                res = Bucket.DownloadAsBytesByName(filename);

            }
            catch (GridFSFileNotFoundException e)
            {
                Console.WriteLine("MongoDB File Not Found: " + filename + e.Message + e.StackTrace);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
            }
            return res;
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
