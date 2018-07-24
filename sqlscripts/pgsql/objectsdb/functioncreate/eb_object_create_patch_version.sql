-- FUNCTION: public.eb_objects_create_patch_version(text, integer, integer, text, text, text)

-- DROP FUNCTION public.eb_objects_create_patch_version(text, integer, integer, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_object_create_patch_version(
	idv text,
	obj_typev integer,
	commit_uidv integer,
	src_pid text,
	cur_pid text,
	relationsstring text)
    RETURNS text
    LANGUAGE 'plpgsql'

    
AS $BODY$

DECLARE refidunique text; inserted_obj_ver_id integer; objid integer; committed_refidunique text; major integer;
minor integer; patch integer; version_number text; relationsv text[];

BEGIN
SELECT string_to_array(relationsstring,',')::text[] into relationsv;
SELECT eb_objects_id, major_ver_num, minor_ver_num, patch_ver_num into objid, major, minor, patch  FROM eb_objects_ver WHERE refid=idv;
	
INSERT INTO 
	eb_objects_ver (eb_objects_id, obj_json, major_ver_num, minor_ver_num)
SELECT
	eb_objects_id, obj_json, major_ver_num, minor_ver_num
FROM 
	eb_objects_ver
WHERE
	refid=idv
RETURNING id INTO inserted_obj_ver_id;

	version_number := CONCAT_WS('.', major, minor, patch + 1,'w');
	
UPDATE eb_objects_ver
	SET
	commit_ts = NOW(), Commit_uid = commit_uidv, version_num = version_number, working_mode = 'T', patch_ver_num = patch + 1
WHERE
		id = inserted_obj_ver_id ;

	refidunique := CONCAT_WS('-', src_pid, cur_pid, obj_typev, objid, inserted_obj_ver_id,objid, inserted_obj_ver_id);  
	committed_refidunique:=refidunique;

UPDATE eb_objects_ver SET refid = refidunique WHERE id = inserted_obj_ver_id;

INSERT INTO eb_objects_status(eb_obj_ver_id, status, uid, ts) VALUES(inserted_obj_ver_id, 0, commit_uidv, NOW());

UPDATE eb_objects_relations 
SET 
	eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
WHERE 
	dominant IN(
	SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidunique)) 
	EXCEPT 
	SELECT unnest(ARRAY[relationsv]));
		
INSERT INTO eb_objects_relations (dominant, dependant) 
	SELECT 
	  dominantvals, refidunique 
	FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
	EXCEPT 
	SELECT unnest(array(select dominant from eb_objects_relations 
							WHERE dependant = refidunique )))) as dominantvals;                            
RETURN committed_refidunique; 	

END;

$BODY$;

ALTER FUNCTION public.eb_object_create_patch_version(text, integer, integer, text, text, text)
    OWNER TO postgres;

