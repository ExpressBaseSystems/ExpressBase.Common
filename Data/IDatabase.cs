using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public interface IDatabase
    {
        DatabaseVendors Vendor { get; }
        IVendorDbTypes VendorDbTypes { get; }

        DbConnection GetNewConnection();
        DbConnection GetNewConnection(string dbName);
        DbCommand GetNewCommand(DbConnection con, string sql);
       // DbCommand GetNewCommand(DbConnection con, string sql, DbTransaction trans);
        DbParameter GetNewParameter(string parametername, EbDbTypes type, object value);

        DbParameter GetNewParameter(string parametername, EbDbTypes type);

        DbParameter GetNewOutParameter(string parametername, EbDbTypes type);

        T DoQuery<T>(string query, params DbParameter[] parameters);
        EbDataTable DoQuery(string query, params DbParameter[] parameters);
        EbDataTable DoProcedure(string query, params DbParameter[] parameters);
        DbDataReader DoQueriesBasic(string query, params DbParameter[] parameters);
        EbDataSet DoQueries(string query, params DbParameter[] parameters);
        int DoNonQuery(string query, params DbParameter[] parameters);
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
        bool IsInTransaction();
        bool IsTableExists(string query, params DbParameter[] parameters);
        int CreateTable(string query);
        int InsertTable(string query, params DbParameter[] parameters);
        int AlterTable(string query, params DbParameter[] parameters);
        int DeleteTable(string query, params DbParameter[] parameters);
        int UpdateTable(string query, params DbParameter[] parameters);
        EbDbTypes ConvertToDbType(Type typ);
        ColumnColletion GetColumnSchema(string table);
        string DBName { get; }
        //string ConvertToDbDate(string datetime_);

        //---------------------sql query

        string EB_AUTHETICATE_USER_NORMAL { get; }
        string EB_AUTHENTICATEUSER_SOCIAL { get; }
        string EB_AUTHENTICATEUSER_SSO { get; }
        string EB_AUTHENTICATE_ANONYMOUS { get; }
        string EB_SIDEBARUSER_REQUEST { get; }
        string EB_SIDEBARDEV_REQUEST { get; }
        string EB_SIDEBARCHECK { get; }
        string EB_GETROLESRESPONSE_QUERY { get; }
        string EB_GETMANAGEROLESRESPONSE_QUERY { get; }
        string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get; }
        string EB_SAVEROLES_QUERY { get; }
        string EB_SAVEUSER_QUERY { get; }
        string EB_SAVEUSERGROUP_QUERY { get; }
        string EB_USER_ROLE_PRIVS { get; }
        string EB_INITROLE2USER { get; }
		string EB_MANAGEUSER_FIRST_QUERY { get; }
        string EB_GETUSERDETAILS { get; }
        string EB_GETDBCLIENTTTABLES { get; }
        string EB_UNIQUEEMAILCHECK { get; }

        string EB_GETTABLESCHEMA { get; }
        string EB_GETCHART2DETAILS { get; }
        string EB_GETPROFILERS { get; }
        string EB_GETUSEREMAILS { get; }
        string EB_GETPARTICULARSSURVEY { get; }
        string EB_SURVEYMASTER { get; }

        //........objects db query.....
        string EB_FETCH_ALL_VERSIONS_OF_AN_OBJ { get; }
        string EB_PARTICULAR_VERSION_OF_AN_OBJ { get; }
        string EB_LATEST_COMMITTED_VERSION_OF_AN_OBJ { get; }
        string EB_ALL_LATEST_COMMITTED_VERSION_OF_AN_OBJ { get; }
        string EB_GET_LIVE_OBJ_RELATIONS { get; }
        string EB_GET_TAGGED_OBJECTS { get; }
        string EB_GET_ALL_COMMITTED_VERSION_LIST { get; }
        string EB_GET_OBJ_LIST_FROM_EBOBJECTS { get; }
        string EB_GET_OBJ_STATUS_HISTORY { get; }
        string EB_LIVE_VERSION_OF_OBJS { get; }
        string EB_GET_ALL_TAGS { get; }

        string EB_GET_BOT_FORM { get; }
        string IS_TABLE_EXIST { get; }
        string EB_CREATEAPPLICATION { get; }
        string EB_CREATEAPPLICATION_DEV { get; }

        string EB_CREATELOCATIONCONFIG1Q { get; }
        string EB_CREATELOCATIONCONFIG2Q { get; }
        string EB_GET_MLSEARCHRESULT { get; }
        string EB_MLADDKEY { get; }
        string EB_SAVELOCATION { get; }
        string Eb_ALLOBJNVER { get; }
                
        //....obj function call....
        string EB_CREATE_NEW_OBJECT { get; }
        string EB_SAVE_OBJECT { get; }
        string EB_COMMIT_OBJECT { get; }
        string EB_EXPLORE_OBJECT { get; }
        string EB_MAJOR_VERSION_OF_OBJECT { get; }
        string EB_MINOR_VERSION_OF_OBJECT { get; }
        string EB_CHANGE_STATUS_OBJECT { get; }
        string EB_PATCH_VERSION_OF_OBJECT { get; }
        string EB_UPDATE_DASHBOARD { get; }
        string EB_LOCATION_CONFIGURATION { get;}
        string EB_CREATEBOT { get; }

        //....files query...
        string EB_IMGREFUPDATESQL { get; }
        string EB_DPUPDATESQL { get; }
        string EB_LOGOUPDATESQL { get; }
        string Eb_MQ_UPLOADFILE { get; }
        string EB_FILEEXISTS { get; }
        string EB_GETFILEREFID { get; }

    }
}

