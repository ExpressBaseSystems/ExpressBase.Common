
-- FUNCTION: eb_objects_commit(text, text, text, integer, json, text, integer, text, text, text, text, text)

-- DROP FUNCTION eb_objects_commit;
DELIMITER $$

CREATE FUNCTION eb_objects_commit(
	idv text,
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_jsonv json,
	obj_changelogv text,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsstring text,
	tagsv text,
	appsstring text)
    RETURNS text
    DETERMINISTIC

    
BEGIN
	DECLARE  refidunique text;
	DECLARE  inserted_obj_ver_id integer;
	DECLARE  objid integer;
	DECLARE  committed_refidunique text;
	DECLARE  major integer;
	DECLARE  minor integer;
	DECLARE  patch integer;
	DECLARE  version_number text;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
	
	CALL STR_TO_TBL(appsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;

	SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch FROM eb_objects_ver WHERE refid=idv;

  	UPDATE eb_objects 
	SET 
    	obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv
	WHERE 
    	id = objid; 
		
	UPDATE eb_objects_ver
	SET
    	obj_json = obj_jsonv, obj_changelog = obj_changelogv, commit_uid= commit_uidv, commit_ts = NOW()
	WHERE
    	-- eb_objects_id= objid AND major_ver_num=major AND working_mode='T' 
		refid = idv;
	SELECT last_insert_id() INTO inserted_obj_ver_id;
    
    -- refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
	SET committed_refidunique:=idv;
	-- UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;  
	
	-- majorversion.minorversion.patchversion
	SET version_number := CONCAT_WS('.', major, minor, patch);
    UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = idv;

    -- relations table
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
      WHERE 
        dominant IN(
            SELECT dominant from eb_objects_relations WHERE dependant = idv 
			AND  dominant NOT IN (SELECT * FROM relationsv));
            
	 INSERT INTO eb_objects_relations 
        (dominant, dependant) 
     SELECT  
		`value`, idv 
		FROM (SELECT `value` FROM relationsv WHERE `value`
			NOT IN (SELECT dominant from eb_objects_relations WHERE dependant = idv )) AS a;  

	-- application table
	UPDATE eb_objects2application 
		SET 
			eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
		WHERE 
			app_id IN(	SELECT app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F'
						AND  app_id NOT IN(SELECT COALESCE(apps,'')))
					AND obj_id = objid;
				
			INSERT INTO eb_objects2application 
				(app_id, obj_id) 
			SELECT 
				`value`, 'objid'
			FROM (SELECT `value` FROM apps WHERE  `value`
					NOT IN ( SELECT app_id FROM eb_objects2application WHERE obj_id = objid AND eb_del='F')) AS b;
								
	DROP TEMPORARY TABLE IF EXISTS relationsv;
	DROP TEMPORARY TABLE IF EXISTS apps;
    RETURN committed_refidunique;
END;

