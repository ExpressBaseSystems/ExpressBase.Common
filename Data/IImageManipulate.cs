using CloudinaryDotNet.Actions;
using ExpressBase.Common.EbServiceStack.ReqNRes;

namespace ExpressBase.Common.Data
{
    public interface IImageManipulate
    {
        int InfraConId { get; set; }

        string Resize(byte[] iByte, string filename, int imageQuality);
    }
}
