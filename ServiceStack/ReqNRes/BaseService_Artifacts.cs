using ServiceStack;
using System.Runtime.Serialization;

namespace ExpressBase.Common.EbServiceStack.ReqNRes
{
    public interface IEbSSRequest
    {
        string SolnId { get; set; }

        int UserId { get; set; }
    }

    public interface IEbTenentRequest
    {
        string SolnId { get; set; }
        int UserId { get; set; }
    }

    [DataContract]
    public abstract class EbServiceStackAuthRequest
    {
        [DataMember(Order = 1)]
        public string SolnId { get; set; }

        [DataMember(Order = 2)]
        public int UserId { get; set; }

        [DataMember(Order = 3)]
        public string UserAuthId { get; set; }

        [DataMember(Order = 4)]
        public string WhichConsole { get; set; }
    }

    [DataContract]
    public abstract class EbServiceStackNoAuthRequest
    { }

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
    [DataContract]
    public class EbMqRequest
    {
        [DataMember(Order = 1)]
        public string SolnId { get; set; }

        [DataMember(Order = 2)]
        public int UserId { get; set; }

        [DataMember(Order = 3)]
        public string UserAuthId { get; set; }

        [DataMember(Order = 4)]
        public string WhichConsole { get; set; }

        [DataMember(Order = 5)]
        public string BToken { get; set; }

        [DataMember(Order = 6)]
        public string RToken { get; set; }

        public void AddAuth(string btoken, string rtoken)
        {
            BToken = btoken;
            RToken = rtoken;
        }

        public void AddAuth(string solnId, string btoken, string rtoken)
        {
            SolnId = solnId;
            BToken = btoken;
            RToken = rtoken;
        }

        public void AddAuth(int userId, string solnId, string btoken, string rtoken)
        {
            UserId = userId;
            SolnId = solnId;
            BToken = btoken;
            RToken = rtoken;
        }
    }
    [DataContract]
    public class EbMqResponse
    {
        public string ReqType { get; set; }

        public bool IsError { get; set; }

        public string ErrorString { get; set; }
    }
}
