CREATE PROCEDURE eb_objects_create_new_object(IN obj_name TEXT,
    IN obj_desc TEXT,
    IN obj_type INTEGER,
    IN obj_cur_status INTEGER,
    IN obj_json JSON,
    IN commit_uid INTEGER,
    IN src_pid TEXT,
    IN cur_pid TEXT,
    IN relations TEXT,
    IN issave TEXT,
    IN tags TEXT,
    IN app_id TEXT,
    IN s_obj_id TEXT,
    IN s_ver_id TEXT,
    IN disp_name TEXT,
    OUT out_refid_of_commit_version TEXT)
BEGIN
DECLARE refidunique TEXT;
DECLARE inserted_objid INTEGER;
DECLARE inserted_obj_ver_id INTEGER;
DECLARE refid_of_commit_version TEXT;
DECLARE version_number TEXT;

 DROP TEMPORARY TABLE IF EXISTS relationsv;
 DROP TEMPORARY TABLE IF EXISTS apps;
 DROP TEMPORARY TABLE IF EXISTS temp_array_table;

 CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv(value TEXT) SELECT `value` FROM temp_array_table;
   
	CALL STR_TO_TBL(app_id);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps(value TEXT) SELECT `value` FROM temp_array_table;
INSERT INTO eb_objects  
        (obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts, display_name, is_logenabled, eb_del)
	VALUES
        (obj_name, obj_desc, obj_type, obj_cur_status, tags, commit_uid, NOW(), disp_name, 'F','F');
	SELECT  LAST_INSERT_ID() INTO inserted_objid;
INSERT INTO eb_objects_ver
        (eb_objects_id, obj_json, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
	VALUES
		(inserted_objid, obj_json, commit_uid, NOW(),1,0,0,issave);
	SELECT LAST_INSERT_ID() INTO inserted_obj_ver_id ;	
  
  /*majorversion.minorversion.patchversion*/
    IF issave = 'T' THEN
		SET version_number = CONCAT_WS('.',1,0,0,'w');
    ELSE
    	SET version_number = CONCAT_WS('.',1,0,0);
    END IF;
	
	/*source_pid-current_pid-object_type-objectid-object_ver_id */
	
	IF s_obj_id = '0' AND s_ver_id='0' THEN
		 SET refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_type, inserted_objid, inserted_obj_ver_id, inserted_objid, inserted_obj_ver_id); 
	ELSE
		SET refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_type, inserted_objid, inserted_obj_ver_id, s_obj_id, s_ver_id); 
	 END IF;

	SET refid_of_commit_version=refidunique;                       
	UPDATE eb_objects_ver SET refid = refidunique, version_num = version_number WHERE id = inserted_obj_ver_id;
    
	INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts, changelog) VALUES(inserted_obj_ver_id, obj_cur_status, commit_uid, NOW(), 'Created');
	
    /*relations table*/
    INSERT INTO eb_objects_relations (dominant,dependant) VALUES ((SELECT `value` FROM relationsv),refidunique);
	
	/*applications table*/
	INSERT INTO eb_objects2application (app_id,obj_id) VALUES ((SELECT `value` FROM apps),inserted_objid);    
		
	SELECT refid_of_commit_version INTO out_refid_of_commit_version;
END