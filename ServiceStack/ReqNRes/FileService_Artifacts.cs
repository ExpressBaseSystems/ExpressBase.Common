using ExpressBase.Common.Enums;
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
    public class EbMqRequest : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public string BToken { get; set; }

        [DataMember(Order = 2)]
        public string RToken { get; set; }

        public void AddAuth(string btoken, string rtoken)
        {
            BToken = btoken;
            RToken = rtoken;
        }

        public void AddAuth(string solnId, string btoken, string rtoken)
        {
            base.TenantAccountId = solnId;
            BToken = btoken;
            RToken = rtoken;
        }

        public void AddAuth(int userId, string solnId, string btoken, string rtoken)
        {
            base.UserId = userId;
            base.TenantAccountId = solnId;
            BToken = btoken;
            RToken = rtoken;
        }
    }

    [DataContract]
    public class UploadFileRequest : EbMqRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] Byte { get; set; }
    }

    [DataContract]
    public class GetImageFtpRequest : EbMqRequest
    {
        [DataMember(Order = 1)]
        public KeyValuePair<int, string> FileUrl { get; set; }
    }

    [DataContract]
    public class CloudinaryResponseUrl : EbMqRequest
    {
        [DataMember]
        public string ImageUrl { get; set; }
    }

    [DataContract]
    public class UploadImageRequest : EbMqRequest
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] Byte { get; set; }
    }

    [DataContract]
    public class ImageResizeRequest : EbMqRequest
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] ImageByte { get; set; }
    }

    [DataContract]
    public class FileMetaPersistRequest : EbMqRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class FileMeta
    {
        [DataMember(Order = 1)]
        public string FileStoreId { get; set; }

        [DataMember(Order = 2)]
        public Int32 FileRefId { get; set; }

        [DataMember(Order = 3)]
        public string FileName { get; set; }

        [DataMember(Order = 4)]
        public IDictionary<string, List<string>> MetaDataDictionary { get; set; }

        [DataMember(Order = 5)]
        public DateTime UploadDateTime { get; set; }

        [DataMember(Order = 6)]
        public Int64 Length { get; set; }

        [DataMember(Order = 7)]
        public string FileType { get; set; }

        [DataMember(Order = 8)]
        public EbFileCategory FileCategory { get; set; }
    }

    [DataContract]
    public class ImageMeta
    {
        [DataMember(Order = 1)]
        public string FileStoreId { get; set; }

        [DataMember(Order = 2)]
        public Int32 FileRefId { get; set; }


        [DataMember(Order = 3)]
        public string FileName { get; set; }

        [DataMember(Order = 4)]
        public IDictionary<string, List<string>> MetaDataDictionary { get; set; }

        [DataMember(Order = 5)]
        public DateTime UploadDateTime { get; set; }

        [DataMember(Order = 6)]
        public Int64 Length { get; set; }

        [DataMember(Order = 7)]
        public string FileType { get; set; }

        [DataMember(Order = 8)]
        public EbFileCategory FileCategory { get; set; }

        [DataMember(Order = 9)]
        public ImageQuality ImageQuality { get; set; }
    }

    [DataContract]
    public class UploadFileAsyncRequest : EbServiceStackRequest, IReturn<UploadAsyncResponse>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] FileByte { get; set; }
    }

    [DataContract]
    public class UploadAsyncResponse : IEbSSResponse
    {
        [DataMember(Order = 1)]
        public ResponseStatus ResponseStatus { get; set; }
    }

    [DataContract]
    public class UploadImageAsyncRequest : EbServiceStackRequest, IReturn<UploadAsyncResponse>
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }

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
    public class DownloadFileRequest : EbServiceStackRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

    }

    [DataContract]
    public class DownloadFileByIdRequest : EbServiceStackRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class DownloadFileByRefIdRequest : EbServiceStackRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    //[DataContract]
    //public class EbFileId
    //{
    //    [DataMember(Order = 1)]
    //    public string ObjectId { get; set; }

    //    public EbFileId() { }

    //    public EbFileId(string objectId)
    //    {
    //        ObjectId = objectId;
    //    }
    //}

    [DataContract]
    public class DownloadImageByIdRequest : EbServiceStackRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }
    }

    [DataContract]
    public class DownloadImageByNameRequest : EbServiceStackRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }
    }

    [DataContract]
    public class DownloadFileResponse : IEbSSResponse
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public MemorystreamWrapper StreamWrapper { get; set; }

        [DataMember(Order = 3)]
        public ResponseStatus ResponseStatus { get; set; }
    }

    [DataContract]
    public class DownloadFileExtRequest : IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public string FileName { get; set; }

        [DataMember(Order = 2)]
        public const EbFileCategory FileCategory = EbFileCategory.External;
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
