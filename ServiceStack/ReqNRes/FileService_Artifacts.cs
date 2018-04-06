using ServiceStack;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace ExpressBase.Common.EbServiceStack.ReqNRes
{
    [DataContract]
    public class DeleteFileRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class UploadFileRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] FileByte { get; set; }

        [DataMember(Order = 3)]
        public string BucketName { get; set; }

        [DataMember(Order = 4)]
        public string BToken { get; set; }

        [DataMember(Order = 5)]
        public string RToken { get; set; }
    }

    [DataContract]
    public class ImageResizeRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] ImageByte { get; set; }
    }

    [DataContract]
    public class FileMetaPersistRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public string BucketName { get; set; }
    }

    [DataContract]
    public class FileMeta
    {
        [DataMember(Order = 1)]
        public string ObjectId { get; set; }

        [DataMember(Order = 2)]
        public string FileName { get; set; }

        [DataMember(Order = 3)]
        public IDictionary<string, List<string>> MetaDataDictionary { get; set; }

        [DataMember(Order = 4)]
        public DateTime UploadDateTime{ get; set; }

        [DataMember(Order = 5)]
        public Int64 Length { get; set; }

        [DataMember(Order = 6)]
        public string FileType { get; set; }
    }

    [DataContract]
    public class UploadFileAsyncRequest : EbServiceStackRequest, IReturn<bool>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] FileByte { get; set; }
    }

    [DataContract]
    public class UploadImageAsyncRequest : EbServiceStackRequest, IReturn<bool>
    {
        [DataMember(Order = 1)]
        public FileMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] ImageByte { get; set; }
    }

    public class UploadFileMqResponse
    {
        public string Uploaded { get; set; }

        public string initialPreview { get; set; }

        public string objId { get; set; }
    }

    public class UploadFileMqError
    {
        public string Uploaded { get; set; }
    }

    [DataContract]
    public class DownloadFileRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class DownloadFileExtRequest
    {
        [DataMember(Order = 1)]
        public string FileName { get; set; }
    }

    [DataContract]
    public class FindFilesByTagRequest : EbServiceStackRequest, IReturn<List<FileMeta>>
    {
        [DataMember(Order = 1)]
        public List<string> Tags { get; set; }

        public bool IsImage { get; set; }

    }

    [DataContract]
    public class InitialFileReq : EbServiceStackRequest, IReturn<List<FileMeta>>
    {
        [DataMember(Order = 1)]
        public FileClass Type { get; set; }
    }
}
