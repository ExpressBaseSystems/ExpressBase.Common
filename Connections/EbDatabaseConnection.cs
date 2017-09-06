using System;
using System.Collections.Generic;
using System.Text;

namespace ExpressBase.Common.Connections
{
    [ProtoBuf.ProtoContract]
    public abstract class EbBaseDatabaseConnection
    {
        [ProtoBuf.ProtoMember(1)]
        public string DatabaseName { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public string Server { get; set; }

        [ProtoBuf.ProtoMember(3)]
        public int Port { get; set; }

        [ProtoBuf.ProtoMember(4)]
        public string UserName { get; set; }

        [ProtoBuf.ProtoMember(5)]
        public string Password { get; set; }

        [ProtoBuf.ProtoMember(6)]
        public int Timeout { get; set; }
    }

    [ProtoBuf.ProtoContract]
    public class EbObjectsDatabaseConnection: EbBaseDatabaseConnection
    {
        [ProtoBuf.ProtoMember(1)]
        public DatabaseVendors DatabaseVendor { get; set; }
    }

    [ProtoBuf.ProtoContract]
    public class EbDataDatabaseConnection: EbBaseDatabaseConnection
    {
        [ProtoBuf.ProtoMember(1)]
        public DatabaseVendors DatabaseVendor { get; set; }
    }

    [ProtoBuf.ProtoContract]
    public class EbFilesDatabaseConnection : EbBaseDatabaseConnection
    {
        [ProtoBuf.ProtoMember(1)]
        public FilesDbVendors DatabaseVendor { get; set; }
    }
}
