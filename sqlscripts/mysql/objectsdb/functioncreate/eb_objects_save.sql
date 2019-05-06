CREATE PROCEDURE eb_objects_save(in id text,
    in obj_name text,
    in obj_desc text,
    in obj_type integer,
    in obj_json json,
    in commit_uid integer,
    in relations text,
    in tags text,
    in app_id text,
    in disp_name text,
    out out_refidv text)
BEGIN
DECLARE refidunique text;
DECLARE objid integer;

drop temporary table if exists temp_array_table;
drop temporary table if exists relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
drop temporary table if exists apps;
drop temporary table if exists temp_array_table;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
	CALL STR_TO_TBL(app_id);  -- fill to temp_array_table
	CREATE temporary table IF NOT EXISTS apps SELECT `value` FROM temp_array_table;

SELECT eb_objects_id into objid  FROM eb_objects_ver  WHERE refid=id;
 	 UPDATE eb_objects e SET e.obj_name = obj_name, e.obj_desc = obj_desc, e.obj_tags = tags , e.display_name = disp_name WHERE e.id = objid;
    
    SET SQL_SAFE_UPDATES=0;
    UPDATE eb_objects_ver eov SET eov.obj_json = obj_json WHERE eov.refid=id  ;
    
        
-- relations table
	UPDATE eb_objects_relations 
    SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
    WHERE 
        dominant IN(
      select * from ( select dominant from eb_objects_relations WHERE dependant = id and dominant not in
        (select `value` from relationsv))as a);
            
        INSERT INTO eb_objects_relations (dominant, dependant) 
        SELECT 
     		`value`, id
      	FROM (SELECT `value` from relationsv where `value` not in
        (select dominant from eb_objects_relations WHERE dependant = id )) as dominantvals;
-- applications table 
  UPDATE eb_objects2application eo2a
    SET 
        eo2a.eb_del = 'T', eo2a.removed_by = commit_uid , eo2a.removed_at = NOW()
    WHERE 
        eo2a.app_id IN(
       select * from( select eo2a1.app_id from eb_objects2application eo2a1 WHERE eo2a1.obj_id = objid AND eo2a1.eb_del='F' and eo2a1.app_id not in
        ( select `value` from apps))as b)
		AND eo2a.obj_id = objid;
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, objid
      	FROM (SELECT `value` from apps where `value` not in
      	(select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F')) as appvals;

  select id into out_refidv;
END