using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    public class EbConfiguration
    {
        [ProtoBuf.ProtoMember(1)]
        public string ClientID { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public string ClientName { get; set; }

        [ProtoBuf.ProtoMember(3)]
        public string LicenseKey { get; set; }

        [ProtoBuf.ProtoMember(4)]
        public EB_DatabaseConfigurationCollection DatabaseConfigurations { get; set; }

        public EbConfiguration()
        {
            DatabaseConfigurations = new EB_DatabaseConfigurationCollection();
        }
    }

    [ProtoBuf.ProtoContract]
    public class EbDatabaseConfiguration
    {
        [ProtoBuf.ProtoMember(1)]
        public EbDatabases EB_Database { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public DatabaseVendors DatabaseVendor { get; set; }

        [ProtoBuf.ProtoMember(3)]
        public string DatabaseName { get; set; }

        [ProtoBuf.ProtoMember(4)]
        public string Server { get; set; }

        [ProtoBuf.ProtoMember(5)]
        public int Port { get; set; }

        [ProtoBuf.ProtoMember(6)]
        public string UserName { get; set; }

        [ProtoBuf.ProtoMember(7)]
        public string Password { get; set; }

        [ProtoBuf.ProtoMember(8)]
        public int Timeout { get; set; }

        public EbDatabaseConfiguration() { }

        public EbDatabaseConfiguration(EbDatabases eb_db, DatabaseVendors db_v, string db_n, string svr, int prt, string uname, string pwd, int tout)
        {
            EB_Database = eb_db;
            DatabaseVendor = db_v;
            DatabaseName = db_n;
            Server = svr;
            Port = prt;
            UserName = uname;
            Password = pwd;
            Timeout = tout;
        }
    }

    public class EB_DatabaseConfigurationCollection : Dictionary<EbDatabases, EbDatabaseConfiguration>
    {

    }
}

