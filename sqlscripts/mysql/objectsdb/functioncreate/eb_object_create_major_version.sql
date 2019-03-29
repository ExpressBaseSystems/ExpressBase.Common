CREATE PROCEDURE eb_object_create_major_version(in idv text,
    in obj_typev integer,
    in commit_uidv integer,
    in src_pid text,
    in cur_pid text,
    in relationsstring text,
    out committed_refidunique1 text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE committed_refidunique text;
DECLARE major integer;
DECLARE version_number text;
-- DECLARE relationsv text[];

drop temporary table if exists temp_array_table;
drop temporary table if exists relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
    CALL STR_TO_TBL(relationsstring);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
    
SELECT eb_objects_id into objid FROM eb_objects_ver WHERE refid = idv;
SELECT MAX(major_ver_num) into major from eb_objects_ver WHERE eb_objects_id = objid;

INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json)
	SELECT
		eb_objects_id,obj_json
	FROM 
		eb_objects_ver
	WHERE
		refid=idv;
   select last_insert_id() INTO inserted_obj_ver_id;
set version_number = CONCAT_WS('.', major+1, 0, 0, 'w');

UPDATE eb_objects_ver
		SET
		commit_ts = NOW(), commit_uid = commit_uidv, version_num = version_number, working_mode = 'T', major_ver_num = major+1, minor_ver_num = 0, patch_ver_num = 0
	WHERE
			id = inserted_obj_ver_id ;
set refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id, objid, inserted_obj_ver_id);  
set committed_refidunique = refidunique;            

UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;

INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());

UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by= commit_uidv , removed_at=NOW()
      WHERE 
        dominant IN(
          select* from(  select dominant from eb_objects_relations WHERE dependant = refidunique and dominant not in 
        (select `value` from relationsv)) as a);
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      `value`, refidunique 
      FROM (SELECT `value` from relationsv where `value` not in(
       select dominant from eb_objects_relations 
                            WHERE dependant = refidunique )) as dominantvals;
                            
select committed_refidunique into committed_refidunique1;
END