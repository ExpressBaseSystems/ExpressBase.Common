DROP PROCEDURE IF EXISTS eb_objects_getversiontoopen;

CREATE PROCEDURE eb_objects_getversiontoopen(IN _id INTEGER,
 OUT out_idv INTEGER, 
 OUT out_namev TEXT, 
 OUT out_typev INTEGER, 
 OUT out_status INTEGER, 
 OUT out_description TEXT, 
 OUT out_changelog TEXT, 
 OUT out_commitat TEXT, 
 OUT out_commitby TEXT, 
 OUT out_refidv TEXT, 
 OUT out_ver_num TEXT, 
 OUT out_work_mode CHARACTER, 
 OUT out_workingcopies TEXT, 
 OUT out_json_wc JSON, 
 OUT out_json_lc JSON, 
 OUT out_major_ver INTEGER, 
 OUT out_minor_ver INTEGER, 
 OUT out_patch_ver INTEGER, 
 OUT out_tags TEXT, 
 OUT out_app_id TEXT, 
 OUT out_dispnamev TEXT, 
 OUT out_is_log CHARACTER
)
BEGIN
DECLARE workingcopies TEXT;
DECLARE	json_wc JSON;
DECLARE json_lc JSON;
DECLARE no_of_workcopies INTEGER;
DECLARE	idv INTEGER;
DECLARE namev TEXT;
DECLARE typev INTEGER;
DECLARE status INTEGER;
DECLARE	description TEXT;
DECLARE changelog TEXT;
DECLARE commitat TEXT;
DECLARE commitby TEXT;
DECLARE refidv TEXT;
DECLARE ver_num TEXT;
DECLARE work_mode CHAR;
DECLARE	major_ver INTEGER;
DECLARE minor_ver INTEGER;
DECLARE patch_ver INTEGER;
DECLARE tags TEXT;
DECLARE app_id TEXT;
DECLARE	lastversionnumber TEXT;
DECLARE lastversionrefid TEXT;
DECLARE liveversionnumber TEXT;
DECLARE liveversionrefid TEXT;
DECLARE dispnamev TEXT;
DECLARE is_log CHAR;

SET workingcopies = NULL;
SET	json_wc = NULL;
SET	json_lc = NULL;

-- Fetching all working copies
SELECT 
	GROUP_CONCAT((json_object( version_num, refid)),','),COUNT(*) INTO workingcopies, no_of_workcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id = _id AND working_mode='T';

 SELECT GROUP_CONCAT(EA.applicationname,',') INTO app_id FROM eb_objects2application E2O ,eb_applications EA WHERE 
 obj_id = _id AND E2O.eb_del = 'F' AND EA.id = E2O.app_id ;
 
  -- one working copy	
IF no_of_workcopies = 1 THEN
	SELECT 
			EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc,
			EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
			EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags,EO.display_name, EO.is_logenabled
	INTO	idv, namev, typev, status, description, json_wc, changelog, commitat, refidv, ver_num, work_mode, commitby,
			major_ver, minor_ver, patch_ver, tags, dispnamev , is_log
	FROM 
			 eb_objects EO, eb_objects_ver EOV
	LEFT JOIN
		eb_users EU
	ON 
		EOV.commit_uid = EU.id
	LEFT JOIN
		eb_objects_status EOS
	ON 
		EOS.eb_obj_ver_id = EOV.id										 
	WHERE 
			EO.id = _id AND EOV.eb_objects_id = EO.id AND working_mode='T'
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
-- No working copy			
ELSEIF no_of_workcopies = 0 THEN
        SELECT 
                EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc, 
                EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
				EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags, EO.display_name, EO.is_logenabled
        INTO	idv, namev, typev, status, description, json_lc, changelog, commitat, refidv, ver_num, work_mode,
				commitby, major_ver, minor_ver, patch_ver, tags, dispnamev, is_log
        FROM  
                eb_objects EO, eb_objects_ver EOV
        LEFT JOIN
                eb_users EU
        ON 
                EOV.commit_uid = EU.id	
		LEFT JOIN
			eb_objects_status EOS
		ON 
			EOS.eb_obj_ver_id = EOV.id									 
        WHERE 
                EO.id = _id AND EOV.eb_objects_id = EO.id  AND
                major_ver_num = (SELECT MAX(major_ver_num) FROM eb_objects_ver WHERE eb_objects_id = _id) AND 
                minor_ver_num = (SELECT MAX(minor_ver_num) FROM eb_objects_ver WHERE eb_objects_id = _id AND  
				major_ver_num = (SELECT MAX(major_ver_num) FROM eb_objects_ver WHERE eb_objects_id = _id)) AND
                COALESCE(working_mode, 'F') <> 'T'
				AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);  
 
 -- multiple workingcopies
ELSE

	SELECT 
			EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc,
			EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
			EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags, EO.display_name, COALESCE(EO.is_logenabled,'F')
	 INTO	idv, namev, typev, status, description, json_lc, changelog, commitat, refidv, ver_num, work_mode,
			commitby, major_ver, minor_ver, patch_ver, tags, dispnamev, is_log
	FROM 
			eb_objects EO, eb_objects_ver EOV
	LEFT JOIN
		eb_users EU
	ON 
		EOV.commit_uid = EU.id
	LEFT JOIN
		eb_objects_status EOS
	ON 
		EOS.eb_obj_ver_id = EOV.id		
	WHERE 
		EO.id = _id AND EOV.eb_objects_id = EO.id AND working_mode='T'
		AND EOV.id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = _id AND working_mode='T')
		AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS, eb_objects_ver EOV 
						WHERE EOS.eb_obj_ver_id = (
								SELECT MAX(EOV.id) FROM eb_objects_ver EOV 
									WHERE EOV.eb_objects_id = _id AND working_mode='T') 
							AND EOV.working_mode='T');
END IF;

SELECT
    idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,'F') , workingcopies,
	json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id, dispnamev, is_log 
    INTO
    out_idv , out_namev , out_typev , out_status , out_description , out_changelog , out_commitat , out_commitby , out_refidv , 
    out_ver_num , out_work_mode , out_workingcopies , out_json_wc , out_json_lc , out_major_ver , out_minor_ver , out_patch_ver , 
    out_tags ,out_app_id , out_dispnamev , out_is_log; 

END 