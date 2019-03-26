CREATE DEFINER=`josevin`@`%` FUNCTION `eb_object_create_patch_version`(idv text,
    obj_typev integer,
    commit_uidv integer,
    src_pid text,
    cur_pid text,
    relationsstring text) RETURNS text CHARSET latin1
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

CREATE TEMPORARY table relationsv(id int auto_increment, value text);
insert into relationsv(value) values(relationsstring);

SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch  FROM eb_objects_ver WHERE refid=idv;

INSERT INTO 
	eb_objects_ver (eb_objects_id, obj_json, major_ver_num, minor_ver_num)
SELECT
	eb_objects_id, obj_json, major_ver_num, minor_ver_num
FROM 
	eb_objects_ver
WHERE
	refid=idv;
select last_insert_id() INTO inserted_obj_ver_id;

set version_number = CONCAT_WS('.', major, minor, patch + 1,'w');

UPDATE eb_objects_ver
	SET
	commit_ts = NOW(), Commit_uid = commit_uidv, version_num = version_number, working_mode = 'T', patch_ver_num = patch + 1
WHERE
		id = inserted_obj_ver_id ;

set refidunique = CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id, objid, inserted_obj_ver_id);  
set	committed_refidunique=refidunique;
    
UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;
 
INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());

UPDATE eb_objects_relations 
SET 
	eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
WHERE 
	dominant IN(
	select dominant from eb_objects_relations WHERE dependant = refidunique and dominant not in
	(select value from relationsv ));

INSERT INTO eb_objects_relations (dominant, dependant) 
	SELECT 
	  dominantvals, refidunique 
	FROM (select value from relationsv where dominant not in (
    select dominant from eb_objects_relations 
	WHERE dependant = refidunique )) as dominantvals;  
RETURN committed_refidunique;
END