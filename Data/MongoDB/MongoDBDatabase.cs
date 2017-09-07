using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;
using MongoDB.Bson;
using MongoDB.Driver;
using MongoDB.Driver.GridFS;
using ExpressBase.Common.Connections;

namespace ExpressBase.Common.Data.MongoDB
{
    public class MongoDBDatabase : INoSQLDatabase
    {
      //  private string mongodb_url;
        private IMongoDatabase mongoDatabase;

        public MongoDBDatabase(EbFilesDbConnection dbconf)
        {
           // mongodb_url = String.Format("mongodb://{0}:{1}@{2}:{3}", dbconf.UserName, dbconf.Password, dbconf.Server, dbconf.Port);
            //mongoDatabase = (new MongoClient(dbconf.MongoDB_url)).GetDatabase("test");
        }

        public DbConnection GetNewConnection()
        {
            throw new NotImplementedException();
        }

        public async System.Threading.Tasks.Task UploadFileAsync(string filename, byte[] source)
        {
            IGridFSBucket bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
            {
                BucketName = "images",
                ChunkSizeBytes = 1048576, // 1MB
                WriteConcern = WriteConcern.WMajority,
                ReadPreference = ReadPreference.Secondary
            });

            var options = new GridFSUploadOptions
            {
                ChunkSizeBytes = 64512, // 63KB
                Metadata = new BsonDocument
                {
                    { "resolution", "1080P" },
                    { "copyrighted", true }
                }
            };

            var id = await bucket.UploadFromBytesAsync(filename, source, options);
        }
    }
}
