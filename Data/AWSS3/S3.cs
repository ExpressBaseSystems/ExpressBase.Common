using Amazon;
using Amazon.S3;
using Amazon.S3.Model;
using Amazon.S3.Transfer;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Constants;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Helpers;
using ServiceStack;
using System;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common.Data.AWSS3
{
    public class S3 : INoSQLDatabase
    {
        private readonly string bucketName;
        private readonly IAmazonS3 s3Client;
        public int InfraConId { get; set; }

        public S3(EbAWSS3Config config)
        {
            InfraConId = config.Id;
            bucketName = config.BucketName;

            var region = RegionEndpoint.GetBySystemName(config.BucketRegion);
            s3Client = new AmazonS3Client(config.AccessKeyID, config.SecretAccessKey, region);
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory category)
        {
            AsyncHelper.RunSync(() => UploadObjectDataAsyncAWSS3(filename, bytea, category));
            return filename;
        }

        public string UploadFile2(string filename, byte[] bytea, EbFileCategory category, string s3Path)
        {
            AsyncHelper.RunSync(() => UploadObjectDataAsyncAWSS3(filename, bytea, category, s3Path));
            return filename;
        }



        public async Task<string> UploadObjectDataAsyncAWSS3(string filename, byte[] data, EbFileCategory category, string s3Path="")
        {
            try
            {
                using (var stream = new MemoryStream(data))
                {
                    var uploadRequest = new TransferUtilityUploadRequest
                    {
                        InputStream = stream,
                        BucketName = bucketName,
                        Key = s3Path.TrimStart('/'),
                        ContentType = StaticFileConstants.GetMimeType(s3Path),
                        CannedACL = S3CannedACL.Private
                    };

                    var fileTransferUtility = new TransferUtility(s3Client);
                    await fileTransferUtility.UploadAsync(uploadRequest);
                }
                return filename;
            }
            catch (AmazonS3Exception ex)
            {
                throw new Exception($"AWS S3 error while uploading '{filename}': {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"General error while uploading '{filename}': {ex.Message}", ex);
            }
        }
        public byte[] DownloadFileById2(string filestoreId, EbFileCategory category, string s3Path)
        {
            return AsyncHelper.RunSync(() => ReadObjectDataAsyncAWSS3(filestoreId, category, s3Path));
        }

        public byte[] DownloadFileById(string filestoreId, EbFileCategory category)
        {
            return AsyncHelper.RunSync(() => ReadObjectDataAsyncAWSS3(filestoreId, category));
        }

        public async Task<byte[]> ReadObjectDataAsyncAWSS3(string filestoreId, EbFileCategory category, string s3Path = "")
        {
            try
            {
                var request = new GetObjectRequest
                {
                    BucketName = bucketName,
                    Key = s3Path
                };

                using (var response = await s3Client.GetObjectAsync(request))
                using (var memoryStream = new MemoryStream())
                {
                    await response.ResponseStream.CopyToAsync(memoryStream);
                    return memoryStream.ToArray();
                }
            }
            catch (AmazonS3Exception ex)
            {
                throw new Exception($"AWS S3 error while downloading '{filestoreId}': {ex.Message}", ex);
            }
            catch (Exception ex)
            {
                throw new Exception($"General error while downloading '{filestoreId}': {ex.Message}", ex);
            }
        }

    }
}
