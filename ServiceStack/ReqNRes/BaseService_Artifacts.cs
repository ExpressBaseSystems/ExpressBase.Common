using ServiceStack;
using System.Runtime.Serialization;

namespace ExpressBase.Common.EbServiceStack.ReqNRes
{
    public interface IEbSSRequest
    {
        string TenantAccountId { get; set; }

        int UserId { get; set; }
    }

    [DataContract]
    public abstract class EbServiceStackRequest
    {
        [DataMember(Order = 1)]
        public string TenantAccountId { get; set; }

        [DataMember(Order = 2)]
        public int UserId { get; set; }

        [DataMember(Order = 3)]
        public string UserAuthId { get; set; }

        [DataMember(Order = 4)]
        public string WhichConsole { get; set; }
    }

    [ProtoBuf.ProtoContract]
    //[ProtoBuf.ProtoInclude(1, typeof(DataSourceColumnsResponse))]
    public interface IEbSSResponse
    {
        ResponseStatus ResponseStatus { get; set; } //Exception gets serialized here
    }

    [DataContract]
    public abstract class EbServiceStackResponse
    {
        [DataMember(Order = 2)]
        public ResponseStatus ResponseStatus { get; set; } //Exception gets serialized here
    }
}
