CREATE PROCEDURE eb_objects_exploreobject(in _id integer,
out idval1 integer,
out nameval1 text,
out typeval1 integer,
out statusval1 integer,
out descriptionval1 text,
out changelogval1 text,
out commitatval1 text, 
out commitbyval1 text,
out refidval1 text, 
out	ver_numval1 text,
out work_modeval1 char,
out workingcopiesval1 text,
out json_wcval1 json,
out json_lcval1 json,
out major_verval1 integer,
out minor_verval1 integer,
out patch_verval1 integer,
out	tagsval1 text,
out app_idval1 text,
out lastversionrefidval1 text,
out lastversionnumberval1 text,
out lastversioncommit_tsval1 text,
out lastversion_statusval1 integer,
out lastversioncommit_byname1 text,
out lastversioncommit_byid1 integer,
out	liveversionrefidval1 text,
out liveversionnumberval1 text,
out liveversioncommit_tsval1 text,
out liveversion_statusval1 integer,
out liveversioncommit_byname1 text,
out liveversioncommit_byid1 integer,
out	owner_uidVal1 integer,
out owner_tsVal1 text,
out owner_nameVal1 text,
out dispnameval1 text,
out is_logv1 text)
BEGIN
DECLARE workingcopiesval text;
DECLARE	json_wcval json;
DECLARE json_lcval json;
DECLARE	idval integer;
DECLARE nameval text;
DECLARE typeval integer;
DECLARE statusval integer;
DECLARE	descriptionval text;
DECLARE changelogval text;
DECLARE commitatval text;
DECLARE commitbyval text;
DECLARE refidval text;
DECLARE ver_numval text;
DECLARE work_modeval char;
DECLARE major_verval integer;
DECLARE minor_verval integer;
DECLARE patch_verval integer;
DECLARE tagsval text;
DECLARE app_idval text;
DECLARE	lastversionrefidval text;
DECLARE lastversionnumberval text;
DECLARE lastversioncommit_tsval text;
DECLARE lastversion_statusval integer;
DECLARE lastversioncommit_byname text;
DECLARE lastversioncommit_byid integer;
DECLARE	liveversionrefidval text;
DECLARE liveversionnumberval text;
DECLARE liveversioncommit_tsval text;
DECLARE liveversion_statusval integer;
DECLARE liveversioncommit_byname text;
DECLARE liveversioncommit_byid integer;
DECLARE	owner_uidVal integer;
DECLARE owner_tsVal text;
DECLARE owner_nameVal text;
DECLARE dispnameval text;
DECLARE is_logv text;

-- drop temporary table if exists eb_objects_getversiontoopen_tmp;
 call eb_objects_getversiontoopen(_id,@out_idv , @out_namev , @out_typev , @out_status , @out_description , @out_changelog , @out_commitat , @out_commitby , @out_refidv , 
    @out_ver_num , @out_work_mode , @out_workingcopies , @out_json_wc , @out_json_lc , @out_major_ver , @out_minor_ver , @out_patch_ver , 
    @out_tags ,@out_app_id , @out_dispnamev , @out_is_log);
-- Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
	liveversionnumberval, liveversionrefidval, liveversioncommit_tsval, liveversion_statusval,liveversioncommit_byid,liveversioncommit_byname
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = _id AND EOV.eb_objects_id = _id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
    
 -- Latest commited vaersion details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    INTO lastversionnumberval, lastversionrefidval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname, lastversioncommit_byid
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = _id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    ORDER BY commit_ts DESC LIMIT 1;   
-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
INTO 
	owner_uidVal, owner_tsVal, owner_nameVal
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = _id AND EU.id = EO.owner_uid;

SELECT @out_idv , @out_namev , @out_typev , @out_status , @out_description , @out_changelog , @out_commitat , @out_commitby , @out_refidv , 
    @out_ver_num , @out_work_mode , @out_workingcopies , @out_json_wc , @out_json_lc , @out_major_ver , @out_minor_ver , @out_patch_ver , 
    @out_tags ,@out_app_id , @out_dispnamev , @out_is_log
	INTO
		idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval,
		ver_numval, work_modeval, workingcopiesval,
		json_wcval, json_lcval, major_verval, minor_verval, patch_verval, tagsval, app_idval, dispnameval, is_logv;

SELECT idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval, 
	ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, minor_verval, patch_verval,
	tagsval, app_idval,
    lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal, dispnameval, is_logv into idval1, nameval1, typeval1, statusval1, descriptionval1, changelogval1, commitatval1, commitbyval1, refidval1, 
	ver_numval1, work_modeval1, workingcopiesval1, json_wcval1, json_lcval1, major_verval1, minor_verval1, patch_verval1,
	tagsval1, app_idval1,
    lastversionrefidval1, lastversionnumberval1, lastversioncommit_tsval1, lastversion_statusval1, lastversioncommit_byname1,lastversioncommit_byid1,
	liveversionrefidval1, liveversionnumberval1, liveversioncommit_tsval1, liveversion_statusval1, liveversioncommit_byname1,liveversioncommit_byid1,
	owner_uidVal1, owner_tsVal1, owner_nameVal1, dispnameval1, is_logv1;
END