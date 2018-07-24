-- FUNCTION: public.eb_objects_create_patch_version(text, integer, integer, text, text, text)

-- DROP FUNCTION eb_object_create_patch_version;

DELIMITER $$

CREATE FUNCTION eb_object_create_patch_version(
	idv text,
	obj_typev integer,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsstring text)
    RETURNS text
    DETERMINISTIC
BEGIN
	DECLARE  refidunique text;
	DECLARE  inserted_obj_ver_id integer;
	DECLARE  objid integer;
	DECLARE  committed_refidunique text;
	DECLARE  major integer;
	DECLARE	 minor integer;
	DECLARE  patch integer;
	DECLARE  version_number text;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
    CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
    
	SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch  FROM eb_objects_ver WHERE refid=idv;
		
	INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json, major_ver_num, minor_ver_num)
		SELECT
			eb_objects_id, obj_json, major_ver_num, minor_ver_num
		FROM 
			eb_objects_ver
		WHERE
			refid=idv;
	SELECT last_insert_id() INTO inserted_obj_ver_id;

	SET version_number := CONCAT_WS('.', major, minor, patch + 1,'w');
		
	UPDATE eb_objects_ver
		SET
			commit_ts = NOW(), Commit_uid = commit_uidv, version_num = version_number, working_mode = 'T', patch_ver_num = patch + 1
			WHERE 
				id = inserted_obj_ver_id ;

	SET refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
	SET committed_refidunique:=refidunique;

	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;

	INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());

	UPDATE eb_objects_relations 
	SET 
		eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
		WHERE 
			dominant IN(
			SELECT dominant from eb_objects_relations WHERE dependant = refidunique
			AND dominant NOT IN (SELECT * FROM relationsv));
				
		INSERT INTO eb_objects_relations (dominant, dependant) 
			SELECT 
			  `value`, refidunique 
			FROM (SELECT `value` FROM relationsv WHERE `value`
				NOT IN (SELECT dominant from eb_objects_relations WHERE dependant = refidunique))as a;  
	DROP TEMPORARY TABLE IF EXISTS relationsv;                                                
	RETURN committed_refidunique; 	

END$$