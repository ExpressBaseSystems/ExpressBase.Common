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
        DbConnection GetNewConnection();
        DbConnection GetNewConnection(string dbName);
        DbCommand GetNewCommand(DbConnection con, string sql);
        DbCommand GetNewCommand(DbConnection con, string sql,DbTransaction trans);
        DbParameter GetNewParameter(string parametername, DbType type, object value);
        DbParameter GetNewParameter(string parametername, NpgsqlTypes.NpgsqlDbType type, object value);
        T DoQuery<T>(string query, params DbParameter[] parameters);
        EbDataTable DoQuery(string query, params DbParameter[] parameters);
        EbDataSet DoQueries(string query, params DbParameter[] parameters);
        int DoNonQuery(string query, params DbParameter[] parameters);
        void BeginTransaction();
        void RollbackTransaction();
        void CommitTransaction();
        bool IsInTransaction();

        //---------------------sql query
        string INSERT_EB_ROLES { get; }
        string INSERT_EB_OBJECTS { get; }
        string INSERT_EB_OPERATIONS { get; }
        string INSERT_EB_PERMISSIONS { get; }
        string INSERT_EB_USERS { get; }
        string DELETE_OBJ_FROM_EB_OBJECTS { get; }
        string DELETE_OBJ_FROM_EB_PERMISSIONS { get; }
        string DELETE_OBJ_FROM_EB_PERMISSION2ROLE { get; }
        string DELETE_OP_FROM_EB_OPERATIONS { get; }
        string DELETE_OP_FROM_EB_PERMISSIONS { get; }
        string DELETE_OP_FROM_EB_PERMISSION2ROLE { get; }
        string DELETE_PER_FROM_EB_PERMISSIONS { get; }
        string DELETE_PER_FROM_EB_PERMISSION2ROLE { get; }
        string DELETE_ROLE_FROM_EB_ROLES { get; }
        string DELETE_ROLE_FROM_EB_ROLE2ROLE { get; }
        string DELETE_ROLE_FROM_EB_ROLE2USER { get; }
        string DELETE_ROLE_FROM_EB_PERMISSION2ROLE { get; }
        string DELETE_USER_FROM_EB_USERS { get; }
        string DELETE_USER_FROM_EB_ROLE2USER { get; }
        string RENAME_ROLE_IN_EB_ROLES { get; }
        string LOAD_ROLE_FROM_EB_ROLES { get; }
        string LOAD_PERMISSION_FROM_EB_PERMISSION { get; }
        string LOAD_USERROLE_FROM_EB_ROLES { get; }
        string LOAD_USERALLPERMISSION_FROM_EB_PERMISSIONS { get; }
        string LOAD_USERALLROLES_FROM_EB_ROLES { get; }
        string LOAD_USERALLDETAILS { get; }
    }
}

