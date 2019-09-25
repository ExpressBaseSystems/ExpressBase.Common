using ExpressBase.Common.Connections;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Helpers;
using Google.Apis.Auth.OAuth2;
using Google.Apis.Auth.OAuth2.Flows;
using Google.Apis.Auth.OAuth2.Responses;
using Google.Apis.Download;
using Google.Apis.Drive.v3;
using Google.Apis.Drive.v3.Data;
using Google.Apis.Services;
using Google.Apis.Upload;
using System;
using System.Collections.Generic;
using System.IO;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace ExpressBase.Common.Data.GoogleDrive
{
    class GoogleDriveDatabase : INoSQLDatabase
    {
        private GoogleCredential credential { get; set; }

        private TokenResponse Token { get; set; }

        private EbGoogleDriveConfig dbconf { get; set; }

        private DriveService service { get; set; }
        private Byte[] result { get; set; }

        public int InfraConId { get; set; }


        public GoogleDriveDatabase(EbGoogleDriveConfig dbconf)
        {
            this.dbconf = dbconf;
            this.InfraConId = dbconf.Id;
            AsyncHelper.RunSync(() => connectionmaker());
        }

        public async Task connectionmaker()
        {
            var init = new GoogleAuthorizationCodeFlow.Initializer
            {
                ClientSecrets = new ClientSecrets
                {
                    ClientId = this.dbconf.ClientID,
                    ClientSecret = this.dbconf.Clientsecret
                },
                Scopes = new string[] { "https://www.googleapis.com/auth/drive" }
            };
            var flow = new AuthorizationCodeFlow(init);
            Token = await flow.RefreshTokenAsync("user", dbconf.RefreshToken, CancellationToken.None);

            credential = GoogleCredential.FromAccessToken(Token.AccessToken);
            service = new DriveService(new BaseClientService.Initializer()
            {
                HttpClientInitializer = credential,
                ApplicationName = this.dbconf.ApplicationName,
            });
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory category)
        {
            try
            {
                var fileMetadata = new Google.Apis.Drive.v3.Data.File()
                {
                    Name = filename + ".jpg",
                    MimeType = "image/jpeg"
                };
                FilesResource.CreateMediaUpload request;
                IUploadProgress response;
                using (var stream = new MemoryStream(bytea))
                {
                    request = service.Files.Create(
                        fileMetadata, stream, "image/jpeg");
                    request.Fields = "id";
                    response = request.Upload();
                }
                if (response != null)
                    Console.WriteLine("Exception" + response.Status.ToString());
                else if (response == null)
                    Console.WriteLine("Null Response");
                var file = request.ResponseBody;
                if (file != null)
                {
                    Console.WriteLine("File ID: " + file.Id);
                    return file.Id;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("exception inside storeauth :" + e);
                Console.WriteLine(" StackTrace :" + e.StackTrace);
            }
            return null;
        }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory category)
        {
            try
            {
                var request = service.Files.Get(filestoreid);
                var stream = new System.IO.MemoryStream();

                // Add a handler which will be notified on progress changes.
                // It will notify on each chunk download and when the
                // download is completed or failed.
                request.MediaDownloader.ProgressChanged +=
                    (IDownloadProgress progress) =>
                    {
                        switch (progress.Status)
                        {
                            case DownloadStatus.Downloading:
                                {
                                    Console.WriteLine(progress.BytesDownloaded);
                                    break;
                                }
                            case DownloadStatus.Completed:
                                {
                                    Console.WriteLine("Download complete.");
                                    break;
                                }
                            case DownloadStatus.Failed:
                                {
                                    Console.WriteLine("Download failed.");
                                    break;
                                }
                        }
                    };
                request.Download(stream);
                stream.Position = 0;
                byte[] buffer = new byte[stream.Length];
                for (int totalBytesCopied = 0; totalBytesCopied < stream.Length;)
                    totalBytesCopied += stream.Read(buffer, totalBytesCopied, Convert.ToInt32(stream.Length) - totalBytesCopied);
                String contents = Encoding.UTF8.GetString(buffer);
                result = buffer;
            }
            catch (Exception e)
            {
                Console.WriteLine("exception inside storeauth :" + e);
                Console.WriteLine(" StackTrace :" + e.StackTrace);
            }
            return result;
        }
    }
}
