-- FUNCTION: public.eb_objects_exploreobject(integer)

-- DROP FUNCTION public.eb_objects_exploreobject(integer);

CREATE OR REPLACE FUNCTION public.eb_objects_exploreobject(
	_id integer)
    RETURNS TABLE(idval integer, nameval text, typeval integer, statusval integer, descriptionval text, changelogval text, commitatval text, commitbyval text, refidval text, ver_numval text, work_modeval character, workingcopiesval text, json_wcval json, json_lcval json, major_verval integer, minor_verval integer, patch_verval integer, tagsval text, app_idval text, lastversionrefidval text, lastversionnumberval text, lastversioncommit_tsval text, lastversion_statusvalv integer, lastversioncommit_byname text, lastversioncommit_byid integer, liveversionrefidval text, liveversionnumberval text, liveversioncommit_tsval text, liveversion_statusval integer, liveversioncommit_byname text, liveversioncommit_byid integer, owner_uidval integer, owner_tsval text, owner_nameval text, dispnameval text, is_logv text, is_publicv text) 
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE
	workingcopiesval text;
	json_wcval json; json_lcval json;
	idval integer; nameval text; typeval integer; statusval integer;
	descriptionval text; changelogval text; commitatval text; commitbyval text; refidval text; ver_numval text; work_modeval char;
	major_verval integer; minor_verval integer; patch_verval integer; tagsval text; app_idval text;
	lastversionrefidval text; lastversionnumberval text; lastversioncommit_tsval text; lastversion_statusval integer; lastversioncommit_byname text;lastversioncommit_byid integer;
	liveversionrefidval text; liveversionnumberval text; liveversioncommit_tsval text; liveversion_statusval integer; liveversioncommit_byname text;liveversioncommit_byid integer;
	owner_uidVal integer; owner_tsVal text; owner_nameVal text;dispnameval text; is_logv text; is_publicv text;
 
BEGIN

--Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname INTO
	liveversionnumberval, liveversionrefidval, liveversioncommit_tsval, liveversion_statusval,liveversioncommit_byid,liveversioncommit_byname
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = _id AND EOV.eb_objects_id = _id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;
	
--Latest commited vaersion details
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
		json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id, dispnamev, is_log, is_public
    FROM 
		eb_objects_getversiontoopen(_id) 
	INTO
		idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval,
		ver_numval, work_modeval, workingcopiesval,
		json_wcval, json_lcval, major_verval, minor_verval, patch_verval, tagsval, app_idval, dispnameval, is_logv, is_publicv ;
	
RETURN QUERY
	SELECT idval, nameval, typeval, statusval, descriptionval, changelogval, commitatval, commitbyval, refidval, 
	ver_numval, work_modeval, workingcopiesval, json_wcval, json_lcval, major_verval, minor_verval, patch_verval,
	tagsval, app_idval,
    lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal, dispnameval, is_logv, is_publicv;
END

$BODY$;

