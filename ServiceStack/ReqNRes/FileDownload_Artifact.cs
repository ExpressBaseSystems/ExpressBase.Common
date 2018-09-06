using CloudinaryDotNet;
using ExpressBase.Common.EbServiceStack.ReqNRes;
using System.Runtime.Serialization;

namespace ExpressBase.Common.ServiceStack.ReqNRes
{
    [DataContract]
    public class FileDownloadRequestObject : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public Account Account { get; set; }
    }

    [DataContract]
    public class FileDownloadResponseObject : EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        string test = string.Empty;
    }
}
