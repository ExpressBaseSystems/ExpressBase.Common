using ExpressBase.Common.EbServiceStack.ReqNRes;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace ExpressBase.Common.ServiceStack.ReqNRes
{
    [DataContract]
    public class FileDownloadRequestObject : EbServiceStackAuthRequest
    {
        [DataMember(Order = 1)]
        string test = string.Empty;
    }

    [DataContract]
    public class FileDownloadResponseObject : EbServiceStackAuthRequest
    {
        [DataMember(Order = 1)]
        string test = string.Empty;
    }

    public class GetDownloadFileRequest : EbServiceStackAuthRequest
    {
        public int Id { get; set; }

        public bool IsGetAll { get; set; }
    }

    public class GetDownloadFileResponse
    {
        public FileDownloadObject FileDownloadObject { get; set; }

        public List<FileDownloadObject> AllDownloadObjects { get; set; }
    }

    public class FileDownloadObject
    {
        public int Id { get; set; }

        public string Filename { get; set; }

        public byte[] FileBytea { get; set; }

        public int CreatedBy { get; set; }

        public string CreatedAt { get; set; }

        public bool IsDeleted { get; set; }

        public bool IsGenerating { get; set; }
    }
}
