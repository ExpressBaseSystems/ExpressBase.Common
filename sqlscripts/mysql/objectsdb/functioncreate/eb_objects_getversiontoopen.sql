CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_objects_getversiontoopen`(_id integer)
BEGIN
DECLARE workingcopies text;
DECLARE	json_wc json;
DECLARE json_lc json;
DECLARE no_of_workcopies integer;
DECLARE	idv integer;
DECLARE namev text;
DECLARE typev integer;
DECLARE status integer;
DECLARE	description text;
DECLARE changelog text;
DECLARE commitat text;
DECLARE commitby text;
DECLARE refidv text;
DECLARE ver_num text;
DECLARE work_mode char;
DECLARE	major_ver integer;
DECLARE minor_ver integer;
DECLARE patch_ver integer;
DECLARE tags text;
DECLARE app_id text;
DECLARE	lastversionnumber text;
DECLARE lastversionrefid text;
DECLARE liveversionnumber text;
DECLARE liveversionrefid text;
DECLARE dispnamev text;
DECLARE is_log char;

set workingcopies = NULL;
set	json_wc = NULL;
set	json_lc =NULL;

-- Fetching all working copies
SELECT 
	group_concat((json_object( version_num, refid)),','),count(*) INTO workingcopies, no_of_workcopies
FROM 
	eb_objects_ver 
WHERE 
	eb_objects_id=_id AND working_mode='T';

 select group_concat(EA.applicationname,',') INTO app_id from eb_objects2application E2O ,eb_applications EA where 
 obj_id = _id and E2O.eb_del = 'F' and EA.id = E2O.app_id ;
 
 
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
		EOV.commit_uid=EU.id
	LEFT JOIN
		eb_objects_status EOS
	ON 
		EOS.eb_obj_ver_id = EOV.id										 
	WHERE 
			EO.id = _id AND EOV.eb_objects_id = EO.id AND working_mode='T'
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
-- No working copy			
elseif no_of_workcopies = 0 THEN
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
                EOV.commit_uid=EU.id	
		LEFT JOIN
			eb_objects_status EOS
		ON 
			EOS.eb_obj_ver_id = EOV.id									 
        WHERE 
                EO.id = _id AND EOV.eb_objects_id = EO.id  AND
                major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=_id) AND 
                minor_ver_num=(Select max(minor_ver_num) from eb_objects_ver where eb_objects_id=_id AND  
				major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=_id)) AND
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
		EOV.commit_uid=EU.id
	LEFT JOIN
		eb_objects_status EOS
	ON 
		EOS.eb_obj_ver_id = EOV.id		
	WHERE 
		EO.id = _id AND EOV.eb_objects_id = EO.id AND working_mode='T'
		AND EOV.id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = _id AND working_mode='T')
		AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS, eb_objects_ver EOV WHERE EOS.eb_obj_ver_id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = _id AND working_mode='T') AND EOV.working_mode='T');
END IF;
-- drop temporary table if exists eb_objects_getversiontoopen_tmp;
drop temporary table if exists eb_objects_getversiontoopen_tmp;
-- insert into eb_objects_getversiontoopen_tmp(idv,namev ,typev ,status,
 -- description ,changelog ,commitat ,commitby ,refidv ,ver_num ,work_mode ,workingcopies ,
 -- json_wc ,json_lc ,major_ver ,minor_ver ,patch_ver ,tags ,app_id ,dispnamev ,is_log )
 create temporary table eb_objects_getversiontoopen_tmp(idv integer,namev text,typev integer,status integer,
 description text,changelog text,commitat text,commitby text,refidv text,ver_num text,work_mode char,workingcopies text,
 json_wc json,json_lc json,major_ver integer,minor_ver integer,patch_ver integer,tags text,app_id text,dispnamev text,is_log char);
insert into eb_objects_getversiontoopen_tmp(idv,namev ,typev ,status,
   description ,changelog ,commitat ,commitby ,refidv ,ver_num ,work_mode ,workingcopies ,
   json_wc ,json_lc ,major_ver ,minor_ver ,patch_ver ,tags ,app_id ,dispnamev ,is_log )

values( idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,'F') , workingcopies,
	json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id, dispnamev, is_log);
END