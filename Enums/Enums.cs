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
    }

    public enum FilesDbVendors
    {
        MongoDB,
        Cloudinary,
        Cloudfront,
    }

    public enum EbConnectionTypes
    {
        EbINFRA,
        EbINFRA_FILES,
        EbINFRA_LOGS,
        EbOBJECTS,
        EbDATA,
        EbDATA_RO,
        EbFILES,
        Email,
        SMS,
        Slack,
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

    public enum SystemRoles
    {
        Eb_Admin,
        Eb_ReadOnlyUser,
        Account_Owner,
        Account_Admin,
        Account_Developer,
        Account_Tester,
        Account_PM
    }

    

}

