using System.ComponentModel;

namespace ExpressBase.Common
{

    public enum EbApplicationTypes
    {
        Bot = 3,
        Mobile = 2,
        Web = 1
    }

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
        PGSQL,
        MYSQL,
        MSSQL,
        ORACLE,
        MongoDB,
        Cloudinary,
        Cloudfront,
    }

    public enum SmsVendors
    {
        TWILIO = 1,
        EXPERTTEXTING = 2
    }

    public enum ConPreferences
    {
        PRIMARY = 1,
        FALLBACK = 2
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
        Cloudinary = 9,
        FTP = 10
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
        SolutionOwner = 1,
        SolutionAdmin = 2,
        SolutionDeveloper = 3,
        SolutionTester = 4,
        SolutionPM = 5,
        SolutionUser = 6
    }

    public enum EbSystemRoles
    {
        EbAdmin,
        EbReadOnlyUser,
        EbUser
    }

    public enum EbUserStatus
    {
        Active,
        Suspend,
        Terminate
    }

    public enum OracleSysRoles
    {
        CONNECT,
        RESOURCE,
        DBA,
        EXP_FULL_DATABASE,
        IMP_FULL_DATABASE,
        RECOVERY_CATALOG_OWNER
    }

    public enum PGSQLSysRoles
    {
        DELETE,
        INSERT,
        REFERENCES,
        SELECT,
        TRIGGER,
        TRUNCATE,
        UPDATE
    }

    public enum SurveyQTypes
    {
        SingleSelect = 1,
        MultiSelect = 2,
        Rating = 3,
        UserInput = 4
    }

    public enum ThirdPartyIntegrations
    {
        Cloudinary = 1
    }

    public enum JobTypes
    {
        EmailTask = 1,
        SmsTask = 2,
        MyJob = 3
    }
}

