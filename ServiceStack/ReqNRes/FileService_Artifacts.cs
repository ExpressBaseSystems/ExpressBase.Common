using ServiceStack;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;

namespace ExpressBase.Common.EbServiceStack.ReqNRes
{
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
    public class UploadFileRequest : EbServiceStackRequest, IReturn<string>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] FileByte { get; set; }

        [DataMember(Order = 3)]
        public bool IsAsync { get; set; }

    }

    [DataContract]
    public class DeleteFileRequest : EbServiceStackRequest, IReturn<string>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class DeleteFileMqRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class UploadFileMqRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] FileByte { get; set; }

        [DataMember(Order = 3)]
        public string BucketName { get; set; }
    }
    
    [DataContract]
    public class UploadImageRequest : EbServiceStackRequest, IReturn<string>
    {
        [DataMember(Order = 1)]
        public FileMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] ImageByte { get; set; }

        [DataMember(Order = 3)]
        public bool IsAsync { get; set; }

    }

    public class UploadFileControllerResponse
    {
        public string Uploaded { get; set; }

        public string initialPreview { get; set; }

        public string objId { get; set; }
    }

    public class UploadFileControllerError
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
    public class FindFilesByTagRequest : EbServiceStackRequest, IReturn<List<FileMeta>>
    {
        [DataMember(Order = 1)]
        public List<string> Tags { get; set; }

        public bool IsImage { get; set; }

    }

    [DataContract]
    public class ImageResizeMqRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] ImageByte { get; set; }

    }

    [DataContract]
    public class FileMetaPersistMqRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public string BucketName { get; set; }
    }
}
