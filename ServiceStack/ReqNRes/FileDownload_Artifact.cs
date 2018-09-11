using CloudinaryDotNet;
using ExpressBase.Common.EbServiceStack.ReqNRes;
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
}
