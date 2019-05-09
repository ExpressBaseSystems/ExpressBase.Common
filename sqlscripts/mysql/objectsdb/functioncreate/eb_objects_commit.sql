CREATE PROCEDURE eb_objects_commit(in id text,
    in obj_name text,
    in obj_desc text,
    in obj_type integer,
    in obj_json json,
    in obj_changelog text,
    in commit_uid integer,
    in relations text,
    in tags text,
    in app_id text,
    in disp_name text,
    out out_committed_refidunique text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE committed_refidunique text;
DECLARE major integer;
DECLARE minor integer;
DECLARE patch integer;
DECLARE version_number text;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
    
DROP TEMPORARY TABLE IF EXISTS apps;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value integer);
	CALL STR_TO_TBL(app_id);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch FROM eb_objects_ver WHERE refid=id;

  	UPDATE eb_objects eo
	SET 
    	eo.obj_name = obj_name, eo.obj_desc = obj_desc, eo.obj_tags = tags, eo.display_name = disp_name
	WHERE 
    	eo.id = objid; 
		
	UPDATE eb_objects_ver eov
	SET
    	eov.obj_json = obj_json, eov.obj_changelog = obj_changelog, eov.commit_uid= commit_uid, eov.commit_ts = NOW()
	WHERE
    	eov.refid = id;
         
     set committed_refidunique=id;
	
    
-- majorversion.minorversion.patchversion
	set version_number := CONCAT_WS('.', major, minor, patch);
   UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = id;
   
-- relations table
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
      WHERE 
        dominant IN(select * from(
            select dominant from eb_objects_relations WHERE dependant = id and dominant not in 
        (select `value` from relationsv))as a);
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      `value`, id 
      FROM (SELECT `value` from relationsv where `value`
        not in 
      (SELECT dominant FROM eb_objects_relations 
                            WHERE dependant = id )) as dominantvals;  
-- application table  
UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
    WHERE 
        app_id IN(SELECT * FROM (
       SELECT app_id FROM eb_objects2application WHERE obj_id = objid AND eb_del='F' and app_id not in 
        ( SELECT `value` FROM apps))as b)
		AND obj_id = objid;
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, objid
      	FROM (SELECT `value` FROM apps where `value` not in
        (SELECT app_id FROM eb_objects2application WHERE obj_id = objid AND eb_del='F'))as appvals;
     
SELECT committed_refidunique INTO out_committed_refidunique;
END