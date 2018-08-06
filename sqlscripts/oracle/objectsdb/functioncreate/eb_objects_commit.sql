create or replace FUNCTION eb_objects_commit(
	idv varchar,
	obj_namev CLOB,
	obj_descv CLOB,
	obj_typev NUMBER,
	--obj_jsonv VARCHAR2,
	obj_changelogv CLOB,
	commit_uidv NUMBER,
	relationsv VARCHAR,
	tagsv CLOB,
	apps VARCHAR)
    RETURN CLOB
    IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    refidunique VARCHAR(900); inserted_obj_ver_id NUMBER; objid NUMBER; committed_refidunique CLOB; major NUMBER; minor NUMBER; patch NUMBER; version_number CLOB;

BEGIN

    SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch FROM eb_objects_ver WHERE refid=idv;

  	UPDATE eb_objects 
	SET 
    	obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv
	WHERE 
    	id = objid; 

    UPDATE eb_objects_ver
	SET
        obj_changelog = obj_changelogv, commit_uid= commit_uidv, commit_ts = SYSTIMESTAMP 
	WHERE
		refid = idv RETURNING id INTO inserted_obj_ver_id;

	/*UPDATE eb_objects_ver
	SET
    	obj_json = obj_jsonv, obj_changelog = obj_changelogv, commit_uid= commit_uidv, commit_ts = SYSTIMESTAMP 
	WHERE
		refid = idv RETURNING id INTO inserted_obj_ver_id;*/

       --refidunique :=CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(CONCAT(src_pid,'-'),cur_pid),'-'),obj_typev),'-'),objid),'-'),inserted_obj_ver_id);
        --committed_refidunique:=refidunique;
        --UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;  

        committed_refidunique:=idv;

	--majorversion.minorversion.patchversion
        version_number := CONCAT(CONCAT(CONCAT(CONCAT(major,'.'),minor),'.'),patch);
        UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = idv;

   --relations table
    UPDATE eb_objects_relations SET eb_del = 'T', removed_by= commit_uidv , removed_at=SYSTIMESTAMP
      WHERE 
        dominant IN(SELECT dominant FROM eb_objects_relations WHERE dependant = idv 
                    MINUS 
                    SELECT regexp_substr(relationsv,'[^,]+', 1, level)  from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null);

    INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      dominantvals, idv 
      FROM (
      SELECT regexp_substr(relationsv,'[^,]+', 1, level)  AS dominantvals from dual CONNECT BY regexp_substr(relationsv, '[^,]+', 1, level) is not null
      MINUS
      select dominant from eb_objects_relations WHERE dependant = idv
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
      appvals, objid 
      FROM (
      SELECT regexp_substr(apps,'[^,]+', 1, level)  AS appvals from dual CONNECT BY regexp_substr(apps, '[^,]+', 1, level) is not null
      MINUS
      select to_char(app_id) from eb_objects2application WHERE obj_id = objid AND eb_del='F'
      );				

    COMMIT;               
    RETURN committed_refidunique; 


END;