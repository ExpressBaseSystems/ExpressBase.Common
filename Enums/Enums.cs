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
        SQLDB,
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
        SolutionOwner,
		SolutionAdmin,
		SolutionDeveloper,
		SolutionTester,
		SolutionPM,
        SolutionUser
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

}

