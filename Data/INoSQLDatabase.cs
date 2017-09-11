using MongoDB.Bson;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Text;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        ObjectId UploadFile(string filename, byte[] bytea, BsonDocument metaData);

        byte[] DownloadFile(string objectid);
    }
}
