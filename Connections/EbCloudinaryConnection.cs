using CloudinaryDotNet;

namespace ExpressBase.Common.Connections
{
    public class EbCloudinaryConnection : IEbConnection
    {
        public Account Account { get; set; }

        public override EbConnectionTypes EbConnectionType { get { return EbConnectionTypes.Cloudinary; } }
    }
}