CREATE PROCEDURE eb_objects_update_Dashboard(in refid text,
out namev text,
out status integer,
out ver_num text,
out work_mode character,
out workingcopies text,
out major_ver integer,
out minor_ver integer,
out patch_ver integer,
out tags text, 
out app_id text,
out lastversionrefidval text,
out lastversionnumberval text,
out lastversioncommit_tsval text,
out lastversion_statusval integer,
out lastversioncommit_byname text,
out lastversioncommit_byid integer,
out liveversionrefidval text,
out liveversionnumberval text, 
out liveversioncommit_tsval text, 
out liveversion_statusval integer, 
out liveversioncommit_byname text, 
out liveversioncommit_byid integer, 
out owner_uidval integer, 
out owner_tsval text, 
out owner_nameval text)
BEGIN
  
DECLARE temp_workingcopies text;
DECLARE _id integer;
DECLARE temp_namev text;
DECLARE temp_status integer;
DECLARE temp_ver_num text;
DECLARE temp_work_mode char;
DECLARE	temp_major_ver integer;
DECLARE temp_minor_ver integer;
DECLARE temp_patch_ver integer;
DECLARE temp_tags text;
DECLARE temp_app_id text;
DECLARE	temp_lastversionrefidval text;
DECLARE temp_lastversionnumberval text;
DECLARE temp_lastversioncommit_tsval text;
DECLARE	temp_lastversion_statusval integer;
DECLARE temp_lastversioncommit_byname text;
DECLARE temp_lastversioncommit_byid integer;
DECLARE temp_liveversionrefidval text;
DECLARE	temp_liveversionnumberval text;
DECLARE temp_liveversioncommit_tsval text;
DECLARE temp_liveversion_statusval integer;
DECLARE temp_liveversioncommit_byname text;
DECLARE	temp_liveversioncommit_byid integer;
DECLARE temp_owner_uidVal integer;
DECLARE temp_owner_tsVal text;
DECLARE temp_owner_nameVal text;

SET temp_workingcopies = NULL;

SELECT EO.eb_objects_id  FROM eb_objects_ver EO WHERE EO.refid = refid INTO _id;

SELECT GROUP_CONCAT(EA.applicationname,',')  FROM eb_objects2application E2O ,eb_applications EA WHERE 
 obj_id = _id AND E2O.eb_del = 'F' AND EA.id = E2O.app_id INTO temp_app_id;
 
 SELECT 
	GROUP_CONCAT((json_object( version_num, refid)),',') INTO temp_workingcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id=_id AND working_mode='T';
    
-- Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname 
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = _id AND EOV.eb_objects_id = _id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id
    INTO
	temp_liveversionnumberval, temp_liveversionrefidval, temp_liveversioncommit_tsval, temp_liveversion_statusval,temp_liveversioncommit_byid,temp_liveversioncommit_byname;

-- Latest commited vaersion details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid    
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = _id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    ORDER BY EOV.commit_ts DESC LIMIT 1 
    INTO temp_lastversionnumberval, temp_lastversionrefidval, temp_lastversioncommit_tsval, temp_lastversion_statusval, temp_lastversioncommit_byname, temp_lastversioncommit_byid;

-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = _id AND EU.id = EO.owner_uid INTO 
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal;	

SELECT 
	EO.obj_name, EOS.status,EOV.version_num, EOV.working_mode,
		    EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags	
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
			EOV.refid = refid AND EOV.eb_objects_id = EO.id
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id) 
INTO	temp_namev, temp_status, temp_ver_num, temp_work_mode,
			 temp_major_ver, temp_minor_ver, temp_patch_ver, temp_tags;
            
SELECT temp_namev, temp_status, temp_ver_num,
	COALESCE(temp_work_mode,'F'), temp_workingcopies, temp_major_ver, temp_minor_ver, temp_patch_ver, temp_tags, temp_app_id,
	temp_lastversionrefidval, temp_lastversionnumberval, temp_lastversioncommit_tsval, temp_lastversion_statusval, temp_lastversioncommit_byname,temp_lastversioncommit_byid,
	temp_liveversionrefidval, temp_liveversionnumberval, temp_liveversioncommit_tsval, temp_liveversion_statusval, temp_liveversioncommit_byname,temp_liveversioncommit_byid,
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal 
	INTO 
    namev, status, ver_num,
	work_mode, workingcopies, major_ver, minor_ver, patch_ver, tags, app_id,
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, 
    lastversioncommit_byname, lastversioncommit_byid, liveversionrefidval, liveversionnumberval, 
    liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname ,liveversioncommit_byid ,
	owner_uidVal, owner_tsVal, owner_nameVal;
    
END