DROP PROCEDURE IF EXISTS eb_object_create_patch_version;

CREATE PROCEDURE eb_object_create_patch_version(IN id TEXT,
    IN obj_type INTEGER,
    IN commit_uid INTEGER,
    IN src_pid TEXT,
    IN cur_pid TEXT,
    IN relations TEXT,
    out committed_refidunique TEXT)
BEGIN
DECLARE refidunique TEXT;
DECLARE inserted_obj_ver_id INTEGER;
DECLARE objid INTEGER;
DECLARE temp_committed_refidunique TEXT;
DECLARE major INTEGER;
DECLARE minor INTEGER;
DECLARE patch INTEGER;
DECLARE version_number TEXT;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS relationsv;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
CALL eb_str_to_tbl_util(relations,',');  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;

SELECT 
		eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num INTO objid, major, minor, patch  
	FROM 
		eb_objects_ver 
    WHERE 
		refid = id;

INSERT INTO 
	eb_objects_ver (eb_objects_id, obj_json, major_ver_num, minor_ver_num)
SELECT
	eb_objects_id, obj_json, major_ver_num, minor_ver_num
FROM 
	eb_objects_ver
WHERE
	refid = id;
SELECT LAST_INSERT_ID() INTO inserted_obj_ver_id;

SET version_number = CONCAT_WS('.', major, minor, patch + 1,'w');

UPDATE eb_objects_ver eov
SET
	eov.commit_ts = NOW(), eov.Commit_uid = commit_uid, eov.version_num = version_number, eov.working_mode = 'T', eov.patch_ver_num = patch + 1
WHERE
	eov.id = inserted_obj_ver_id;

SET refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_type, objid, inserted_obj_ver_id, objid, inserted_obj_ver_id);  
SET	temp_committed_refidunique = refidunique;
    
UPDATE eb_objects_ver eov SET eov.refid = refidunique WHERE eov.id = inserted_obj_ver_id;
 
INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uid, NOW());

UPDATE eb_objects_relations 
SET 
	eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
WHERE 
	dominant IN(SELECT * FROM(
	SELECT dominant FROM eb_objects_relations WHERE dependant = refidunique AND dominant NOT IN
	(SELECT `value` FROM relationsv ))AS a);

INSERT INTO eb_objects_relations (dominant, dependant) 
	SELECT 
	  `value`, refidunique 
	FROM (SELECT `value` FROM relationsv WHERE `value` NOT IN
	(SELECT dominant FROM eb_objects_relations 
							WHERE dependant = refidunique )) AS dominantvals;   
							
SELECT temp_committed_refidunique INTO committed_refidunique;

END