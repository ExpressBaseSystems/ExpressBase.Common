using ExpressBase.Common.Enums;
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

        public string UploadFile(string filename, byte[] bytea, EbFileCategory category, int _infraConId)
        {
            Console.WriteLine("Inside Upload FilesDB Collection");

            try
            {
                if (_infraConId == 0)
                {
                    _infraConId = DefaultConId;
                }
                this.UsedConId = _infraConId;

            }
            catch (Exception e)
            {
                Console.WriteLine("Error in Upload File");
            }
            return this[this.UsedConId].UploadFile(filename, bytea, category);
        }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory category, int _infraConId)
        {
            //if (_infraConId == 0)
            //{
            //    _infraConId = DefaultConId;
            //}
            //this.UsedConId = _infraConId;
            return this[_infraConId].DownloadFileById(filestoreid, category);
        }

    }
}
