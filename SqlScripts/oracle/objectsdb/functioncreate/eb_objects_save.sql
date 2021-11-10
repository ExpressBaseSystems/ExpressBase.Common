create or replace FUNCTION eb_objects_save(
	refidv VARCHAR,
	obj_namev CLOB,
	obj_descv CLOB,
	obj_typev NUMBER,
	--obj_jsonv CLOB,
	commit_uidv NUMBER,
	relationsv VARCHAR,
	tagsv CLOB,
	apps VARCHAR)
    RETURN CLOB
    IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    inserted_objid NUMBER; inserted_obj_ver_id NUMBER; objid NUMBER; --relationsv text[]; apps integer[];
BEGIN

    SELECT eb_objects_id into objid FROM eb_objects_ver  WHERE refid=refidv;

 	UPDATE eb_objects SET obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv WHERE id = objid RETURNING id INTO inserted_objid;

    --UPDATE eb_objects_ver SET obj_json = obj_jsonv WHERE refid=refidv RETURNING id INTO inserted_obj_ver_id;

    --refidunique := CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(src_pid,'-'),cur_pid),'-'),obj_typev),'-'),inserted_objid),'-'),inserted_obj_ver_id);

	--UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;


     --relations table
    UPDATE eb_objects_relations SET eb_del = 'T', removed_by= commit_uidv , removed_at=SYSTIMESTAMP
      WHERE 
        dominant IN(SELECT dominant FROM eb_objects_relations WHERE dependant = refidv 
                    MINUS 
                    SELECT regexp_substr(relationsv,'[^,]+', 1, level)  from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null);

    INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, refidv 
      FROM (
      SELECT regexp_substr(relationsv,'[^,]+', 1, level)  AS dominantvals from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null
      MINUS
      select dominant from eb_objects_relations WHERE dependant = refidv
      );

    --application table
       UPDATE eb_objects2application SET eb_del = 'T', removed_by= commit_uidv , removed_at=SYSTIMESTAMP
      WHERE 
        app_id IN(SELECT to_char(app_id) FROM eb_objects2application WHERE obj_id = objid AND eb_del='F' 
                    MINUS 
                    SELECT regexp_substr(apps,'[^,]+', 1, level) FROM dual CONNECT BY regexp_substr(apps, '[^,]+', 1, level) is not null)
			AND obj_id = objid;

    INSERT INTO eb_objects2application 
        (app_id, obj_id) 
    SELECT 
      appvals, inserted_objid 
      FROM (
      SELECT regexp_substr(apps,'[^,]+', 1, level)  AS appvals from dual CONNECT BY regexp_substr(apps, '[^,]+', 1, level) is not null
      MINUS
      select to_char(app_id) from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F'
      );				

     COMMIT;       
    RETURN refidv;
END;