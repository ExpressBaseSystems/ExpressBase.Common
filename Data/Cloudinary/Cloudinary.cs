using CloudinaryDotNet;
using CloudinaryDotNet.Actions;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Data;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using System;
using System.IO;

namespace ExpressBase.Common.Integrations
{
    public class EbCloudinary : IImageManipulate
    {
        public EbCloudinary(Account account)
        {
            _account = account;
        }

        public EbCloudinary(EbCloudinaryConnection con)
        {
            _account = con.Account;
            InfraConId = con.Id;
        }

        private Account _account { get;  set; }

        public int InfraConId { get ; set ; }

        Cloudinary GetNewConnection()
        {
            return new Cloudinary(_account);
        }


        public string Resize(byte[] iByte, ImageMeta meta, int imageQuality)
        {
            string _url;
            try
            {
                MemoryStream ImageStream = new MemoryStream(iByte);
                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(meta.FileRefId.ToString(), ImageStream),
                    Transformation = new Transformation().Quality(imageQuality),
                    PublicId = meta.FileRefId.ToString().ToString(),
                };
                _url = GetNewConnection().Upload(uploadParams).SecureUri.AbsoluteUri;
            }
            catch(Exception e)
            {
                _url = String.Empty;
                Console.WriteLine("Exception :"+ e.Message);
            }
            return _url;
        }
    }
}
