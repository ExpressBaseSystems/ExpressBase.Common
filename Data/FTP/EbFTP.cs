﻿using ExpressBase.Common.Connections;
using System.IO;
using System.Net;

namespace ExpressBase.Common.Data.FTP
{
    class EbFTP : IFTP
    {
        private string _host { get; set; }
        private string _userName { get; set; }
        private string _password { get; set; }

        public EbFTP(EbFTPConnection con)
        {
            _host = con.Host;
            _userName = con.Username;
            _password = con.Password;
        }

        public byte[] Download(string Url)
        {
            FtpWebRequest Request = (FtpWebRequest)WebRequest.Create(Url);
            Request.Method = WebRequestMethods.Ftp.DownloadFile;
            Request.Credentials = new NetworkCredential(_userName, _password);
            FtpWebResponse Response = (FtpWebResponse)Request.GetResponse();

            Stream responseStream = Response.GetResponseStream();
            byte[] _byte = new byte[Response.ContentLength];

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

            return _byte;
        }
    }
}