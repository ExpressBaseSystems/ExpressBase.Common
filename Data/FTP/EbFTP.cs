using ExpressBase.Common.Connections;
using System;
using System.IO;
using System.Net;
using System.Web;

namespace ExpressBase.Common.Data.FTP
{
    class EbFTP : IFTP
    {
        private string _host { get; set; }
        private string _userName { get; set; }
        private string _password { get; set; }

        public EbFTP(EbFTPConnection con)
        {
            _host = con.Host.Normalize();
            _userName = con.Username.Normalize();
            _password = con.Password.Normalize();
        }

        public byte[] Download(string url)
        {
            byte[] _byte;
            FtpWebRequest ftpRequest;
            FtpWebResponse Response;
            Stream responseStream;

            try
            {
                ftpRequest = (FtpWebRequest)WebRequest.Create(String.Format(@"ftp://{0}/{1}", _host, url));
                ftpRequest.KeepAlive = true;
                ftpRequest.ConnectionGroupName = "EXPRESSbase Platform Connections";
                ftpRequest.Method = WebRequestMethods.Ftp.DownloadFile;
                ftpRequest.Credentials = new NetworkCredential(_userName.Normalize(), _password.Normalize());
                Response = (FtpWebResponse)ftpRequest.GetResponse();

                responseStream = Response.GetResponseStream();
                _byte = new byte[Response.ContentLength];

                byte[] buffer = new byte[2048];
                int ReadCount = 0, FileOffset = 0;

                do
                {
                    ReadCount = responseStream.Read(buffer, 0, buffer.Length);

                    for (int i = 0; i < ReadCount; i++)
                    {
                        _byte.SetValue(buffer[i], FileOffset);
                        FileOffset++;
                    }
                }
                while (ReadCount > 0);
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception: " + e.Message);
                _byte = new byte[0];
            }
            return _byte;
        }
    }
}
