using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
using MongoDB.Bson;
using MongoDB.Driver.GridFS;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        string UploadFile(string filename, byte[] bytea, EbFileCategory category);

        byte[] DownloadFileById(string filestoreid, EbFileCategory category);

        //byte[] DownloadFileByName(string filename, EbFileCategory category);
    }
}
