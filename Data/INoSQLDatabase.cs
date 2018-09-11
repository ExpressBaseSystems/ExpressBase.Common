using ExpressBase.Common.Enums;

namespace ExpressBase.Common.Data
{
    public interface INoSQLDatabase
    {
        int InfraConId { get; set; }

        string UploadFile(string filename, byte[] bytea, EbFileCategory category);

        byte[] DownloadFileById(string filestoreid, EbFileCategory category);

        //byte[] DownloadFileByName(string filename, EbFileCategory category);
    }
}
