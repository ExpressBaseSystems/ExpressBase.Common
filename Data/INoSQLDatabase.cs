using Amazon;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Data.AWSS3;
using ExpressBase.Common.Enums;
using ExpressBase.Common.LocationNSolution;
using System;
using System.Collections.Generic;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        int InfraConId { get; set; }

        string UploadFile(string filename, byte[] bytea, EbFileCategory category);

        byte[] DownloadFileById(string filestoreid, EbFileCategory category);

        //byte[] DownloadFileByName(string filename, EbFileCategory category);
    }
    //public class EbFileStore : INoSQLDatabase
    // {
    //     public int InfraConId { get; set; }

    //     public string UploadFile(string filename, byte[] bytea, EbFileCategory category)
    //     {
    //         return "";
    //     }

    //     public byte[] DownloadFileById(string filestoreid, EbFileCategory category)
    //     {
    //         return null;
    //     }

    // }

    public class FilesCollection : List<INoSQLDatabase>
    {
        public int DefaultConId { get; set; }

        public int UsedConId { get; set; }
        new public INoSQLDatabase this[int _id]
        {
            get
            {
                if (_id == 0)
                {
                    return EbConnectionsConfigProvider.EbS3Connection;
                }
                foreach (INoSQLDatabase file in this)
                {
                    if (file.InfraConId == _id)
                    {
                        return file;
                    }
                }
                return null;
            }
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory category, int _infraConId, string s3Path = "", bool isNewFileServer = false)
        {
            Console.WriteLine("Inside Upload FilesDB Collection");

            Console.WriteLine("InfraCon Id: " + _infraConId);
            Console.WriteLine("Default Con Id: " + DefaultConId);

            try
            {
                if (isNewFileServer)
                {
                    return (this[0] as S3).UploadFile2(filename, bytea, category, s3Path);
                }
                else if (_infraConId == 0)
                {
                    _infraConId = DefaultConId;
                }
                this.UsedConId = _infraConId;
                Console.WriteLine("Used Con Id: " + UsedConId);
                return this[this.UsedConId].UploadFile(filename, bytea, category);
            }
            catch (Exception e)
            {
                Console.WriteLine("Error in Upload File" + e.Message + "\nStack Trace: " + e.StackTrace);
                return null;
            }

        }

        public string GetPresignedUrl(string s3Path)
        {
            return (this[0] as S3).GetPreSignedUrl(s3Path);
        }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory category, int _infraConId, string s3Path = "", bool isNewFileServer = false)
        {
            if (isNewFileServer)
                return (this[0] as S3).DownloadFileById2(filestoreid, category, s3Path);

            if (this[_infraConId + 1000000] != null)
                return this[_infraConId + 1000000].DownloadFileById(filestoreid, category);

            return this[_infraConId].DownloadFileById(filestoreid, category);
        }

    }
}
