using ExpressBase.Common.Structures;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.Common;
using System.Data.OracleClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace ExpressBase.Common
{
    public interface IDatabase
    {
        DbConnection GetNewConnection();
        DbConnection GetNewConnection(string dbName);
        DbCommand GetNewCommand(DbConnection con, string sql);
        DbCommand GetNewCommand(DbConnection con, string sql, DbTransaction trans);
        DbParameter GetNewParameter(string parametername, EbDbType type, object value);
        T DoQuery<T>(string query, params DbParameter[] parameters);
        EbDataTable DoQuery(string query, params DbParameter[] parameters);
        DbDataReader DoQueriesBasic(string query, params DbParameter[] parameters);
        EbDataSet DoQueries(string query, params DbParameter[] parameters);
        int DoNonQuery(string query, params DbParameter[] parameters);
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
        bool IsInTransaction();
        bool IsTableExists(string query, params DbParameter[] parameters);
        void CreateTable(string query);
        int InsertTable(string query, params DbParameter[] parameters);


        //---------------------sql query

        string EB_AUTHETICATE_USER_NORMAL { get; }
        string EB_AUTHENTICATEUSER_SOCIAL { get; }
        string EB_AUTHENTICATEUSER_SSO { get; }
        string EB_SIDEBARUSER_REQUEST { get; }
        string EB_GETROLESRESPONSE_QUERY { get; }
        string EB_GETMANAGEROLESRESPONSE_QUERY { get; }
        string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED { get; }
        string EB_SAVEROLES_QUERY { get; }
        string EB_SAVEUSER_QUERY { get; }

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
    }
}

