DROP PROCEDURE IF EXISTS eb_objects_update_dashboard;


CREATE PROCEDURE eb_objects_update_dashboard(IN refid TEXT,
OUT namev TEXT,
OUT status INTEGER,
OUT ver_num TEXT,
OUT work_mode CHARACTER,
OUT workingcopies TEXT,
OUT major_ver INTEGER,
OUT minor_ver INTEGER,
OUT patch_ver INTEGER,
OUT tags TEXT, 
OUT app_id TEXT,
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
OUT owner_uidval INTEGER, 
OUT owner_tsval TEXT, 
OUT owner_nameval TEXT,
OUT is_public CHARACTER)
BEGIN
  
DECLARE temp_workingcopies TEXT;
DECLARE _id INTEGER;
DECLARE temp_namev TEXT;
DECLARE temp_status INTEGER;
DECLARE temp_ver_num TEXT;
DECLARE temp_work_mode CHAR;
DECLARE	temp_major_ver INTEGER;
DECLARE temp_minor_ver INTEGER;
DECLARE temp_patch_ver INTEGER;
DECLARE temp_tags TEXT;
DECLARE temp_app_id TEXT;
DECLARE	temp_lastversionrefidval TEXT;
DECLARE temp_lastversionnumberval TEXT;
DECLARE temp_lastversioncommit_tsval TEXT;
DECLARE	temp_lastversion_statusval INTEGER;
DECLARE temp_lastversioncommit_byname TEXT;
DECLARE temp_lastversioncommit_byid INTEGER;
DECLARE temp_liveversionrefidval TEXT;
DECLARE	temp_liveversionnumberval TEXT;
DECLARE temp_liveversioncommit_tsval TEXT;
DECLARE temp_liveversion_statusval INTEGER;
DECLARE temp_liveversioncommit_byname TEXT;
DECLARE	temp_liveversioncommit_byid INTEGER;
DECLARE temp_owner_uidVal INTEGER;
DECLARE temp_owner_tsVal TEXT;
DECLARE temp_owner_nameVal TEXT;
DECLARE temp_is_public CHARACTER;

SET temp_workingcopies = NULL;

SELECT EO.eb_objects_id  FROM eb_objects_ver EO WHERE EO.refid = refid INTO _id;

SELECT GROUP_CONCAT(EA.applicationname,',')  FROM eb_objects2application E2O ,eb_applications EA WHERE 
 obj_id = _id AND E2O.eb_del = 'F' AND EA.id = E2O.app_id INTO temp_app_id;
 
 SELECT 
	GROUP_CONCAT((json_object( version_num, refid)),',') INTO temp_workingcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id=_id AND working_mode = 'T';
    
-- Live version details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EOV.commit_uid, EU.firstname 
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
WHERE
    EO.id = _id AND EOV.eb_objects_id = _id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id
ORDER BY EOS.ts desc limit 1    
INTO
	temp_liveversionnumberval, temp_liveversionrefidval, temp_liveversioncommit_tsval, temp_liveversion_statusval,temp_liveversioncommit_byid,temp_liveversioncommit_byname;

-- Latest commited vaersion details
SELECT
    EOV.version_num, EOV.refid, EOV.commit_ts, EOS.status, EU.firstname,  EOV.commit_uid    
FROM
    eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
WHERE
    EOV.eb_objects_id = _id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
ORDER BY 
	EOV.commit_ts DESC LIMIT 1 
INTO 
	temp_lastversionnumberval, temp_lastversionrefidval, temp_lastversioncommit_tsval, temp_lastversion_statusval, temp_lastversioncommit_byname, temp_lastversioncommit_byid;

-- Owner details
SELECT  
	EO.owner_uid, EO.owner_ts, EU.firstname
FROM 
	eb_objects EO, eb_users EU
WHERE 
	EO.id = _id AND EU.id = EO.owner_uid 
INTO 
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal;	

SELECT 
		EO.obj_name, EOS.status,EOV.version_num, EOV.working_mode,
		EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags, EO.is_public	
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
	INTO	
		temp_namev, temp_status, temp_ver_num, temp_work_mode,
		temp_major_ver, temp_minor_ver, temp_patch_ver, temp_tags, temp_is_public;
            
SELECT temp_namev, temp_status, temp_ver_num,
	COALESCE(temp_work_mode,'F'), temp_workingcopies, temp_major_ver, temp_minor_ver, temp_patch_ver, temp_tags, temp_app_id,
	temp_lastversionrefidval, temp_lastversionnumberval, temp_lastversioncommit_tsval, temp_lastversion_statusval, temp_lastversioncommit_byname,temp_lastversioncommit_byid,
	temp_liveversionrefidval, temp_liveversionnumberval, temp_liveversioncommit_tsval, temp_liveversion_statusval, temp_liveversioncommit_byname,temp_liveversioncommit_byid,
	temp_owner_uidVal, temp_owner_tsVal, temp_owner_nameVal, temp_is_public
INTO 
    namev, status, ver_num,
	work_mode, workingcopies, major_ver, minor_ver, patch_ver, tags, app_id,
	lastversionrefidval, lastversionnumberval, lastversioncommit_tsval, lastversion_statusval, 
    lastversioncommit_byname, lastversioncommit_byid, liveversionrefidval, liveversionnumberval, 
    liveversioncommit_tsval, liveversion_statusval, liveversioncommit_byname ,liveversioncommit_byid ,
	owner_uidVal, owner_tsVal, owner_nameVal, is_public;
    
END