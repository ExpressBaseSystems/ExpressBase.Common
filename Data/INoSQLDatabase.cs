using MongoDB.Bson;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        ObjectId UploadFile(string filename, byte[] bytea, BsonDocument metaData);

        byte[] DownloadFile(string objectid);

        List<GridFSFileInfo> FindFilesByTags(KeyValuePair<string, string> Filter);
    }
}
