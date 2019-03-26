CREATE DEFINER=`josevin`@`%` FUNCTION `eb_objects_save1`(refidv text,
    obj_namev text,
    obj_descv text,
    obj_typev integer,
    obj_jsonv json,
    commit_uidv integer,
    relationsstring text,
    tagsv text,
    appsstring text,
    disp_name text) RETURNS text CHARSET latin1
BEGIN
DECLARE refidunique text;
DECLARE inserted_objid integer;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
declare lastupdatedId integer;
declare lastupdatedId1 integer;
-- DECLARE relationsv text[];
-- DECLARE apps integer[];

--  set @relationsv=string_to_array(relationsstring,',');
--  set @apps=array(appsstring,',');
-- SELECT string_to_array(relationsstring,',')::text[] into relationsv;
-- SELECT string_to_array(appsstring,',')::int[] into apps;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
	
	CALL STR_TO_TBL(appsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;

 SELECT eb_objects_id into objid FROM eb_objects_ver  WHERE refid=refidv;
set lastupdatedId=0;
 	UPDATE eb_objects SET obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv , display_name = disp_name 
    WHERE id = objid ;
    select last_insert_id() INTO inserted_objid;
    
set lastupdatedId1=0;
    UPDATE eb_objects_ver SET obj_json = obj_jsonv
    WHERE refid=refidv;
    select last_insert_id() into inserted_obj_ver_id;
    
 --   refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, inserted_objid, inserted_obj_ver_id);                                 
 -- 	UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;
    
    -- relations table
    
    drop temporary table if exists temp_dom;

    CREATE TEMPORARY TABLE temp_dom
		SELECT dominant from eb_objects_relations WHERE dependant = refidv
        AND dominant NOT IN (SELECT value FROM relationsv);
    
	UPDATE eb_objects_relations 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        dominant in(
       select `value` from temp_dom);
            
            
	INSERT INTO eb_objects_relations (dominant, dependant) 
        SELECT 
     		`value`, refidv
      	FROM (SELECT  value from relationsv where value not in
      	(SELECT  dominant from eb_objects_relations WHERE dependant = refidv) limit 1 ) as tbl1;

-- applications table 
    drop temporary table if exists temp_appid;

    CREATE TEMPORARY TABLE temp_appid
		SELECT appid from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F'
        AND appid NOT IN (SELECT value FROM apps);
        
        
  UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(
        select `value` from apps)
		AND obj_id = inserted_objid;
            
INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, inserted_objid
      	FROM (select value from apps
        where value not in( 
      	select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')
        limit 1)as tbl2 ;
-- drop temporary table if exists relationsv;
-- drop temporary table if exists apps;
-- drop table if exists temp_dom;
-- drop table if exists temp_appid;

  RETURN refidv;
END