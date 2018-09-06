using CloudinaryDotNet.Actions;
using ExpressBase.Common.EbServiceStack.ReqNRes;

namespace ExpressBase.Common.Data
{
    public interface IImageManipulate
    {
        string Resize(byte[] iByte, ImageMeta meta, int imageQuality);
    }
}
