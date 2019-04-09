using ExpressBase.Common.Connections;
using System;
using System.IO;
using System.Net;
using System.Web;
using System.Linq;
using ServiceStack;

namespace ExpressBase.Common.Data.FTP
{
    //class EbFTP : IFTP
    //{
    //    private string _host { get; set; }
    //    private string _userName { get; set; }
    //    private string _password { get; set; }

    //    private FtpWebRequest _ftpRequest;
    //    private FtpWebResponse _response;
    //    private Stream _responseStream;

    //    public EbFTP(EbFTPConnection con)
    //    {
    //        _host = con.Host.Normalize();
    //        _userName = con.Username.Normalize();
    //        _password = con.Password.Normalize();
    //    }

    //    private string GetUrlWithAuth(string path)
    //    {
    //        return String.Format(@"ftp://{0}", HttpUtility.UrlPathEncode(String.Format("{0}:{1}@{2}/{3}", _userName, _password, _host, path)));
    //    }

    //    private string GetRequestString(string path)
    //    {
    //        return (String.Format(@"ftp://{0}", HttpUtility.UrlPathEncode(String.Format("{0}/{1}", _host, path))));
    //    }

    //    private void SetFTPRequest(string path)
    //    {
    //        _ftpRequest = (FtpWebRequest)WebRequest.Create(GetRequestString(path));
    //        _ftpRequest.UseBinary = true;
    //        _ftpRequest.KeepAlive = false;
    //        _ftpRequest.UsePassive = true;
    //        _ftpRequest.ConnectionGroupName = "EXPRESSbase Platform Connections";
    //        _ftpRequest.Credentials = new NetworkCredential(_userName, _password);
    //    }

    //    public byte[] Download(string path)
    //    {
    //        byte[] _byte;

    //        try
    //        {
    //            SetFTPRequest(path);

    //            _ftpRequest.Method = WebRequestMethods.Ftp.DownloadFile;
    //            _response = (FtpWebResponse)_ftpRequest.GetResponse();

    //            _responseStream = _response.GetResponseStream();
    //            _byte = new byte[_response.ContentLength];

    //            byte[] buffer = new byte[10 * 1024];
    //            int ReadCount = 0, FileOffset = 0;

    //            do
    //            {
    //                ReadCount = _responseStream.Read(buffer, 0, buffer.Length);

    //                for (int i = 0; i < ReadCount; i++)
    //                {
    //                    _byte.SetValue(buffer[i], FileOffset);
    //                    FileOffset++;
    //                }
    //            }
    //            while (ReadCount > 0);

    //            _responseStream.Close();
    //            _response.Close();
    //        }
    //        catch (Exception ex)
    //        {
    //            Console.WriteLine("ERROR:  FTP: " + ex.Message);
    //            _byte = new byte[0];
    //        }
    //        return _byte;
    //    }

    //    public long GetFileSize(string path)
    //    {
    //        long size;

    //        try
    //        {
    //            SetFTPRequest(path);

    //            _ftpRequest.Method = WebRequestMethods.Ftp.GetFileSize;
    //            _response = (FtpWebResponse)_ftpRequest.GetResponse();

    //            size = _response.ContentLength;
    //        }
    //        catch (Exception e)
    //        {
    //            Console.WriteLine("ERROR: FTP ERROR " + e.Message);
    //            size = 0;
    //        }
    //        return size;
    //    }

    //    public string UploadToManipulte(string path, IImageManipulate manipulate, int quality)
    //    {
    //        string _outUrl;
    //        try
    //        {
    //            string url = GetUrlWithAuth(path);
    //            _outUrl = manipulate.Resize(url, url.SplitOnLast('/').Last(), quality);
    //        }
    //        catch (Exception e)
    //        {
    //            Console.WriteLine("ERROR: FTP: " + e.Message);
    //            _outUrl = string.Empty;
    //        }

    //        return _outUrl;
    //    }
    //}
}
