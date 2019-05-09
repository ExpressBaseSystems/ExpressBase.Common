CREATE PROCEDURE eb_object_create_patch_version(in id text,
    in obj_type integer,
    in commit_uid integer,
    in src_pid text,
    in cur_pid text,
    in relations text,
    out committed_refidunique text)
BEGIN
DECLARE refidunique text;
DECLARE inserted_obj_ver_id integer;
DECLARE objid integer;
DECLARE temp_committed_refidunique text;
DECLARE major integer;
DECLARE minor integer;
DECLARE patch integer;
DECLARE version_number text;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS relationsv;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL(relations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch  FROM eb_objects_ver WHERE refid=id;

INSERT INTO 
	eb_objects_ver (eb_objects_id, obj_json, major_ver_num, minor_ver_num)
SELECT
	eb_objects_id, obj_json, major_ver_num, minor_ver_num
FROM 
	eb_objects_ver
WHERE
	refid=id;
SELECT last_insert_id() INTO inserted_obj_ver_id;

SET version_number = CONCAT_WS('.', major, minor, patch + 1,'w');

UPDATE eb_objects_ver eov
	SET
	eov.commit_ts = NOW(), eov.Commit_uid = commit_uid, eov.version_num = version_number, eov.working_mode = 'T', eov.patch_ver_num = patch + 1
WHERE
		eov.id = inserted_obj_ver_id ;

SET refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_type, objid, inserted_obj_ver_id, objid, inserted_obj_ver_id);  
SET	temp_committed_refidunique=refidunique;
    
UPDATE eb_objects_ver eov SET eov.refid = refidunique WHERE eov.id = inserted_obj_ver_id;
 
INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uid, NOW());

UPDATE eb_objects_relations 
SET 
	eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
WHERE 
	dominant IN(SELECT * FROM(
	SELECT dominant FROM eb_objects_relations WHERE dependant = refidunique AND dominant NOT IN
	(SELECT `value` FROM relationsv ))as a);

INSERT INTO eb_objects_relations (dominant, dependant) 
	SELECT 
	  `value`, refidunique 
	FROM (SELECT `value` FROM relationsv where `value` NOT IN
	(SELECT dominant FROM eb_objects_relations 
							WHERE dependant = refidunique )) as dominantvals;     
SELECT temp_committed_refidunique INTO committed_refidunique;
END