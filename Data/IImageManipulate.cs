using CloudinaryDotNet.Actions;
using ExpressBase.Common.EbServiceStack.ReqNRes;

namespace ExpressBase.Common.Data
{
    public interface IImageManipulate
    {
        int InfraConId { get; set; }

        string Resize(byte[] iByte, string filename, int imageQuality);

        string Resize(string url, string filename, int imgQuality);
    }
}
