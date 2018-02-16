-- FUNCTION: public.eb_objects_getversiontoopen(integer)

-- DROP FUNCTION public.eb_objects_getversiontoopen(integer);

create or replace type GET_VERSION_RECORD as object (
  idv NUMBER,
  namev CLOB, 
  typev NUMBER, 
  status NUMBER, 
  description CLOB,
  changelog CLOB,
  commitat TIMESTAMP,
  commitby CLOB,
  refidv CLOB,
  ver_num CLOB,
  work_mode CHAR,
  workingcopies CLOB, 
  json_wc CLOB, 
  json_lc CLOB,
  major_ver NUMBER,
  minor_ver NUMBER,
  patch_ver NUMBER,
  tags CLOB, 
  app_id CLOB
);
/

create or replace type GET_VERSION_TABLE as table of GET_VERSION_record;
/



-- FUNCTION: public.eb_objects_getversiontoopen(integer)

-- DROP FUNCTION public.eb_objects_getversiontoopen(integer);

CREATE OR REPLACE FUNCTION eb_objects_getversiontoopen(
	id_ integer)
    RETURN GET_VERSION_TABLE 
    AS
    getversion_tbl GET_VERSION_TABLE:=GET_VERSION_TABLE();
    workingcopies CLOB;
	json_wc CHAR; json_lc CLOB; no_of_workcopies NUMBER;
	idv NUMBER; namev CLOB; typev NUMBER; status NUMBER;
	description CLOB; changelog CLOB; commitat TIMESTAMP; commitby CLOB; refidv CLOB; ver_num CLOB; work_mode CHAR;
	major_ver NUMBER; minor_ver NUMBER; patch_ver NUMBER; tags CLOB; app_id CLOB;
	lastversionnumber CLOB; lastversionrefid CLOB; liveversionnumber CLOB; liveversionrefid CLOB;
BEGIN

	workingcopies := NULL;
	json_wc := NULL;
	json_lc :=NULL;
    
    --Fetching all working copies
    SELECT 
        LISTAGG(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT('{','"'),version_num),'"'),':'),'"'),refid),'"'),'}'),',')
        WITHIN GROUP(ORDER BY version_num) INTO workingcopies
    FROM 
        eb_objects_ver 
    WHERE 
        eb_objects_id=id_ AND working_mode='T';
        
        select REGEXP_COUNT(workingcopies, ',') into no_of_workcopies from dual;
        no_of_workcopies :=COALESCE(no_of_workcopies+1,0);
        
        --no_of_workcopies := COALESCE(array_length(workingcopies, 1), 0);

        select LISTAGG(EA.application_name,',') WITHIN GROUP(ORDER BY application_name) INTO app_id from eb_objects2application E2O ,eb_applications EA where 
 obj_id = id_ and E2O.eb_del = 'F' and EA.id = E2O.app_id ;

--one working copy	
IF no_of_workcopies = 1 THEN
	SELECT 
			EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc,
			EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
			EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
	INTO	idv, namev, typev, status, description, json_wc, changelog, commitat, refidv, ver_num, work_mode, commitby,
			major_ver, minor_ver, patch_ver, tags
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
			EO.id = id_ AND EOV.eb_objects_id = EO.id AND working_mode='T'
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
			
--No working copy			
ELSIF no_of_workcopies = 0 THEN
        SELECT 
                EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc, 
                EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
				EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
        INTO	idv, namev, typev, status, description, json_lc, changelog, commitat, refidv, ver_num, work_mode,
				commitby, major_ver, minor_ver, patch_ver, tags
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
                EO.id = id_ AND EOV.eb_objects_id = EO.id  AND
                major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=id_) AND 
                minor_ver_num=(Select max(minor_ver_num) from eb_objects_ver where eb_objects_id=id_ AND  
				major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=id_)) AND
                COALESCE(working_mode, 'F') <> 'T'
				AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);    
		
-- multiple workingcopies
ELSE
SELECT 
			EO.id, EO.obj_name, EO.obj_type, EOS.status, EO.obj_desc,
			EOV.obj_json, EOV.obj_changelog, EOV.commit_ts, EOV.refid, EOV.version_num, EOV.working_mode, 
			EU.firstname, EOV.major_ver_num, EOV.minor_ver_num, EOV.patch_ver_num, EO.obj_tags
	 INTO	idv, namev, typev, status, description, json_lc, changelog, commitat, refidv, ver_num, work_mode,
			commitby, major_ver, minor_ver, patch_ver, tags
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
		EO.id = id_ AND EOV.eb_objects_id = EO.id AND working_mode='T'
		AND EOV.id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = id_ AND working_mode='T')
		AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS, eb_objects_ver EOV WHERE EOS.eb_obj_ver_id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = id_ AND working_mode='T') AND EOV.working_mode='T');

END IF;

   
    getversion_tbl.extend();
    getversion_tbl(1) := GET_VERSION_RECORD(idv, namev, typev, status, description, changelog, commitat, commitby, refidv, ver_num, COALESCE(work_mode,'F'), workingcopies,
	json_wc, json_lc, major_ver, minor_ver, patch_ver, tags, app_id);
    RETURN getversion_tbl;
END;

