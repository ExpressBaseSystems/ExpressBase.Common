-- FUNCTION: public.eb_objects_create_new_object(text, text, integer, integer, json, integer, text, text, text, text, text, text, text, text, text, text)

-- DROP FUNCTION public.eb_objects_create_new_object(text, text, integer, integer, json, integer, text, text, text, text, text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_objects_create_new_object(
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
	appsstring text,
	s_obj_id text,
	s_ver_id text,
	disp_name text,
	hide_in_menuv text)

    RETURNS text
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE refidunique text; inserted_objid integer; inserted_obj_ver_id integer; refid_of_commit_version text;
version_number text; relationsv text[]; apps integer[];
BEGIN   

	SELECT string_to_array(relationsstring,',')::text[] into relationsv;
	SELECT string_to_array(appsstring,',')::int[] into apps;
  
    INSERT INTO eb_objects  
        (obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts, display_name, is_logenabled, eb_del, hide_in_menu)
    VALUES
        (obj_namev, obj_descv, obj_typev, obj_cur_statusv, tagsv, commit_uidv, NOW(), disp_name, 'F','F', hide_in_menuv) RETURNING id INTO inserted_objid;

    INSERT INTO eb_objects_ver
        (eb_objects_id, obj_json, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
    VALUES
        (inserted_objid, obj_jsonv, commit_uidv, NOW(),1,0,0,issave)RETURNING id INTO inserted_obj_ver_id;
		
    --majorversion.minorversion.patchversion
    IF issave = 'T' THEN
		version_number := CONCAT_WS('.',1,0,0,'w');
    ELSE
    	version_number := CONCAT_WS('.',1,0,0);
    END IF;
	
	--source_pid-current_pid-object_type-objectid-object_ver_id 
	
	IF s_obj_id = '0' AND s_ver_id='0' THEN
		 refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id, inserted_objid, inserted_obj_ver_id); 
	ELSE
		refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id, s_obj_id, s_ver_id); 
	END IF;

    refid_of_commit_version:=refidunique;                       
	UPDATE eb_objects_ver SET refid = refidunique, version_num = version_number WHERE id = inserted_obj_ver_id;
    
	INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts, changelog) VALUES(inserted_obj_ver_id, obj_cur_statusv, commit_uidv, NOW(), 'Created');
	
    --relations table
    INSERT INTO eb_objects_relations (dominant,dependant) VALUES (UNNEST(relationsv),refidunique);
	
	--applications table
	INSERT INTO eb_objects2application (app_id,obj_id) VALUES (UNNEST(apps),inserted_objid);
		
	RETURN refid_of_commit_version;
END;

$BODY$;