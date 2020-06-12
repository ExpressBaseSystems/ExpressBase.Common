using System;
using System.Threading.Tasks;
using System.Collections.Generic;
using System.Text;

using Amazon;
using Amazon.S3;
using Amazon.S3.Model;

using ExpressBase.Common.Connections;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Helpers;
using Amazon.S3.Transfer;
using System.IO;
using System.Threading;

namespace ExpressBase.Common.Data.AWSS3
{
    class AWSS3 : INoSQLDatabase
    {
        private string bucketName;
        private string AccessKeyID;
        private string SecretAccessKey;
        private byte[] result;
        public int InfraConId { get; set; }

        private static IAmazonS3 s3Client;

        public AWSS3(EbAWSS3Config ebAWSS3)
        {
            InfraConId = ebAWSS3.Id;
            bucketName = ebAWSS3.BucketName;
            AccessKeyID = ebAWSS3.AccessKeyID;
            SecretAccessKey = ebAWSS3.SecretAccessKey;

            RegionEndpoint BucketRegion = RegionEndpoint.GetBySystemName(ebAWSS3.BucketRegion);

            s3Client = new AmazonS3Client(AccessKeyID, SecretAccessKey, BucketRegion);
        }
        public byte[] DownloadFileById(string filestoreid, EbFileCategory category)
        {
            AsyncHelper.RunSync(() => ReadObjectDataAsyncAWSS3(filestoreid));
            return result;
        }
        public async Task ReadObjectDataAsyncAWSS3(string filestoreid)
        { 
            try
            {
                GetObjectRequest request = new GetObjectRequest
                {
                    BucketName = bucketName,
                    Key = filestoreid
                };
                using (GetObjectResponse response = await s3Client.GetObjectAsync(bucketName, filestoreid))
                using (Stream stream = response.ResponseStream)
                {
                    long length = stream.Length;
                    byte[] bytes = new byte[length];
                    int bytesToRead = (int)length;
                    int numBytesRead = 0;
                    do
                    {
                        int chunkSize = 1000;
                        if (chunkSize > bytesToRead)
                        {
                            chunkSize = bytesToRead;
                        }
                        int n = stream.Read(bytes, numBytesRead, chunkSize);
                        numBytesRead += n;
                        bytesToRead -= n;
                    }
                    while (bytesToRead > 0);
                    String contents = Encoding.UTF8.GetString(bytes);
                    Console.WriteLine(contents);
                    result = bytes;
                }
            }
            catch (AmazonS3Exception e)
            {
                Console.WriteLine("Error encountered ***. Message:'{0}' when writing an object", e.Message);
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown encountered on server. Message:'{0}' when writing an object", e.Message);
            }
        }
        public string UploadFile(string filename, byte[] bytea, EbFileCategory category)
        {
            AsyncHelper.RunSync(() => UploadObjectDataAsyncAWSS3(filename, bytea, category));
            return filename;
        }


        public async Task UploadObjectDataAsyncAWSS3(string filename, byte[] bytea, EbFileCategory cat)
        {
            
            try
            {
                var fileTransferUtility = new TransferUtility(s3Client);
                var ms = new System.IO.MemoryStream();
                ms.Write(bytea, 0, bytea.Length);
                ms.Position = 0;

                await fileTransferUtility.UploadAsync(ms, bucketName, filename);
                Console.WriteLine("Upload 4 completed");
            }
            catch (AmazonS3Exception e)
            {
                Console.WriteLine("Error encountered on server. Message:'{0}' when writing an object", e.Message);
            }
            catch (Exception e)
            {
                Console.WriteLine("Unknown encountered on server. Message:'{0}' when writing an object", e.Message);
            }
        }
    }
}
