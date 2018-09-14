using CloudinaryDotNet;
using ExpressBase.Common.Enums;
using ExpressBase.Common.Structures;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.Data.Common;
using System.Runtime.Serialization;

namespace ExpressBase.Common.EbServiceStack.ReqNRes
{
    [DataContract]
    public class DeleteFileRequest : EbServiceStackAuthRequest
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }



    [DataContract]
    public class UploadFileRequest : EbMqRequest, IReturn<EbMqResponse>
    {
        [DataMember(Order = 1)]
        public int FileRefId { get; set; }

        [DataMember(Order = 2)]
        public EbFileCategory FileCategory { get; set; }

        [DataMember(Order = 3)]
        public byte[] Byte { get; set; }
    }

    [DataContract]
    public class GetImageFtpRequest : EbMqRequest, IReturn<EbMqResponse>
    {
        [DataMember(Order = 1)]
        public KeyValuePair<int, string> FileUrl { get; set; }

    }

    [DataContract]
    public class CloudinaryResizeReq : EbMqRequest, IReturn<EbMqResponse>
    {
        [DataMember(Order = 1)]
        public int RefId { get; set; }

        [DataMember(Order = 2)]
        public byte[] Byte { get; set; }

    }

    [DataContract]
    public class UploadImageRequest : EbMqRequest, IReturn<EbMqResponse>
    {
        [DataMember(Order = 1)]
        public int ImageRefId { get; set; }

        [DataMember(Order = 2)]
        public EbFileCategory FileCategory { get; set; }

        [DataMember(Order = 3)]
        public byte[] Byte { get; set; }

        [DataMember(Order = 4)]
        public int ImgManpSerConId { get; set; }

        [DataMember(Order = 5)]
        public ImageQuality ImgQuality { get; set; }


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
    public class ImageMetaPersistRequest : EbMqRequest
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }
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

        [DataMember(Order = 9)]
        public int ImgManipulationServiceId { get; set; }
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

        [DataMember(Order = 10)]
        public int ImgManipulationServiceId { get; set; }
    }

    [DataContract]
    public class UploadFileAsyncRequest : EbServiceStackAuthRequest, IReturn<UploadAsyncResponse>
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

        [DataMember(Order = 2)]
        public int FileRefId { get; set; }
    }

    public class FileRefIdsWraper
    {
        public List<int> RefIds;
    }

    [DataContract]
    public class UploadImageAsyncRequest : EbServiceStackAuthRequest, IReturn<UploadAsyncResponse>
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }

        [DataMember(Order = 2)]
        public byte[] ImageByte { get; set; }
    }

    public class UploadFileMqResponse
    {
        public bool IsUploaded { get; set; }

        public string initialPreview { get; set; }

        public int ImgRefId { get; set; }
    }

    public class UploadFileMqError
    {
        public string Uploaded { get; set; }
    }

    [DataContract]
    public class DownloadFileRequest : EbServiceStackAuthRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

    }

    [DataContract]
    public class DownloadFileByIdRequest : EbServiceStackAuthRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }
    }

    [DataContract]
    public class DownloadFileByRefIdRequest : EbServiceStackAuthRequest, IReturn<DownloadFileResponse>
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
    public class DownloadImageByIdRequest : EbServiceStackAuthRequest, IReturn<DownloadFileResponse>
    {
        [DataMember(Order = 1)]
        public ImageMeta ImageInfo { get; set; }
    }

    [DataContract]
    public class DownloadImageByNameRequest : EbServiceStackAuthRequest, IReturn<DownloadFileResponse>
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
    public class FindFilesByTagRequest : EbServiceStackAuthRequest, IReturn<List<FileMeta>>
    {
        [DataMember(Order = 1)]
        public List<string> Tags { get; set; }

        public bool IsImage { get; set; }

    }

    [DataContract]
    public class InitialFileReq : EbServiceStackAuthRequest, IReturn<List<FileMeta>>
    {
        [DataMember(Order = 1)]
        public FileClass Type { get; set; }
    }
}
