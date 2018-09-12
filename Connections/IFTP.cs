using ExpressBase.Common.Data;

namespace ExpressBase.Common.Connections
{
    public interface IFTP
    {
        byte[] Download(string Path);

        long GetFileSize(string Path);

        string UploadToManipulte(string Path, IImageManipulate Manipulate, int ImgQuality);
    }
}
