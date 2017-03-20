using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public enum EbClientTiers
    {
        Free,
        Professional,
        Enterprise,
        Unlimited
    }

    public enum DatabaseVendors
    {
        PGSQL,
        MYSQL,
        MSSQL,
        ORACLE,
        MONGODB,
    }

    public enum EbDatabaseTypes
    {
        EbINFRA,
        EbINFRA_RO,
        EbOBJECTS,
        EbOBJECTS_RO,
        EbDATA,
        EbDATA_RO,
        EbLOGS,
        EbLOGS_RO,
        EbFILES,
        EbFILES_RO
    }

    public enum StudioFormTypes
    {
        Desktop,
        Web,
        Mobile,
        UserControl
    }

    public enum WebPageLoginStateTypes
    {
        TenantExt,
        TenantInt,
        TenantUserExt,
        TenantUserInt
    }

    class Enums
    {
    }
}

