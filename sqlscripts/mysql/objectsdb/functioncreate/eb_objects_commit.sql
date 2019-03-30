CREATE PROCEDURE eb_objects_commit(in idv text,
    in obj_namev text,
    in obj_descv text,
    in obj_typev integer,
    in obj_jsonv json,
    in obj_changelogv text,
    in commit_uidv integer,
    in relationsstring text,
    in tagsv text,
    in appsstring text,
    in disp_name text,
    out out_committed_refidunique text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE committed_refidunique text;
DECLARE major integer;
DECLARE minor integer;
DECLARE patch integer;
DECLARE version_number text;
-- DECLARE relationsv text[];
-- DECLARE apps integer[];

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

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch FROM eb_objects_ver WHERE refid=idv;

  	UPDATE eb_objects 
	SET 
    	obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv, display_name = disp_name
	WHERE 
    	id = objid; 
		
	UPDATE eb_objects_ver
	SET
    	obj_json = obj_jsonv, obj_changelog = obj_changelogv, commit_uid= commit_uidv, commit_ts = NOW()
	WHERE
    	-- eb_objects_id= objid AND major_ver_num=major AND working_mode='T' 
		refid = idv;
        select last_insert_id() INTO inserted_obj_ver_id;
    
    -- refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id);  
     set committed_refidunique=idv;
	-- UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;  

    
-- majorversion.minorversion.patchversion
	set version_number := CONCAT_WS('.', major, minor, patch);
   UPDATE eb_objects_ver SET version_num = version_number, working_mode = 'F' WHERE refid = idv;
   
-- relations table
	UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
      WHERE 
        dominant IN(select * from(
            select dominant from eb_objects_relations WHERE dependant = idv and dominant not in 
        (select `value` from relationsv))as a);
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      `value`, idv 
      FROM (SELECT `value` from relationsv where `value`
        not in 
      (select dominant from eb_objects_relations 
                            WHERE dependant = idv )) as dominantvals;  
-- application table  
UPDATE eb_objects2application 
    SET 
        eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
    WHERE 
        app_id IN(select * from (
       select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F' and app_id not in 
        ( select `value` from apps where id=1))as b)
		AND obj_id = objid;
            
        INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, objid
      	FROM (select `value` from apps where id=1 and `value` not in
        (select app_id from eb_objects2application WHERE obj_id = objid AND eb_del='F'))as appvals;
     
select committed_refidunique into out_committed_refidunique;
END