
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

 select string_to_array(appsstring,',')::int[] into apps;
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
    	--eb_objects_id= objid AND major_ver_num=major AND working_mode='T' 
		refid = idv RETURNING id INTO inserted_obj_ver_id;
    
    --refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
     committed_refidunique:=idv;
	--UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;  
	
	--majorversion.minorversion.patchversion
	version_number := CONCAT_WS('.', major, minor, patch);
   UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = idv;

   --relations table
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
      WHERE 
        dominant IN(
            SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = idv)) 
        EXCEPT 
            SELECT unnest(ARRAY[relationsv]));
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, idv 
      FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        EXCEPT 
      SELECT unnest(array(select dominant from eb_objects_relations 
                            WHERE dependant = idv )))) as dominantvals;  

--application table
UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(
        SELECT unnest(ARRAY(select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F')) 
        EXCEPT 
        SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])]))
		AND obj_id = objid;
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		appvals, objid
      	FROM UNNEST(array(SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])])
        EXCEPT 
      	SELECT unnest(array(select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F')))) as appvals;
									
    RETURN committed_refidunique; 	

END;

