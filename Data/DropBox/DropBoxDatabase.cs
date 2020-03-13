using System;
using System.IO;
using ExpressBase.Common.Connections;
using ExpressBase.Common.Enums;
using Dropbox.Api;
using System.Threading.Tasks;
using Dropbox.Api.Files;
using ExpressBase.Common.Helpers;

namespace ExpressBase.Common.Data.DropBox
{
    
    class DropBoxDatabase : INoSQLDatabase
    {
        public int InfraConId { get; set; }
        private DropboxClient Dbx;
        private byte[] result;
        private string rev;

        public DropBoxDatabase(EbDropBoxConfig dbconf)
        {
            InfraConId = dbconf.Id;
            Dbx = new DropboxClient(dbconf.AccessToken);
        }

        public byte[] DownloadFileById(string filestoreid, EbFileCategory category)
        {
            AsyncHelper.RunSync(() => DowloadwithAsyncDropbox(filestoreid: filestoreid));
            return result;
        }

        public async Task DowloadwithAsyncDropbox(string filestoreid)
        {
            //byte[] res = null;
            filestoreid = "rev:" + filestoreid;
            try
            {
                using (var response = await Dbx.Files.DownloadAsync(filestoreid))
                {
                    var s = response.GetContentAsByteArrayAsync();
                    s.Wait();
                    result = s.Result;
                }
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
            }
            //return res;
        }

        public string UploadFile(string filename, byte[] bytea, EbFileCategory cat)
        {
            try
            {
                AsyncHelper.RunSync(() => UploadwithAsyncDropbox(filename, bytea, cat));
                return rev;
            }
            catch (Exception e)
            {
                Console.WriteLine("Exception:" + e.ToString());
                return "Error";
            }
        }

        public async Task UploadwithAsyncDropbox(string filename, byte[] bytea, EbFileCategory cat)
        {
            using (var mem = new MemoryStream(bytea))
            {
                try
                {
                    var updated = await Dbx.Files.UploadAsync(
                    path: "/" + filename,
                    WriteMode.Overwrite.Instance,
                    body: mem);
                   
                    rev = updated.Rev;
                }
                catch (Exception e)
                {
                    Console.WriteLine("DropBox Error :" + e);
                }
            }
        }        
    }
}
