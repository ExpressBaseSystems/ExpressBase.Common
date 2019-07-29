using System.ComponentModel;

namespace ExpressBase.Common
{

    public enum EbApplicationTypes
    {
        Bot = 3,
        Mobile = 2,
        Web = 1
    }

    public enum PricingTiers
    {
        FREE = 0,
        STANDARD = 1
    }

    public enum DatabaseVendors // Used to cast to EbIntegrations. Dont change order n name
    {
        PGSQL = 1,
        MYSQL = 2,
        MSSQL = 3,
        ORACLE = 4
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
        FALLBACK = 2,
        OTHER = 3
    }

    public enum EbConnectionTypes
    {
        EbOBJECTS = 1,
        EbDATA = 2,
        EbFILES = 4,
        EbLOGS = 5,
        SMTP = 6,
        SMS = 7,
        Slack = 8,
        Cloudinary = 9,
        MAPS =11
    }

    public enum EbIntegrations
    {
        PGSQL = 1,
        MYSQL = 2,
        MSSQL = 3,
        ORACLE = 4,
        Twilio = 5,
        ExpertTexting = 6,
        MongoDB = 7,
        SMTP = 8,
        Cloudinary = 9,
        GoogleMap = 10,
        SendGrid = 11
    }

    public enum SmtpProviders
    {
        Gmail = 1
    }

    //public enum EbConnections
    //{
    //    EbOBJECTS = 1,
    //    EbDATA = 2,
    //    EbFILES = 3,
    //    EbLOGS = 4,
    //    SMTP = 5,
    //    SMS = 6,
    //    Cloudinary = 7,
    //    MAPS = 8
    //}

    public enum MapVendors
    {
        GOOGLEMAP
    }
    public enum SendGridVendors
    {
        SENDGRID
    }

    public enum MapType
    {
        COMMON
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
        Terminate,
        Delete
    }

    public enum EbConstraintTypes
    {
        UserGroup_Ip = 1,
        UserGroup_Date = 2,
        UserGroup_Time = 3,
        UserGroup_Days = 4,
        User_Location = 5,
        User_DeviceId = 6
    }

    public enum EbConstraintOperators
    {
        EqualTo = 1,
        GreaterThan = 2,
        LessThan = 3
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

    public enum MySqlSysRoles
    {
        //CONNECT,
        //RESOURCE,
        //DBA
        SELECT,
        INSERT,
        UPDATE,
        DELETE,
        CREATE,
        DROP,
        RELOAD,
        SHUTDOWN,
        PROCESS,
        FILE,
        REFERENCES,
        INDEX,
        ALTER,
        SHOW___DATABASES,
        SUPER,
        CREATE___TEMPORARY___TABLES,
        LOCK___TABLES,
        EXECUTE,
        REPLICATION___SLAVE,
        REPLICATION___CLIENT,
        CREATE___VIEW,
        SHOW___VIEW,
        CREATE___ROUTINE,
        ALTER___ROUTINE,
        CREATE___USER,
        EVENT,
        TRIGGER,
        CREATE___TABLESPACE,
        CREATE___ROLE,
        DROP___ROLE,
        XA_RECOVER_ADMIN,
        TABLE_ENCRYPTION_ADMIN,
        SYSTEM_VARIABLES_ADMIN,
        SYSTEM_USER,
        SET_USER_ID,
        SESSION_VARIABLES_ADMIN,
        SERVICE_CONNECTION_ADMIN,
        ROLE_ADMIN,
        RESOURCE_GROUP_USER,
        RESOURCE_GROUP_ADMIN,
        REPLICATION_SLAVE_ADMIN,
        PERSIST_RO_VARIABLES_ADMIN,
        INNODB_REDO_LOG_ARCHIVE,
        GROUP_REPLICATION_ADMIN,
        ENCRYPTION_KEY_ADMIN,
        CONNECTION_ADMIN,
        CLONE_ADMIN,
        BINLOG_ENCRYPTION_ADMIN,
        BINLOG_ADMIN,
        BACKUP_ADMIN,
        AUDIT_ADMIN,
        APPLICATION_PASSWORD_ADMIN
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
        ReportTask = 3,
        MyJob = 4
    }

    public enum ScheduleStatuses
    {
        Unscheduled = 0,
        Active = 1,
        Paused = 2,
        Deleted = 3
    }

    public enum WebFormModes
    {
        View_Mode = 1,
        New_Mode = 2,
        Edit_Mode = 3,
        Fail_Mode = 4,
        Preview_Mode = 5
    }

    public enum WebFormAfterSaveModes
    {
        View_Mode = 0,
        New_Mode = 1,
        Edit_Mode = 2,
        Close_Mode = 3
    }

    public enum WebFormDVModes
    {
        _SELECT_ = 0,
        View_Mode = 1,
        New_Mode = 2
    }

    public enum RedisOperations
    {
        Edit,
        Delete
    }

    public enum DBOperations
    {
        SELECT,
        CREATE,
        INSERT,
        DELETE,
        ALTER,
        UPDATE,
        DROP,
        TRUNCATE
    }
}

