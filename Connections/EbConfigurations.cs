﻿using ExpressBase.Common.Connections;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    [ProtoBuf.ProtoContract]
    [ProtoBuf.ProtoInclude(1, typeof(EbInfraDBConf))]
    //[ProtoBuf.ProtoInclude(2, typeof(EbClientConf))]
    public interface IEbConf
    {
        EbDatabaseConfCollection DatabaseConfigurations { get; set; }

        EbFilesDbConnection FilesDbConnection { get; set; }
    }

    [ProtoBuf.ProtoContract]
    public class EbInfraDBConf: IEbConf
    {
        private EbDatabaseConfCollection _configurations;
        [ProtoBuf.ProtoMember(1)]
        public EbDatabaseConfCollection DatabaseConfigurations
        {
            get
            {
                if (_configurations == null)
                    _configurations = new EbDatabaseConfCollection(2);

                return _configurations;
            }
            set { _configurations = value; }
        }

        public EbFilesDbConnection FilesDbConnection
        {
            get; set;
        }

        public EbInfraDBConf() { }
    }

    [ProtoBuf.ProtoContract]
    public class EbClientConf 
    {
        [ProtoBuf.ProtoMember(1)]
        public string ClientID { get; set; }

        [ProtoBuf.ProtoMember(2)]
        public string ClientName { get; set; }

        [ProtoBuf.ProtoMember(3)]
        public EbTiers EbClientTier { get; set; }

        private EbDatabaseConfCollection _configurations;
        [ProtoBuf.ProtoMember(4)]
        public EbDatabaseConfCollection DatabaseConfigurations
        {
            get
            {
                if (_configurations == null)
                    _configurations = new EbDatabaseConfCollection(8);

                return _configurations;
            }
            set { _configurations = value; }
        }

        public EbClientConf() { }
    }

    [ProtoBuf.ProtoContract]
    public class EbDatabaseConfiguration
    {
        [ProtoBuf.ProtoMember(1)]
        public EbConnectionTypes EbDatabaseType { get; set; }

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

        public EbDatabaseConfiguration(EbConnectionTypes eb_db, DatabaseVendors db_v, string db_n, string svr, int prt, string uname, string pwd, int tout)
        {
            this.EbDatabaseType = eb_db;
            this.DatabaseVendor = db_v;
            this.DatabaseName = db_n;
            this.Server = svr;
            this.Port = prt;
            this.UserName = uname;
            this.Password = pwd;
            this.Timeout = tout;
        }
    }

    [ProtoBuf.ProtoContract]
    public class EbDatabaseConfCollection : Dictionary<EbConnectionTypes, EbDatabaseConfiguration>
    {
        public EbDatabaseConfCollection() { }

        public EbDatabaseConfCollection(int capacity) : base(capacity) { }
    }
}

