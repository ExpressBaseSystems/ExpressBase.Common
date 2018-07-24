-- FUNCTION: public.eb_objects_create_new_object(text, text, integer, integer, json, integer, text, text, text, text, text, text)

-- DROP FUNCTION if exists eb_objects_create_new_object;

DELIMITER $$

CREATE FUNCTION eb_objects_create_new_object(
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_cur_statusv integer,
	obj_jsonv json,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsstring text,
	issave text,
	tagsv text,
	appsstring text)
    RETURNS text
    DETERMINISTIC
BEGIN
	DECLARE refidunique text;
	DECLARE  inserted_objid integer;
	DECLARE  inserted_obj_ver_id integer;
	DECLARE  refid_of_commit_version text;
	DECLARE version_number text;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
	
	CALL STR_TO_TBL(appsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;
    
	INSERT INTO eb_objects  
		(obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts)
	VALUES
		(obj_namev, obj_descv, obj_typev, obj_cur_statusv, tagsv, commit_uidv, NOW());
	SELECT last_insert_id() INTO inserted_objid;

	INSERT INTO eb_objects_ver
		(eb_objects_id, obj_json, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
	VALUES
		(inserted_objid, obj_jsonv, commit_uidv, NOW(),1,0,0,issave);
	SELECT last_insert_id() INTO inserted_obj_ver_id;
		
	-- majorversion.minorversion.patchversion
	IF issave = 'T' THEN
		SET version_number := CONCAT_WS('.',1,0,0,'w');
	ELSE
		SET version_number := CONCAT_WS('.',1,0,0);
	END IF;
		
	-- source_pid-current_pid-object_type-objectid-object_ver_id 
	SET refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id); 
	
	SET refid_of_commit_version:=refidunique;                       
	UPDATE eb_objects_ver SET refid = refidunique, version_num = version_number WHERE id = inserted_obj_ver_id;
	
	INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts, changelog) VALUES(inserted_obj_ver_id, obj_cur_statusv, commit_uidv, NOW(), 'Created');
	
	-- relations table
	INSERT INTO eb_objects_relations (dominant,dependant) VALUES (UNNEST(relationsv),refidunique);
	
	-- applications table
	INSERT INTO eb_objects2application (app_id,obj_id) VALUES (UNNEST(apps),inserted_objid);
	
	DROP TEMPORARY TABLE IF EXISTS relationsv;
	DROP TEMPORARY TABLE IF EXISTS apps;
	RETURN refid_of_commit_version;
END;