CREATE PROCEDURE eb_objects_update_Dashboard(in refid text,
out namev1 text,
out status1 integer,
out ver_num1 text,
out work_mode1 character,
out workingcopies1 text,
out major_ver1 integer,
out minor_ver1 integer,
out patch_ver1 integer,
out tags1 text, 
out app_id1 text,
out lastversionrefidval1 text,
out lastversionnumberval1 text,
out lastversioncommit_tsval1 text,
out lastversion_statusval1 integer,
out lastversioncommit_byname1 text,
out lastversioncommit_byid1 integer,
out liveversionrefidval1 text,
out liveversionnumberval1 text, 
out liveversioncommit_tsval1 text, 
out liveversion_statusval1 integer, 
out liveversioncommit_byname1 text, 
out liveversioncommit_byid1 integer, 
out owner_uidval1 integer, 
out owner_tsval1 text, 
out owner_nameval1 text)
BEGIN
  
DECLARE workingcopies text;
DECLARE _id integer;
DECLARE namev text;
DECLARE status integer;
DECLARE	description text;
DECLARE changelog text;
DECLARE ver_num text;
DECLARE work_mode char;
DECLARE	major_ver integer;
DECLARE minor_ver integer;
DECLARE patch_ver integer;
DECLARE tags text;
DECLARE app_id text;
DECLARE	lastversionrefidval text;
DECLARE lastversionnumberval text;
DECLARE lastversioncommit_tsval text;
DECLARE	lastversion_statusval integer;
DECLARE lastversioncommit_byname text;
DECLARE lastversioncommit_byid integer;
DECLARE liveversionrefidval text;
DECLARE	liveversionnumberval text;
DECLARE liveversioncommit_tsval text;
DECLARE liveversion_statusval integer;
DECLARE liveversioncommit_byname text;
DECLARE	liveversioncommit_byid integer;
DECLARE owner_uidVal integer;
DECLARE owner_tsVal text;
DECLARE owner_nameVal text;

set workingcopies = NULL;

SELECT EO.eb_objects_id  FROM eb_objects_ver EO WHERE EO.refid = refid INTO _id;

select group_concat(EA.applicationname,',')  from eb_objects2application E2O ,eb_applications EA where 
 obj_id = _id and E2O.eb_del = 'F' and EA.id = E2O.app_id INTO app_id;
 
 SELECT 
	group_concat((json_object( version_num, refid)),',') INTO workingcopies
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
	liveversionnumberval, liveversionrefidval, liveversioncommit_tsval, liveversion_statusval,liveversioncommit_byid,liveversioncommit_byname;

-- Latest commited vaersion details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid
    
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = _id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    ORDER BY EOV.commit_ts DESC LIMIT 1 
    INTO lastversionnumberval, lastversionrefidval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname, lastversioncommit_byid;

-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname

FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = _id AND EU.id = EO.owner_uid INTO 
	owner_uidVal, owner_tsVal, owner_nameVal;
	

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
INTO	namev, status, ver_num, work_mode,
			 major_ver, minor_ver, patch_ver, tags;
            
SELECT namev, status, ver_num,
	COALESCE(work_mode,'F'), workingcopies, major_ver, minor_ver, patch_ver, tags, app_id,
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, lastversioncommit_byname,lastversioncommit_byid,
	liveversionrefidval, liveversionnumberval, liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname,liveversioncommit_byid,
	owner_uidVal, owner_tsVal, owner_nameVal 
    into namev1, status1, ver_num1,
	work_mode1, workingcopies1, major_ver1, minor_ver1, patch_ver1, tags1, app_id1,
	lastversionrefidval1, lastversionnumberval1, lastversioncommit_tsval1, lastversion_statusval1, 
    lastversioncommit_byname1,lastversioncommit_byid1,liveversionrefidval1, liveversionnumberval1, 
    liveversioncommit_tsval1, liveversion_statusval1, liveversioncommit_byname1,liveversioncommit_byid1,
	owner_uidVal1, owner_tsVal1, owner_nameVal1;
    
END