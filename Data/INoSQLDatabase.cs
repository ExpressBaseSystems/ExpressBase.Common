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

            Console.WriteLine("InfraCon Id: " + _infraConId);
            Console.WriteLine("Default Con Id: " + DefaultConId);

            try
            {
                if (_infraConId == 0)
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

        public byte[] DownloadFileById(string filestoreid, EbFileCategory category, int _infraConId)
        {
            //if (_infraConId == 0)
            //{
            //    _infraConId = DefaultConId;
            //}
            //this.UsedConId = _infraConId;
            if (this[_infraConId + 1000000] != null)
                return this[_infraConId + 1000000].DownloadFileById(filestoreid, category);

            return this[_infraConId].DownloadFileById(filestoreid, category);
        }

    }
}
