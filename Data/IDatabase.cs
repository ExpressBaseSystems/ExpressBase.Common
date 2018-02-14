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
        DbCommand GetNewCommand(DbConnection con, string sql,DbTransaction trans);
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

        //---------------------sql query

        string EB_AUTHETICATE_USER_NORMAL { get; }
        string EB_AUTHENTICATEUSER_SOCIAL { get; }
        string EB_AUTHENTICATEUSER_SSO { get; }
    }
}

