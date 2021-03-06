﻿using CloudinaryDotNet;
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

        public EbCloudinary(EbCloudinaryConfig conf)
        {
            _account = new CloudinaryDotNet.Account(conf.Cloud, conf.ApiKey, conf.ApiSecret);
            InfraConId = conf.Id;
        }

        private Account _account { get; set; }

        public int InfraConId { get; set; }

        Cloudinary GetNewConnection()
        {
            return new Cloudinary(_account);
        }


        public string Resize(byte[] iByte, string filename, int imageQuality)
        {
            string _url = string.Empty;
            try
            {
                MemoryStream ImageStream = new MemoryStream(iByte);

                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(filename, ImageStream),
                    Transformation = new Transformation().Quality(imageQuality),
                    PublicId = filename,
                };
                var resp = GetNewConnection().Upload(uploadParams);
                if (resp.SecureUri != null)
                    _url = resp.SecureUri.AbsoluteUri;
                else
                    Console.WriteLine(String.Format("INFO: Cloudinary: Response[{0}] : {1}", filename, resp.JsonObj.ToString()));
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("ERROR: Cloudinary[{0}]: {1}", filename, e.ToString()));
            }
            return _url;
        }

        public string Resize(string url, string filename, int imgQuality)
        {
            string _url = string.Empty;
            try
            {
                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(filePath: url),
                    Transformation = new Transformation().Quality(imgQuality),
                    PublicId = filename,
                };
                var resp = GetNewConnection().Upload(uploadParams);
                if (resp.SecureUri != null)
                    _url = resp.SecureUri.AbsoluteUri;
                else
                    Console.WriteLine(String.Format("INFO: Cloudinary: Response[{0}] : {1}", filename, resp.JsonObj.ToString()));
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("ERROR: Cloudinary[{0}]: {1}", filename, e.ToString()));
            }
            return _url;
        }

        public string GetImgSize(byte[] iByte, string filename, ImageQuality size)
        {
            string _url = string.Empty;
            try
            {
                MemoryStream ImageStream = new MemoryStream(iByte);
                var uploadParams = new ImageUploadParams()
                {
                    File = new FileDescription(filename, ImageStream),
                    Transformation = new Transformation().Height((int)size).Crop("fit").AspectRatio(1.0),
                    PublicId = filename,
                };
                var resp = GetNewConnection().Upload(uploadParams);
                if (resp.SecureUri != null)
                    _url = resp.SecureUri.AbsoluteUri;
                else
                    Console.WriteLine(String.Format("INFO: Cloudinary: Response[{0}] : {1}", filename, resp.JsonObj.ToString()));
            }
            catch (Exception e)
            {
                Console.WriteLine(String.Format("ERROR: Cloudinary[{0}]: {1}", filename, e.ToString()));
            }
            return _url;
        }
    }
}
