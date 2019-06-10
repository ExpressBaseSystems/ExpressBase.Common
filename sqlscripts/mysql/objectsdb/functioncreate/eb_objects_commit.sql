CREATE PROCEDURE eb_objects_commit(IN id TEXT,
    IN obj_name TEXT,
    IN obj_desc TEXT,
    IN obj_type INTEGER,
    IN obj_json JSON,
    IN obj_changelog TEXT,
    IN commit_uid INTEGER,
    IN relations TEXT,
    IN tags TEXT,
    IN app_id TEXT,
    IN disp_name TEXT,
    OUT out_committed_refidunique TEXT)
BEGIN
DECLARE refidunique TEXT;
DECLARE inserted_obj_ver_id INTEGER;
DECLARE objid INTEGER;
DECLARE committed_refidunique TEXT;
DECLARE major INTEGER;
DECLARE minor INTEGER;
DECLARE patch INTEGER;
DECLARE version_number TEXT;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
    
DROP TEMPORARY TABLE IF EXISTS apps;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value INTEGER);
	CALL STR_TO_TBL(app_id);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch 
	FROM eb_objects_ver WHERE refid = id;

  	UPDATE eb_objects eo
	SET 
    	eo.obj_name = obj_name, eo.obj_desc = obj_desc, eo.obj_tags = tags, eo.display_name = disp_name
	WHERE 
    	eo.id = objid; 
		
	UPDATE eb_objects_ver eov
	SET
    	eov.obj_json = obj_json, eov.obj_changelog = obj_changelog, eov.commit_uid = commit_uid, eov.commit_ts = NOW()
	WHERE
    	eov.refid = id;
         
     SET committed_refidunique = id;	
    
-- majorversion.minorversion.patchversion
	SET version_number = CONCAT_WS('.', major, minor, patch);
	UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = id;
   
-- relations table
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
      WHERE 
        dominant IN(SELECT * FROM(
            SELECT dominant FROM eb_objects_relations WHERE dependant = id AND dominant NOT IN 
        (SELECT `value` FROM relationsv))AS a);
            
INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      `value`, id 
      FROM (SELECT `value` FROM relationsv WHERE `value` NOT IN (
		SELECT dominant FROM eb_objects_relations 
                            WHERE dependant = id )) AS dominantvals;  
-- application table  
UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
    WHERE 
        app_id IN(SELECT * FROM (
       SELECT app_id FROM eb_objects2application WHERE obj_id = objid AND eb_del='F' AND app_id NOT IN 
        ( SELECT `value` FROM apps))AS b)
		AND obj_id = objid;
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, objid
      	FROM (SELECT `value` FROM apps WHERE `value` NOT IN
        (SELECT app_id FROM eb_objects2application WHERE obj_id = objid AND eb_del='F'))AS appvals;
     
SELECT committed_refidunique INTO out_committed_refidunique;
END