DROP PROCEDURE IF EXISTS eb_objects_exploreobject;

CREATE PROCEDURE eb_objects_exploreobject(IN id INTEGER,
OUT idval INTEGER,
OUT nameval TEXT,
OUT typeval INTEGER,
OUT statusval INTEGER,
OUT descriptionval TEXT,
OUT changelogval TEXT,
OUT commitatval TEXT, 
OUT commitbyval TEXT,
OUT refidval TEXT, 
OUT ver_numval TEXT,
OUT work_modeval char,
OUT workingcopiesval TEXT,
OUT json_wcval JSON,
OUT json_lcval JSON,
OUT major_verval INTEGER,
OUT minor_verval INTEGER,
OUT patch_verval INTEGER,
OUT tagsval TEXT,
OUT app_idval TEXT,
OUT lastversionrefidval TEXT,
OUT lastversionnumberval TEXT,
OUT lastversioncommit_tsval TEXT,
OUT lastversion_statusval INTEGER,
OUT lastversioncommit_byname TEXT,
OUT lastversioncommit_byid INTEGER,
OUT liveversionrefidval TEXT,
OUT liveversionnumberval TEXT,
OUT liveversioncommit_tsval TEXT,
OUT liveversion_statusval INTEGER,
OUT liveversioncommit_byname TEXT,
OUT liveversioncommit_byid INTEGER,
OUT owner_uidVal INTEGER,
OUT owner_tsVal TEXT,
OUT owner_nameVal TEXT,
OUT dispnameval TEXT,
OUT is_logv TEXT)
BEGIN
DECLARE	temp_lastversionrefidval TEXT;
DECLARE temp_lastversionnumberval TEXT;
DECLARE temp_lastversioncommit_tsval TEXT;
DECLARE temp_lastversion_statusval INTEGER;
DECLARE temp_lastversioncommit_byname TEXT;
DECLARE temp_lastversioncommit_byid INTEGER;
DECLARE	temp_liveversionrefidval TEXT;
DECLARE temp_liveversionnumberval TEXT;
DECLARE temp_liveversioncommit_tsval TEXT;
DECLARE temp_liveversion_statusval INTEGER;
DECLARE temp_liveversioncommit_byname TEXT;
DECLARE temp_liveversioncommit_byid INTEGER;
DECLARE	temp_owner_uidVal INTEGER;
DECLARE temp_owner_tsVal TEXT;
DECLARE temp_owner_nameVal TEXT;

 CALL eb_objects_getversiontoopen(id,@out_idv , @out_namev , @out_typev , @out_status , @out_description , @out_changelog , @out_commitat , @out_commitby , @out_refidv , 
    @out_ver_num , @out_work_mode , @out_workingcopies , @out_json_wc , @out_json_lc , @out_major_ver , @out_minor_ver , @out_patch_ver , 
    @out_tags ,@out_app_id , @out_dispnamev , @out_is_log);

-- Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
	temp_liveversionnumberval, temp_liveversionrefidval, temp_liveversioncommit_tsval, temp_liveversion_statusval,temp_liveversioncommit_byid,temp_liveversioncommit_byname
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = id AND EOV.eb_objects_id = id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id
ORDER BY EOS.ts DESC LIMIT 1;
    
 -- Latest commited version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    INTO temp_lastversionnumberval, temp_lastversionrefidval, temp_lastversioncommit_tsval, temp_lastversion_statusval, temp_lastversioncommit_byname, temp_lastversioncommit_byid
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    ORDER BY commit_ts DESC LIMIT 1;  
	
-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
INTO 
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = id AND EU.id = EO.owner_uid;

SELECT @out_idv , @out_namev , @out_typev , @out_status , @out_description , @out_changelog , @out_commitat , @out_commitby , @out_refidv , 
    @out_ver_num , @out_work_mode , @out_workingcopies , @out_json_wc , @out_json_lc , @out_major_ver , @out_minor_ver , @out_patch_ver , 
    @out_tags ,@out_app_id , @out_dispnamev , @out_is_log
	INTO
		idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval,
		ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, 
        minor_verval, patch_verval, tagsval, app_idval, dispnameval, is_logv;
SELECT 
	temp_lastversionrefidval, temp_lastversionnumberval, temp_lastversioncommit_tsval, temp_lastversion_statusval, 
    temp_lastversioncommit_byname,temp_lastversioncommit_byid, temp_liveversionrefidval, temp_liveversionnumberval, 
    temp_liveversioncommit_tsval, temp_liveversion_statusval, temp_liveversioncommit_byname,temp_liveversioncommit_byid,
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal 
   INTO 
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal;

END