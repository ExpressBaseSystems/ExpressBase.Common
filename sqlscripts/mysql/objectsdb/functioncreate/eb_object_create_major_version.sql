-- FUNCTION: public.eb_objects_create_major_version(text, integer, integer, text, text, text)

DROP FUNCTION IF EXISTS eb_object_create_major_version;

DELIMITER $$

CREATE FUNCTION eb_object_create_major_version(
	idv text,
	obj_typev integer,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsstring text)
    RETURNS text
    DETERMINISTIC
BEGIN
	DECLARE refidunique text;
	DECLARE inserted_obj_ver_id integer;
	DECLARE objid integer;
	DECLARE committed_refidunique text;
	DECLARE major integer;
	DECLARE version_number text;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
    CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
    
    -- CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT string_to_array(relationsstring,',');
    
	SELECT eb_objects_id into objid FROM eb_objects_ver WHERE refid = idv;
	SELECT MAX(major_ver_num) into major from eb_objects_ver WHERE eb_objects_id = objid;

	INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json)
	SELECT
		eb_objects_id,obj_json
	FROM 
		eb_objects_ver
	WHERE
		refid=idv;
	SELECT last_insert_id() INTO inserted_obj_ver_id;
   
		
		SET version_number := CONCAT_WS('.', major+1, 0, 0, 'w');
		
	UPDATE eb_objects_ver
		SET
		commit_ts = NOW(), commit_uid = commit_uidv, version_num = version_number, working_mode = 'T', major_ver_num = major+1, minor_ver_num = 0, patch_ver_num = 0
	WHERE
		id = inserted_obj_ver_id;
        
	SET refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
    SET committed_refidunique:=refidunique;
     
	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;    
    
    INSERT INTO eb_objects_status(eb_obj_ver_id, `status`, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());
        
    CREATE TEMPORARY TABLE IF NOT EXISTS TMPTBL
		SELECT dominant from eb_objects_relations WHERE dependant = refidunique
        AND dominant NOT IN (SELECT  * FROM relationsv);
        
	UPDATE eb_objects_relations
      SET 
        eb_del = 'T', removed_by= commit_uidv , removed_at=NOW()
      WHERE
		dominant IN( SELECT dominant FROM TMPTBL); 
                    
	INSERT INTO eb_objects_relations (dominant, dependant)
		SELECT `value`, refidunique
			FROM (SELECT `value` FROM relationsv WHERE `value` 
					NOT  IN (SELECT dominant FROM eb_objects_relations WHERE dependant = refidunique)) AS a;
    RETURN committed_refidunique;    
END$$