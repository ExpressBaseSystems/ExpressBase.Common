using MongoDB.Bson;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        ObjectId UploadFile(string filename, IDictionary<string, List<string>> MetaDataPair, byte[] bytea, string bucketName);

        byte[] DownloadFile(ObjectId objectid, string bucketname);

        byte[] DownloadFile(string filename, string bucketname);

        List<GridFSFileInfo> FindFilesByTags(KeyValuePair<string, List<string>> Filter, string BucketName);
    }
}
