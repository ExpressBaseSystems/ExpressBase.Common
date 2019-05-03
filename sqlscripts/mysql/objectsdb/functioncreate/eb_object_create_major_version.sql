CREATE PROCEDURE eb_object_create_major_version(in id text,
    in obj_type integer,
    in commit_uid integer,
    in src_pid text,
    in cur_pid text,
    in relations text,
    out committed_refidunique1 text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE committed_refidunique text;
DECLARE major integer;
DECLARE version_number text;

drop temporary table if exists temp_array_table;
drop temporary table if exists relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
    CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;
    
SELECT eb_objects_id into objid FROM eb_objects_ver WHERE refid = id;
SELECT MAX(major_ver_num) into major from eb_objects_ver WHERE eb_objects_id = objid;

INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json)
	SELECT
		eb_objects_id,obj_json
	FROM 
		eb_objects_ver
	WHERE
		refid=id;
   select last_insert_id() from eb_objects_ver INTO inserted_obj_ver_id;
set version_number = CONCAT_WS('.', major+1, 0, 0, 'w');

UPDATE eb_objects_ver eov
		SET
		eov.commit_ts = NOW(), eov.commit_uid = commit_uid, eov.version_num = version_number, eov.working_mode = 'T', eov.major_ver_num = major+1, eov.minor_ver_num = 0, eov.patch_ver_num = 0
	WHERE
			eov.id = inserted_obj_ver_id ;
set refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_type, objid, inserted_obj_ver_id, objid, inserted_obj_ver_id);  
set committed_refidunique = refidunique;            

UPDATE eb_objects_ver eov SET eov.refid = refidunique WHERE eov.id = inserted_obj_ver_id;

INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uid, NOW());

UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by= commit_uid , removed_at=NOW()
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