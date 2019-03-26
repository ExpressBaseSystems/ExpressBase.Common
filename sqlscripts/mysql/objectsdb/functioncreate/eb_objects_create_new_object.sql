CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_objects_create_new_object`(obj_namev text,
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
    appsstring text,
    s_obj_id text,
    s_ver_id text,
    disp_name text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_objid integer;
DECLARE inserted_obj_ver_id integer;
DECLARE refid_of_commit_version text;
DECLARE version_number text;

 drop temporary table if exists relationsv;
 drop temporary table if exists apps;
 drop temporary table if exists temp_array_table;

 CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(id int auto_increment primary key, value TEXT);
        
	CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv(id integer,value text) SELECT id,`value` FROM temp_array_table;
   

	CALL STR_TO_TBL(appsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps(id integer,value text) SELECT id,`value` FROM temp_array_table;
    INSERT INTO eb_objects  
        (obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts, display_name, is_logenabled, eb_del)
    VALUES
        (obj_namev, obj_descv, obj_typev, obj_cur_statusv, tagsv, commit_uidv, NOW(), disp_name, 'F','F');
       select  last_insert_id() into inserted_objid;

    INSERT INTO eb_objects_ver
        (eb_objects_id, obj_json, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
    VALUES
        (inserted_objid, obj_jsonv, commit_uidv, NOW(),1,0,0,issave);
	 select last_insert_id() INTO inserted_obj_ver_id ;	
    /*majorversion.minorversion.patchversion*/
    IF issave = 'T' THEN
		set version_number = CONCAT_WS('.',1,0,0,'w');
    ELSE
    	set version_number = CONCAT_WS('.',1,0,0);
    END IF;
	
	/*source_pid-current_pid-object_type-objectid-object_ver_id */
	
	IF s_obj_id = '0' AND s_ver_id='0' THEN
		 set refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id, inserted_objid, inserted_obj_ver_id); 
	ELSE
		set refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id, s_obj_id, s_ver_id); 
	 END IF;

   set refid_of_commit_version=refidunique;                       
	 UPDATE eb_objects_ver SET refid = refidunique, version_num = version_number WHERE id = inserted_obj_ver_id;
    
	INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts, changelog) VALUES(inserted_obj_ver_id, obj_cur_statusv, commit_uidv, NOW(), 'Created');
	
    /*relations table*/
    INSERT INTO eb_objects_relations (dominant,dependant) VALUES ((select `value`  from relationsv),refidunique);
	
	/*applications table*/
	INSERT INTO eb_objects2application (app_id,obj_id) VALUES ((select `value` from apps),inserted_objid);
		
	  select refid_of_commit_version;
END