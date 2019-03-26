CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_objects_exploreobject`(_id integer)
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
 call eb_objects_getversiontoopen(_id);
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

SELECT idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,'F'), workingcopies,
		json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id, dispnamev, is_log
    FROM 
		eb_objects_getversiontoopen_tmp
	INTO
		idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval,
		ver_numval, work_modeval, workingcopiesval,
		json_wcval, json_lcval, major_verval, minor_verval, patch_verval, tagsval, app_idval, dispnameval, is_logv;

SELECT idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval, 
	ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, minor_verval, patch_verval,
	tagsval, app_idval,
    lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal, dispnameval, is_logv;
END