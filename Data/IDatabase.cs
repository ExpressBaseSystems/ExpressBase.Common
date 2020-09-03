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
    public abstract class IDatabase
    {
        public virtual DatabaseVendors Vendor { get; }
        public virtual IVendorDbTypes VendorDbTypes { get; }

        public abstract DbConnection GetNewConnection();
        public abstract DbConnection GetNewConnection(string dbName);
        public abstract DbCommand GetNewCommand(DbConnection con, string sql);
        // DbCommand GetNewCommand(DbConnection con, string sql, DbTransaction trans);
        public abstract DbParameter GetNewParameter(string parametername, EbDbTypes type, object value);

        public abstract DbParameter GetNewParameter(string parametername, EbDbTypes type);

        public abstract DbParameter GetNewOutParameter(string parametername, EbDbTypes type);

        public abstract T DoQuery<T>(string query, params DbParameter[] parameters);
        public abstract EbDataTable DoQuery(string query, params DbParameter[] parameters);
        public abstract EbDataTable DoProcedure(string query, params DbParameter[] parameters);
        public abstract EbDataSet DoQueries(string query, params DbParameter[] parameters);
        public abstract int DoNonQuery(string query, params DbParameter[] parameters);
        public abstract EbDataSet DoQueries(DbConnection dbConnection, string query, params DbParameter[] parameters);
        public abstract EbDataTable DoProcedure(DbConnection dbConnection, string query, params DbParameter[] parameters);
        public abstract EbDataTable DoQuery(DbConnection dbConnection, string query, params DbParameter[] parameters);
        protected abstract DbDataReader DoQueriesBasic(DbConnection dbConnection, string query, params DbParameter[] parameters);
        public abstract int DoNonQuery(DbConnection dbConnection, string query, params DbParameter[] parameters);
        public abstract T ExecuteScalar<T>(string query, params DbParameter[] parameters);
        public abstract Dictionary<int, string> GetDictionary(string query, string dm, string vm);
        public abstract List<int> GetAutoResolveValues(string sql, string name, string cond);
        public abstract void BeginTransaction();
        public abstract void RollbackTransaction();
        public abstract void CommitTransaction();
        public abstract bool IsInTransaction();
        public abstract bool IsTableExists(string query, params DbParameter[] parameters);
        public abstract int CreateTable(string query);
        public abstract int InsertTable(string query, params DbParameter[] parameters);
        public abstract int AlterTable(string query, params DbParameter[] parameters);
        public abstract int DeleteTable(string query, params DbParameter[] parameters);
        public abstract int UpdateTable(string query, params DbParameter[] parameters);
        public abstract EbDbTypes ConvertToDbType(Type typ);
        public abstract ColumnColletion GetColumnSchema(string table);
        public virtual string DBName { get; }
        //string ConvertToDbDate(string datetime_);

        //---------------------sql query

        public virtual string EB_PARAM_SYMBOL { get { return "@"; } }

        public virtual string EB_AUTHETICATE_USER_NORMAL { get; }
        public virtual string EB_AUTHENTICATEUSER_SOCIAL { get; }
        public virtual string EB_AUTHENTICATEUSER_SSO { get; }
        public virtual string EB_AUTHENTICATE_ANONYMOUS { get; }
        public virtual string EB_SIDEBARUSER_REQUEST { get; }
        public virtual string EB_SIDEBARCHECK { get; }
        public virtual string EB_GETROLESRESPONSE_QUERY { get; }
        public virtual string EB_GETMANAGEROLESRESPONSE_QUERY
        {
            get
            {
                return @"SELECT id, applicationname FROM eb_applications where eb_del = 'F' ORDER BY applicationname;
                        SELECT DISTINCT EO.id, EO.display_name, EO.obj_type, EO2A.app_id
                            FROM eb_objects EO, eb_objects_ver EOV, eb_objects_status EOS, eb_objects2application EO2A 
                            WHERE EO.id = EOV.eb_objects_id AND EOV.id = EOS.eb_obj_ver_id AND EOS.status = 3 
                                AND EOS.id = ANY(SELECT MAX(id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id)
                                AND EO.id = EO2A.obj_id AND EO2A.eb_del = 'F' AND COALESCE(EO.eb_del, 'F') = 'F'; 
                        SELECT id, role_name, description, applicationid, is_anonymous FROM eb_roles WHERE id <> @id ORDER BY role_name;
                        SELECT id, role1_id, role2_id FROM eb_role2role WHERE eb_del = 'F';
                        SELECT id, longname, shortname FROM eb_locations;";
            }
        }
        public virtual string EB_GETMANAGEROLESRESPONSE_QUERY_EXTENDED
        {
            get
            {
                return @"SELECT role_name,applicationid,description,is_anonymous FROM eb_roles WHERE id = @id;
						SELECT permissionname,obj_id,op_id FROM eb_role2permission WHERE role_id = @id AND eb_del = 'F';
						SELECT A.applicationname, A.description FROM eb_applications A, eb_roles R WHERE A.id = R.applicationid AND R.id = @id AND A.eb_del = 'F';
						SELECT A.id, A.fullname, A.email, B.id FROM eb_users A, eb_role2user B
							WHERE A.id = B.user_id AND A.eb_del = 'F' AND B.eb_del = 'F' AND B.role_id = @id;
						SELECT locationid FROM eb_role2location WHERE roleid = @id AND eb_del='F';";
            }
        }
        public virtual string EB_SAVEROLES_QUERY { get; }
        public virtual string EB_SAVEUSER_QUERY { get; }
        public virtual string EB_SAVEUSERGROUP_QUERY { get; }
        public virtual string EB_USER_ROLE_PRIVS { get; }
        public virtual string EB_INITROLE2USER
        {
            get
            {
                return @"INSERT INTO eb_role2user(role_id, user_id, createdat) VALUES (@role_id, @user_id, now());";
            }
        }
        public virtual string EB_MANAGEUSER_FIRST_QUERY
        {
            get
            {
                return @"SELECT id, role_name, description FROM eb_roles ORDER BY role_name;
                        SELECT id, name,description FROM eb_usergroup ORDER BY name;
						SELECT id, role1_id, role2_id FROM eb_role2role WHERE COALESCE(eb_del, 'F') = 'F';
                        SELECT id, name FROM eb_user_types WHERE COALESCE(eb_del, 'F') = 'F';";
            }
        }
        public virtual string EB_GETUSERDETAILS { get; }
        public virtual string EB_GETDBCLIENTTTABLES { get; }
        public virtual string EB_GET_MYPROFILE_OBJID { get; }

        public virtual string EB_GETTABLESCHEMA { get; }
        public virtual string EB_GET_CHART_2_DETAILS { get; }
        public virtual string EB_GETUSEREMAILS { get; }
        public virtual string EB_GETPARTICULARSSURVEY { get; }
        public virtual string EB_SURVEYMASTER { get; }

        public virtual string EB_CURRENT_TIMESTAMP { get; }
        public virtual string EB_SAVESURVEY { get; }

        public virtual string EB_PROFILER_QUERY_COLUMN { get; }
        public virtual string EB_PROFILER_QUERY_DATA { get; }
        public virtual string EB_GET_PROFILERS { get; }
        public virtual string EB_GET_CHART_DETAILS { get; }
        public virtual string EB_INSERT_EXECUTION_LOGS
        {
            get
            {
                return @"INSERT INTO eb_executionlogs(rows, exec_time, created_by, created_at, params, refid) 
                                VALUES(@rows, @exec_time, @created_by, @created_at, @params, @refid);";
            }
        }

        public virtual string EB_GET_SELECT_CONSTRAINTS
        {
            get
            {
                return @"SELECT m.id, m.key_id, m.key_type, m.description, l.id AS lid, l.c_type, l.c_operation, l.c_value 
	                    FROM eb_constraints_master m, eb_constraints_line l
	                    WHERE m.id = l.master_id AND key_type = {0} AND m.key_id = @{1} AND eb_del = 'F' ORDER BY m.id;";
            }
        }
        public virtual string EB_SAVE_LOCATION_2Q
        {
            get
            {
                return @"UPDATE eb_locations SET longname= @lname, shortname = @sname, image = @img, meta_json = @meta WHERE id = @lid;";
            }
        }
        public virtual string EB_DELETE_LOC
        {
            get
            {
                return @"UPDATE eb_location_config SET eb_del = 'T' WHERE id = @id;";
            }
        }

        public virtual string EB_LOGIN_ACTIVITY_ALL_USERS { get; }

        public virtual string EB_LOGIN_ACTIVITY_USERS { get; }

        public virtual string EB_GET_DISTINCT_VALUES
        {
            get
            {
                return @"SELECT DISTINCT TRIM(@ColumName) AS @ColumName FROM @TableName ORDER BY @ColumName;";
            }
        }
        public virtual string EB_GET_USER_DASHBOARD_OBJECTS { get; }
        public virtual string EB_GET_MOB_MENU_OBJ_IDS { get; }
        public virtual string EB_GET_MOBILE_PAGES { get; }
        public virtual string EB_GET_MOBILE_PAGES_OBJS { get; }
        public virtual string EB_GET_MYACTIONS { get; }

        //........objects db query.....
        public virtual string EB_FETCH_ALL_VERSIONS_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                            EOV.id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.commit_uid, EU.fullname
                        FROM 
                            eb_objects_ver EOV, eb_users EU
                        WHERE
                            EOV.commit_uid = EU.id AND
                            EOV.eb_objects_id=(SELECT eb_objects_id FROM eb_objects_ver WHERE refid = @refid)
                        ORDER BY
                            EOV.id DESC ";
            }
        }
        public virtual string EB_PARTICULAR_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT
                            obj_json, version_num, status, EO.obj_tags, EO.obj_type
                        FROM
                            eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO
                        WHERE
                            EOV.refid = @refid AND EOS.eb_obj_ver_id = EOV.id AND EO.id = EOV.eb_objects_id
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
	                        EOS.id DESC 
                        LIMIT 1";
            }
        }
        public virtual string EB_LATEST_COMMITTED_VERSION_OF_AN_OBJ
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status, EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.obj_json, EOV.refid
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        WHERE
                            EO.id = EOV.eb_objects_id AND EOV.refid = @refid
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
                            EO.obj_type";
            }
        }
        public virtual string EB_COMMITTED_VERSIONS_OF_ALL_OBJECTS_OF_A_TYPE
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog,EOV.commit_ts, EOV.commit_uid, EOV.refid,
                            EU.fullname, EO.display_name
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid = EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id AND EO.obj_type = @type
                            AND COALESCE( EO.eb_del, 'F') = 'F'
                        ORDER BY
                            EO.obj_name";
            }
        }
        public virtual string EB_GET_LIVE_OBJ_RELATIONS
        {
            get
            {
                return @"SELECT 
	                        EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status
                        FROM 
	                        eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS
                        WHERE 
	                        EO.id = ANY (SELECT eb_objects_id FROM eb_objects_ver WHERE refid IN(SELECT dependant FROM eb_objects_relations
                                                  WHERE dominant = @dominant))
                            AND EOV.refid = ANY(SELECT dependant FROM eb_objects_relations WHERE dominant = @dominant)    
                            AND EO.id =EOV.eb_objects_id  AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17)
                            AND COALESCE( EO.eb_del, 'F') = 'F'";
            }
        }
        public virtual string EB_GET_TAGGED_OBJECTS { get; }
        public virtual string EB_GET_ALL_COMMITTED_VERSION_LIST
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.refid,
                            EU.fullname, EO.display_name
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid = EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id  AND EO.obj_type = @type AND COALESCE(EOV.working_mode, 'F') <> 'T'
                            AND COALESCE( EO.eb_del, 'F') = 'F' 
                        ORDER BY
                            EO.obj_name , EOV.id";
            }
        }

        public virtual string EB_GET_ALL_PUBLIC_COMMITTED_VERSION_LIST
        {
            get
            {
                return @"SELECT 
                            EO.id, EO.obj_name, EO.obj_type, EO.obj_cur_status,EO.obj_desc,
                            EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.refid,
                            EU.fullname, EO.display_name
                        FROM 
                            eb_objects EO, eb_objects_ver EOV
                        LEFT JOIN
	                        eb_users EU
                        ON 
	                        EOV.commit_uid = EU.id
                        WHERE
                            EO.id = EOV.eb_objects_id  AND EO.obj_type = @type AND COALESCE(EOV.working_mode, 'F') <> 'T'
                            AND COALESCE( EO.eb_del, 'F') = 'F' AND COALESCE( EO.is_public, 'F') = 'T'
                        ORDER BY
                            EO.obj_name , EOV.id";
            }
        }
        public virtual string EB_GET_OBJECTS_OF_A_TYPE
        {
            get
            {
                return @"SELECT 
                                id, obj_name, obj_type, obj_cur_status, obj_desc  
                            FROM 
                                eb_objects
                            WHERE
                                obj_type = @type
                                AND COALESCE( eb_del, 'F') = 'F'
                            ORDER BY
                                obj_name";
            }
        }
        public virtual string EB_GET_OBJ_STATUS_HISTORY
        {
            get
            {
                return @"SELECT 
                                EOS.eb_obj_ver_id, EOS.status, EU.fullname, EOS.ts, EOS.changelog, EOV.commit_uid   
                            FROM
                                eb_objects_status EOS, eb_objects_ver EOV, eb_users EU
                            WHERE
                                eb_obj_ver_id = EOV.id AND EOV.refid = @refid AND EOV.commit_uid = EU.id
                            ORDER BY 
                                EOS.id DESC";
            }
        }
        public virtual string EB_LIVE_VERSION_OF_OBJS
        {
            get
            {
                return @"SELECT
                                EO.id, EO.obj_name, EO.obj_type, EO.obj_desc,
                                EOV.id, EOV.eb_objects_id, EOV.version_num, EOV.obj_changelog, EOV.commit_ts, EOV.commit_uid, EOV.obj_json, EOV.refid, EOS.status
                            FROM
                                eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO
                            WHERE
                                EO.id = @id AND EOV.eb_objects_id = EO.id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id
                                AND COALESCE( EO.eb_del, 'F') = 'F'
                            ORDER BY EOV.eb_objects_id	LIMIT 1;";
            }
        }
        public virtual string EB_GET_ALL_TAGS { get; }

        public virtual string EB_GET_BOT_FORM { get; }
        public virtual string IS_TABLE_EXIST { get; }
        public virtual string EB_CREATEAPPLICATION_DEV { get; }
        public virtual string EB_EDITAPPLICATION_DEV
        {
            get
            {
                return @"UPDATE 
                            eb_applications 
                        SET 
                            applicationname = @applicationname,
                            application_type = @apptype,
                            description = @description,
                            app_icon = @appicon
                        WHERE
                            id = @appid";
            }
        }

        public virtual string EB_CREATELOCATIONCONFIG1Q { get; }
        public virtual string EB_CREATELOCATIONCONFIG2Q { get; }
        public virtual string EB_GET_MLSEARCHRESULT { get; }
        public virtual string EB_MLADDKEY { get; }
        public virtual string EB_SAVELOCATION { get; }
        public virtual string EB_ALLOBJNVER { get; }
        public virtual string EB_ADD_FAVOURITE
        {
            get
            {
                return @"INSERT INTO 
                                eb_objects_favourites(userid,object_id)
                            VALUES(@userid,@objectid)";
            }
        }
        public virtual string EB_REMOVE_FAVOURITE
        {
            get
            {
                return @"UPDATE 
                                eb_objects_favourites SET eb_del= 'T' 
                           WHERE 
                                userid = @userid 
                           AND 
                                object_id = @objectid";
            }
        }
        public virtual string EB_GET_APPLICATIONS
        {
            get
            {
                return @"SELECT id, applicationname, description, application_type, app_icon, app_settings FROM eb_applications WHERE id = @id AND eb_del = 'F'";
            }
        }
        public virtual string EB_GET_OBJECTS_BY_APP_ID
        {
            get
            {
                return @"SELECT applicationname,description,app_icon,application_type, app_settings FROM eb_applications WHERE id = @appid AND  eb_del = 'F';
				                SELECT 
				                     EO.id, EO.obj_type, EO.obj_name, EO.obj_desc, EO.display_name,EOV.refid,EOV.working_mode,EOV.version_num
				                FROM
				                     eb_objects_ver EOV,eb_objects EO
				                INNER JOIN
				                     eb_objects2application EO2A
				                ON
				                     EO.id = EO2A.obj_id
				                WHERE 
				                    EO2A.app_id = @appid
								    AND	EO.id = EOV.eb_objects_id
                                    AND	COALESCE(EO.eb_del, 'F') = 'F'
                                    AND COALESCE(EO2A.eb_del, 'F') = 'F'
				                ORDER BY
				                    EO.obj_type;";
            }
        }
        public virtual string EB_SAVE_APP_SETTINGS
        {
            get
            {
                return @"UPDATE eb_applications SET app_settings = @newsettings WHERE id = @appid AND application_type = @apptype AND eb_del='F';";
            }
        }
        public virtual string EB_UNIQUE_APPLICATION_NAME_CHECK
        {
            get
            {
                return @"SELECT id FROM eb_applications WHERE applicationname = @name ;";
            }
        }
        public virtual string EB_DELETE_APP
        {
            get
            {
                return @"UPDATE eb_applications SET eb_del = 'T' WHERE id = @appid";
            }
        }
        public virtual string EB_UPDATE_APP_SETTINGS
        {
            get
            {
                return @"UPDATE eb_applications SET app_settings = @settings WHERE id = @appid";
            }
        }
        public virtual string EB_OBJ_ALL_VER_WIHOUT_CIRCULAR_REF
        {
            get
            {
                return @" SELECT 
                                EO.id, EO.obj_name, EO.display_name, 
                                EOV.id, EOV.version_num, EOV.refid
                            FROM
                                eb_objects EO, eb_objects_ver EOV
                            WHERE
                                EO.id = EOV.eb_objects_id AND
                                EOV.working_mode = 'F' AND
                                EO.obj_type = @obj_type 
                            ORDER BY 
                                EO.display_name ASC, EOV.version_num DESC;";
            }
        }
        public virtual string EB_OBJ_ALL_VER_WIHOUT_CIRCULAR_REF_REFID
        {
            get
            {
                return @"SELECT 
                                EO.id, EO.obj_name, EO.display_name, 
                                EOV.id, EOV.version_num, EOV.refid
                            FROM
                                eb_objects EO, eb_objects_ver EOV
                            WHERE
                                EO.id = EOV.eb_objects_id AND
                                EOV.working_mode = 'F' AND
                                EO.obj_type = @obj_type AND
                                EOV.refid != @dominant AND
                                EOV.refid NOT IN (
                                    WITH RECURSIVE objects_relations AS (
	                                SELECT dependant FROM eb_objects_relations WHERE eb_del='F' AND dominant = @dominant
	                                UNION
	                                SELECT a.dependant FROM eb_objects_relations a, objects_relations b WHERE a.eb_del='F' AND a.dominant = b.dependant
                                    )SELECT * FROM objects_relations
                                )
                            ORDER BY 
                                EO.display_name ASC, EOV.version_num DESC;   ";
            }
        }
        public virtual string EB_UNIQUE_OBJECT_NAME_CHECK
        {
            get
            {
                return @"SELECT id FROM eb_objects WHERE display_name = @name ;";
            }
        }
        public virtual string EB_ENABLE_LOG
        {
            get
            {
                return @"UPDATE eb_objects SET is_logenabled = @log WHERE id = @id";
            }
        }
        public virtual string EB_DELETE_OBJECT
        {
            get
            {
                return @"UPDATE eb_objects SET eb_del='T' WHERE id = @id;             
                           UPDATE eb_objects_ver SET eb_del='T' WHERE eb_objects_id = @id;";
            }
        }
        public virtual string EB_CHANGE_OBJECT_ACCESS
        {
            get
            {
                return @"UPDATE eb_objects SET is_public= @status WHERE id = @id; ";
            }
        }

        //....obj function call....
        public virtual string EB_CREATE_NEW_OBJECT { get; }
        public virtual string EB_SAVE_OBJECT { get; }
        public virtual string EB_COMMIT_OBJECT { get; }
        public virtual string EB_EXPLORE_OBJECT { get; }
        public virtual string EB_MAJOR_VERSION_OF_OBJECT { get; }
        public virtual string EB_MINOR_VERSION_OF_OBJECT { get; }
        public virtual string EB_CHANGE_STATUS_OBJECT { get; }
        public virtual string EB_PATCH_VERSION_OF_OBJECT { get; }
        public virtual string EB_UPDATE_DASHBOARD { get; }
        public virtual string EB_CREATEBOT { get; }

        //....files query...
        public virtual string EB_IMGREFUPDATESQL { get; }
        public virtual string EB_DPUPDATESQL { get; }
        public virtual string EB_MQ_UPLOADFILE { get; }
        public virtual string EB_GETFILEREFID { get; }
        public virtual string EB_UPLOAD_IDFETCHQUERY { get; }
        public virtual string EB_FILECATEGORYCHANGE { get; }
        public virtual string EB_DOWNLOAD_FILE_BY_ID
        {
            get
            {
                return @"SELECT
                                B.filestore_sid , B.filedb_con_id
                            FROM 
                                eb_files_ref A, eb_files_ref_variations B
                            WHERE 
                                A.id=B.eb_files_ref_id AND A.id = @fileref;";
            }
        }
        public virtual string EB_DOWNLOAD_IMAGE_BY_ID
        {
            get
            {
                return @"SELECT 
                                B.imagequality_id, B.filestore_sid, B.filedb_con_id
                            FROM 
                                eb_files_ref A, eb_files_ref_variations B
                            WHERE 
                                A.id=B.eb_files_ref_id AND A.id = @fileref
                            ORDER BY 
                                B.imagequality_id;";
            }
        }
        public virtual string EB_DOWNLOAD_DP
        {
            get
            {
                return @"SELECT 
                                V.filestore_sid , V.filedb_con_id
                            FROM 
                                eb_files_ref_variations V 
                            INNER JOIN 
                                eb_users U
                            ON 
                                V.eb_files_ref_id = U.dprefid
                            WHERE 
                                U.id = @userid";
            }
        }
        public virtual string EB_GET_SELECT_FILE_UPLOADER_CXT
        {
            get
            {
                return @"SELECT 
	                            B.id, B.filename, B.tags, B.uploadts,B.filecategory
                            FROM
	                            eb_files_ref B
                            WHERE
	                            B.context = CONCAT(@context, '_@Name@') AND B.eb_del = 'F';";
            }
        }
        public virtual string EB_GET_SELECT_FILE_UPLOADER_CXT_SEC
        {
            get
            {
                return @"SELECT 
	                            B.id, B.filename, B.tags, B.uploadts,B.filecategory
                            FROM
	                            eb_files_ref B
                            WHERE
	                            (B.context = CONCAT(@context, '_@Name@') OR B.context_sec = @context_sec) AND B.eb_del = 'F';";
            }
        }
        public virtual string EB_GET_LOG_ENABLED
        {
            get
            {
                return @"SELECT is_logenabled FROM eb_objects WHERE id = (SELECT eb_objects_id FROM eb_objects_ver WHERE refid = @refid)";
            }
        }
        //....api query...
        public virtual string EB_API_SQL_FUNC_HEADER { get; }
        public virtual string EB_API_BY_NAME
        {
            get
            {
                return @"SELECT 
	                            EOV.obj_json,EOV.version_num,EOS.status,EO.obj_tags, EO.obj_type
                            FROM
	                            eb_objects_ver EOV
                            INNER JOIN
	                            eb_objects EO ON EOV.eb_objects_id = EO.id
                            INNER JOIN
	                            eb_objects_status EOS ON EOS.eb_obj_ver_id = EOV.id
                            WHERE
	                            EO.obj_type=20 
                            AND
	                            EO.obj_name = @objname
                            AND 
	                            EOV.version_num = @version
                            LIMIT 1;";
            }
        }

    }
}

