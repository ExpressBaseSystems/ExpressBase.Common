-- FUNCTION: public.eb_objects_save(text, text, text, integer, json, integer, text, text, text, text, text)

-- DROP FUNCTION eb_objects_save;
DELIMITER $$

CREATE FUNCTION eb_objects_save(
	refidv text,
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_jsonv json,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsstring text,
	tagsv text,
	appsstring text)
    RETURNS text
    DETERMINISTIC
    
BEGIN
	DECLARE refidunique text;
	DECLARE inserted_objid integer;
	DECLARE inserted_obj_ver_id integer;
	DECLARE objid integer;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
	
	CALL STR_TO_TBL(appsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;
     
	SELECT eb_objects_id FROM eb_objects_ver WHERE refid=refidv INTO objid ;
    
 	UPDATE eb_objects 
		SET obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv
        WHERE id = objid;
        SELECT last_insert_id() INTO inserted_objid;
        
    UPDATE eb_objects_ver
		SET obj_json = obj_jsonv
        WHERE refid=refidv;
        SELECT last_insert_id() INTO inserted_obj_ver_id;
    
	--   refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id);                                 
	-- UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;
	-- relations table
	UPDATE eb_objects_relations 
		SET 
			eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
		WHERE 
			dominant IN(SELECT dominant FROM eb_objects_relations WHERE dependant = refidv AND dominant
				NOT IN(SELECT `value` FROM relationsv));
				
	INSERT INTO eb_objects_relations
		(dominant, dependant) 
		SELECT 
			`value`, refidv
		FROM (SELECT `value` FROM relationsv WHERE `value` 
			NOT IN(SELECT dominant FROM eb_objects_relations WHERE dependant = refidv)) as a;

-- applications table 
  UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(SELECT app_id FROM eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F' AND app_id
					NOT IN(SELECT `value`  FROM apps))
				AND obj_id = inserted_objid;
            
	INSERT INTO eb_objects2application (app_id, obj_id) 
	SELECT 
		`value`, inserted_objid
	FROM (SELECT `value`  FROM apps WHERE `value` 
		NOT IN(SELECT app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')) as b;
    
  RETURN refidv;
END;
