
using ExpressBase.Common.EbServiceStack.ReqNRes;
using ExpressBase.Common.Enums;
using Microsoft.AspNetCore.Http;
using Newtonsoft.Json;
using ServiceStack;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;
using System.IO;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.WebApi.RequestNResponse
{
    public class UploadFileRequest2
    {
        public IFormFile File { get; set; }

        public string Context { get; set; }

        public string FileType { get; set; }

        public string FileName { get; set; }

        public long Length { get; set; }

        public int FileCategory { get; set; }

        public int ImageQuality { get; set; }

        public string MetaData { get; set; }

        public string SolnId { get; set; }

        public int UserId { get; set; }

        public string UserAuthId { get; set; }

        public int TargetUserId { get; set; }
    }

    public class DownloadFileRequest2
    {
        public int FileRefId { get; set; }

        public int FileCategory { get; set; }

        public int ImgQuality { get; set; }

        public string FileName { get; set; }

        public string SolnId { get; set; }

        public int UserId { get; set; }

        public string UserAuthId { get; set; }

        public string FileType { get; set; }

        public bool NeedStreamResult { get; set; }

    }


    public class DownloadFileResponse2
    {
        [DataMember(Order = 1)]
        public FileMeta FileDetails { get; set; }

        [DataMember(Order = 2)]
        public byte[] FileBytes { get; set; }

        [DataMember(Order = 3)]
        public ResponseStatus ResponseStatus { get; set; }

        [DataMember(Order = 4)]
        public string PreSignedUrl { get; set; }
    }

    public class UploadImageAsyncRequest2
    {
        public ImageMeta ImageInfo { get; set; }

        public byte[] ImageByte { get; set; }

        public string SolutionId { get; set; }

        public int UserIntId { get; set; }
    }

    public class UploadAsyncResponse2
    {
        public int FileRefId { get; set; }

        public ResponseStatus ResponseStatus { get; set; }
    }

    public class ResponseStatus
    {
        public string Message { get; set; }
    }
}
