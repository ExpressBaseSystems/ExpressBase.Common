using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
using MongoDB.Bson;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        EbFileId UploadFile(string filename, IDictionary<string, List<string>> MetaDataPair, byte[] bytea, EbFileCategory category);

        byte[] DownloadFileById(EbFileId objectid, EbFileCategory category);

        byte[] DownloadFileByName(string filename, EbFileCategory category);
    }
}
