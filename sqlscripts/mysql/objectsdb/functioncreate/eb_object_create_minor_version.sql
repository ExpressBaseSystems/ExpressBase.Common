CREATE PROCEDURE eb_object_create_minor_version(in id text,
    in obj_type integer,
    in commit_uid integer,
    in src_pid text,
    in cur_pid text,
    in relations text,
    out committed_refidunique text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_objid integer;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE temp_committed_refidunique text; 
DECLARE minor integer;
DECLARE major integer;
DECLARE version_number text;

DROP TEMPORARY TABLE IF EXISTS relationsv;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
    CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;

SELECT eb_objects_id, major_ver_num INTO objid, major FROM eb_objects_ver WHERE refid=id;
SELECT MAX(minor_ver_num) into minor FROM eb_objects_ver WHERE eb_objects_id = objid AND major_ver_num = major;

INSERT INTO 
		eb_objects_ver (eb_objects_id, obj_json, major_ver_num)
	SELECT
		eb_objects_id,obj_json,major_ver_num
	FROM 
		eb_objects_ver
	WHERE
		refid=id;
SELECT last_insert_id() INTO inserted_obj_ver_id;
   
SET version_number = CONCAT_WS('.', major, minor+1, 0, 'w');   
   
UPDATE eb_objects_ver eov
	SET
		eov.commit_ts = NOW(), eov.commit_uid = commit_uid, eov.version_num = version_number, eov.working_mode = 'T', eov.minor_ver_num = minor+1, eov.patch_ver_num = 0
	WHERE
			eov.id = inserted_obj_ver_id ;

SET refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_type, objid, inserted_obj_ver_id, objid, inserted_obj_ver_id);  
SET temp_committed_refidunique=refidunique;            
     
UPDATE eb_objects_ver eov SET eov.refid = refidunique WHERE eov.id = inserted_obj_ver_id;

INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uid, NOW());     
 
 UPDATE eb_objects_relations 
      SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
      WHERE 
        dominant IN(select * from(
            select dominant from eb_objects_relations WHERE dependant = refidunique AND dominant NOT IN 
        (select `value` from relationsv))as a);
            
            INSERT INTO eb_objects_relations 
        (dominant, dependant) 
    SELECT 
      `value`, refidunique 
      FROM (SELECT `value` from relationsv where `value` not in
       (SELECT dominant FROM eb_objects_relations 
                            WHERE dependant = refidunique )) as dominantvals;                            
    SELECT temp_committed_refidunique INTO committed_refidunique; 	

END