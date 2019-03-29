CREATE PROCEDURE eb_objects_save(in refidv text,
    in obj_namev text,
    in obj_descv text,
    in obj_typev integer,
    in obj_jsonv json,
    in commit_uidv integer,
    in relationsstring text,
    in tagsv text,
    in appsstring text,
    in disp_name text,
    out out_refidv text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_objid integer;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;

drop temporary table if exists temp_array_table;
drop temporary table if exists relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
drop temporary table if exists apps;
drop temporary table if exists temp_array_table;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(id integer auto_increment primary key, value integer);
	CALL STR_TO_TBL(appsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT id,`value` FROM temp_array_table;

SELECT eb_objects_id into objid  FROM eb_objects_ver  WHERE refid=refidv  ;
 	 UPDATE eb_objects SET obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv , display_name = disp_name WHERE id = objid;
  select last_insert_id() INTO inserted_objid;
    SET SQL_SAFE_UPDATES=0;
    UPDATE eb_objects_ver  SET obj_json = obj_jsonv WHERE refid=refidv  ;
    select last_insert_id() INTO inserted_obj_ver_id;
    
    --   refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id);                                 
 -- UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;
    
    -- relations table
	UPDATE eb_objects_relations 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        dominant IN(
      select * from ( select dominant from eb_objects_relations WHERE dependant = refidv and dominant not in
        (select `value` from relationsv))as a);
            
        INSERT INTO eb_objects_relations (dominant, dependant) 
        SELECT 
     		`value`, refidv
      	FROM (SELECT `value` from relationsv where `value` not in
        (select dominant from eb_objects_relations WHERE dependant = refidv )) as dominantvals;
-- applications table 
  UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(
       select * from( select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F' and app_id not in
        ( select `value` from apps where id=1))as b)
		AND obj_id = inserted_objid;
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, inserted_objid
      	FROM (SELECT `value` from apps where id=1  
        and `value` not in
      	(select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')) as appvals;

  select refidv into out_refidv;
END