using CloudinaryDotNet.Actions;
using ExpressBase.Common.EbServiceStack.ReqNRes;

namespace ExpressBase.Common.Data
{
    public interface IImageManipulate
    {
        int InfraConId { get; set; }

        string Resize(byte[] iByte, ImageMeta meta, int imageQuality);
        string GetThumbnailImage(string OriginalImageUrl);
    }
}
