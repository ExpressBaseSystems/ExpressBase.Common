-- FUNCTION: public.eb_objects_update_dashboard(text)

-- DROP FUNCTION public.eb_objects_update_dashboard(text);

CREATE OR REPLACE FUNCTION public.eb_objects_update_dashboard(
	_refid text)
    RETURNS TABLE(namev text, status integer, ver_num text, work_mode character, workingcopies text, major_ver integer, minor_ver integer, patch_ver integer, tags text, app_id text, lastversionrefidval text, lastversionnumberval text, lastversioncommit_tsval text, lastversion_statusval integer, lastversioncommit_byname text, lastversioncommit_byid integer, liveversionrefidval text, liveversionnumberval text, liveversioncommit_tsval text, liveversion_statusval integer, liveversioncommit_byname text, liveversioncommit_byid integer, owner_uidval integer, owner_tsval text, owner_nameval text, is_public character) 
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE
	workingcopies text; _id integer;
    namev text; status integer;
	description text; changelog text; ver_num text; work_mode char;
	major_ver integer; minor_ver integer; patch_ver integer; tags text; app_id text;
	lastversionrefidval text; lastversionnumberval text; lastversioncommit_tsval text;
	lastversion_statusval integer; lastversioncommit_byname text; lastversioncommit_byid integer; liveversionrefidval text;
	liveversionnumberval text; liveversioncommit_tsval text; liveversion_statusval integer; liveversioncommit_byname text;
	liveversioncommit_byid integer; owner_uidVal integer; owner_tsVal text; owner_nameVal text; is_public character;
 
BEGIN

	workingcopies := NULL;

SELECT eb_objects_id INTO _id FROM eb_objects_ver WHERE refid = _refid;

select string_agg(EA.applicationname,',') INTO app_id from eb_objects2application E2O ,eb_applications EA where 
 obj_id = _id and E2O.eb_del = 'F' and EA.id = E2O.app_id ;
 
SELECT 
	string_agg((json_build_object( version_num, refid)::text),',') INTO workingcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id=_id AND working_mode='T';

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
	

	SELECT 
			EO.obj_name, EOS.status,EOV.version_num, EOV.working_mode,
		    EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags ,EO.is_public
	INTO	namev, status, ver_num, work_mode,
			 major_ver, minor_ver, patch_ver, tags, is_public
	FROM 
			 eb_objects EO, eb_objects_ver EOV
	LEFT JOIN
		eb_users EU
	ON 
		EOV.commit_uid=EU.id
	LEFT JOIN
		eb_objects_status EOS
	ON 
		EOS.eb_obj_ver_id = EOV.id										 
	WHERE 
			EOV.refid = _refid AND EOV.eb_objects_id = EO.id
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
			
RETURN QUERY
	SELECT namev, status, ver_num,
	COALESCE(work_mode,'F'), workingcopies, major_ver, minor_ver, patch_ver, tags, app_id,
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal, is_public;
END

$BODY$;
