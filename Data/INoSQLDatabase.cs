using MongoDB.Bson;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        ObjectId UploadFile(string filename, byte[] bytea, string bucketName, BsonDocument metaData);

        byte[] DownloadFile(ObjectId objectid, string bucketname);

        byte[] DownloadFile(string filename, string bucketname);

        List<GridFSFileInfo> FindFilesByTags(KeyValuePair<string, string> Filter);
    }
}
