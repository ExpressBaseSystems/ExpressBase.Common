using ExpressBase.Common.EbServiceStack.ReqNRes;
using System;
using System.Collections.Generic;
using System.Runtime.Serialization;
using System.Text;

namespace ExpressBase.Common.ServiceStack.ReqNRes
{
    [DataContract]
    public class FileDownloadRequestObject : EbServiceStackRequest
    {
    }

    [DataContract]
    public class FileDownloadResponseObject : EbServiceStackRequest
    {
    }
}
