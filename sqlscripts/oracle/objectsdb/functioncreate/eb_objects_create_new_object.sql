create or replace FUNCTION eb_objects_create_new_object(
	obj_namev CLOB,
	obj_descv CLOB,
	obj_typev number,
	obj_cur_statusv number,
	--obj_jsonv CLOB,
	commit_uidv number,
	src_pid CLOB,
	cur_pid CLOB,
	relationsv VARCHAR,
	issave char,
	tagsv CLOB,
	apps VARCHAR,
    s_obj_id CLOB,
    s_ver_id CLOB
    )
    RETURN CLOB is 
    PRAGMA AUTONOMOUS_TRANSACTION;
     refidunique CLOB; inserted_objid number; inserted_obj_ver_id number; refid_of_commit_version CLOB; version_number CLOB;rel CLOB;app number;
BEGIN   

    INSERT INTO eb_objects 
        (obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts)
    VALUES
        (obj_namev, obj_descv, obj_typev, obj_cur_statusv, tagsv, commit_uidv, SYSTIMESTAMP) RETURNING id INTO inserted_objid;

        INSERT INTO eb_objects_ver
        (eb_objects_id, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
    VALUES
        (inserted_objid, commit_uidv, SYSTIMESTAMP,1,0,0,issave)RETURNING id INTO inserted_obj_ver_id;

    --majorversion.minorversion.patchversion
    IF issave = 'T' THEN        version_number := CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(1,'.'),0),'.'),0),'.'),'w') ;    ELSE
    	version_number :=CONCAT(CONCAT(CONCAT(CONCAT(1,'.'),0),'.'),0);    
    END IF;

	 --refidunique := CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(src_pid,'-'),cur_pid),'-'),obj_typev),'-'),inserted_objid),'-'),inserted_obj_ver_id);
     
     IF s_obj_id = '0' AND s_ver_id='0' THEN    
        refidunique := src_pid||'-'||cur_pid||'-'||obj_typev||'-'||inserted_objid||'-'||inserted_obj_ver_id||'-'||inserted_objid||'-'||inserted_obj_ver_id; 
    ELSE
        refidunique := src_pid||'-'||cur_pid||'-'||obj_typev||'-'||inserted_objid||'-'||inserted_obj_ver_id||'-'||s_obj_id||'-'||s_ver_id;
    END IF;
     
     
     
    refid_of_commit_version:=refidunique;                       
	UPDATE eb_objects_ver SET refid = refidunique, version_num = version_number WHERE id = inserted_obj_ver_id;

	INSERT INTO eb_objects_status(eb_obj_ver_id, status, USERID, ts, changelog) VALUES(inserted_obj_ver_id, 0, commit_uidv, SYSTIMESTAMP, 'Created');
    --relations table
    INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, refidunique 
      FROM (
      SELECT regexp_substr(relationsv,'[^,]+', 1, level)  AS dominantvals from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null      );

	--applications table     
		INSERT INTO eb_objects2application 
        (app_id,obj_id)
    SELECT 
      appid, inserted_objid 
      FROM (
      SELECT regexp_substr(apps,'[^,]+', 1, level)  AS appid from dual CONNECT BY regexp_substr(apps, '[^,]+', 1, level) is not null      );

    COMMIT;
	RETURN refid_of_commit_version;
END;
