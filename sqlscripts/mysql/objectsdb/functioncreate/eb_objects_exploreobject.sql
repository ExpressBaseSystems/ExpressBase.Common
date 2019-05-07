CREATE PROCEDURE eb_objects_exploreobject(in id integer,
out idval integer,
out nameval text,
out typeval integer,
out statusval integer,
out descriptionval text,
out changelogval text,
out commitatval text, 
out commitbyval text,
out refidval text, 
out	ver_numval text,
out work_modeval char,
out workingcopiesval text,
out json_wcval json,
out json_lcval json,
out major_verval integer,
out minor_verval integer,
out patch_verval integer,
out	tagsval text,
out app_idval text,
out lastversionrefidval text,
out lastversionnumberval text,
out lastversioncommit_tsval text,
out lastversion_statusval integer,
out lastversioncommit_byname text,
out lastversioncommit_byid integer,
out	liveversionrefidval text,
out liveversionnumberval text,
out liveversioncommit_tsval text,
out liveversion_statusval integer,
out liveversioncommit_byname text,
out liveversioncommit_byid integer,
out	owner_uidVal integer,
out owner_tsVal text,
out owner_nameVal text,
out dispnameval text,
out is_logv text)
BEGIN
DECLARE temp_workingcopiesval text;
DECLARE	temp_json_wcval json;
DECLARE temp_json_lcval json;
DECLARE	temp_idval integer;
DECLARE temp_nameval text;
DECLARE temp_typeval integer;
DECLARE temp_statusval integer;
DECLARE	temp_descriptionval text;
DECLARE temp_changelogval text;
DECLARE temp_commitatval text;
DECLARE temp_commitbyval text;
DECLARE temp_refidval text;
DECLARE temp_ver_numval text;
DECLARE temp_work_modeval char;
DECLARE temp_major_verval integer;
DECLARE temp_minor_verval integer;
DECLARE temp_patch_verval integer;
DECLARE temp_tagsval text;
DECLARE temp_app_idval text;
DECLARE	temp_lastversionrefidval text;
DECLARE temp_lastversionnumberval text;
DECLARE temp_lastversioncommit_tsval text;
DECLARE temp_lastversion_statusval integer;
DECLARE temp_lastversioncommit_byname text;
DECLARE temp_lastversioncommit_byid integer;
DECLARE	temp_liveversionrefidval text;
DECLARE temp_liveversionnumberval text;
DECLARE temp_liveversioncommit_tsval text;
DECLARE temp_liveversion_statusval integer;
DECLARE temp_liveversioncommit_byname text;
DECLARE temp_liveversioncommit_byid integer;
DECLARE	temp_owner_uidVal integer;
DECLARE temp_owner_tsVal text;
DECLARE temp_owner_nameVal text;
DECLARE temp_dispnameval text;
DECLARE temp_is_logv text;

 call eb_objects_getversiontoopen(id,@out_idv , @out_namev , @out_typev , @out_status , @out_description , @out_changelog , @out_commitat , @out_commitby , @out_refidv , 
    @out_ver_num , @out_work_mode , @out_workingcopies , @out_json_wc , @out_json_lc , @out_major_ver , @out_minor_ver , @out_patch_ver , 
    @out_tags ,@out_app_id , @out_dispnamev , @out_is_log);
-- Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
	temp_liveversionnumberval, temp_liveversionrefidval, temp_liveversioncommit_tsval, temp_liveversion_statusval,temp_liveversioncommit_byid,temp_liveversioncommit_byname
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = id AND EOV.eb_objects_id = id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
    
 -- Latest commited vaersion details
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
		temp_idval, temp_nameval, temp_typeval, temp_statusval, temp_descriptionval, temp_changelogval, temp_commitatval, temp_commitbyval, temp_refidval,
		temp_ver_numval, temp_work_modeval, temp_workingcopiesval,
		temp_json_wcval, temp_json_lcval, temp_major_verval, temp_minor_verval, temp_patch_verval, temp_tagsval, temp_app_idval, temp_dispnameval, temp_is_logv;

SELECT temp_idval, temp_nameval, temp_typeval, temp_statusval, temp_descriptionval, temp_changelogval, temp_commitatval, temp_commitbyval, temp_refidval, 
	temp_ver_numval, temp_work_modeval, temp_workingcopiesval, temp_json_wcval, temp_json_lcval, temp_major_verval, temp_minor_verval, temp_patch_verval,
	temp_tagsval, temp_app_idval,temp_lastversionrefidval, temp_lastversionnumberval, temp_lastversioncommit_tsval, temp_lastversion_statusval, 
    temp_lastversioncommit_byname,temp_lastversioncommit_byid, temp_liveversionrefidval, temp_liveversionnumberval, 
    temp_liveversioncommit_tsval, temp_liveversion_statusval, temp_liveversioncommit_byname,temp_liveversioncommit_byid,
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal, temp_dispnameval, temp_is_logv 
    INTO idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval, 
	ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, minor_verval, patch_verval,
	tagsval, app_idval,
    lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal, dispnameval, is_logv;
END