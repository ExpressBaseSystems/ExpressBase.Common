using ExpressBase.Common.Connections;
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

		public EbFileId UploadFile(string filename, IDictionary<string, List<string>> MetaDataPair, byte[] bytea, EbFileCategory cat)
		{
			Bucket = new GridFSBucket(mongoDatabase, new GridFSBucketOptions
			{
				BucketName = cat.ToString(),
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
                return new EbFileId(Bucket.UploadFromBytes(filename, bytea, options).ToString());
			}
			catch (Exception e)
			{
				Console.WriteLine("Exception:" + e.ToString());
				return new EbFileId("Error");
			}
		}

		public byte[] DownloadFileById(EbFileId objectid, EbFileCategory cat)
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
                ObjectId objId = new ObjectId(objectid.ObjectId);
				res = Bucket.DownloadAsBytes(objId, new GridFSDownloadOptions() { CheckMD5 = true });
			}

			catch (GridFSFileNotFoundException e)
			{
				Console.WriteLine("MongoDB File Not Found: " + objectid.ToString());
			}

			catch (Exception e)
			{
				Console.WriteLine("Exception:" + e.ToString());
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
				Console.WriteLine("MongoDB File Not Found: " + filename);
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
