using ExpressBase.Common.EbServiceStack.ReqNRes;

namespace ExpressBase.Common.EbServiceStack
{
    public interface IEbFileService
    {
        byte[] Post(DownloadFileRequest request);
    }
}
