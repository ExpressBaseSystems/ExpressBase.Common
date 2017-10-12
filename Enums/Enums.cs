using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public enum EbTiers
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
        EbOBJECTS = 1,
        EbDATA = 2,
        EbDATA_RO = 3,
        EbFILES = 4,
        EbLOGS = 5,
        SMTP = 6,
        SMS = 7,
        Slack = 8,
    }
    public enum FileTypes
    {
        jpg = 1,
        jpeg = 2,
        png = 3,
        svg = 4,
        gif = 5,

        pdf = 101,
        doc = 102,
        docx = 103,
        xlsx = 104,
        pptx = 105,
        txt = 106
    }

    public enum ImageTypes
    {
        jpg = 1,
        jpeg = 2,
        png = 3,
        svg = 4,
        gif = 5
    }

    public enum DocTypes
    {
        pdf = 101,
        doc = 102,
        docx = 103,
        xlsx = 104,
        pptx = 105,
        txt = 106
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

    public enum EbSystemRoles
    {
        Eb_Admin,
        Eb_ReadOnlyUser,
        Eb_User
    }

}

