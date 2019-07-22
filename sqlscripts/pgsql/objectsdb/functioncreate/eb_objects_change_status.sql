-- FUNCTION: public.eb_objects_change_status(text, integer, integer, text)

-- DROP FUNCTION public.eb_objects_change_status(text, integer, integer, text);

CREATE OR REPLACE FUNCTION public.eb_objects_change_status(
	idv text,
	statusv integer,
	commit_uid integer,
	changelogv text)
    RETURNS integer
    LANGUAGE 'plpgsql'
   
AS $BODY$

DECLARE inserted_obj_ver_id integer;
DECLARE ob_id integer;
DECLARE ck_status text;
DECLARE tmp integer;

BEGIN 

SELECT
		DISTINCT eb_objects_id
	FROM
		eb_objects_ver
	WHERE
		refid=idv INTO ob_id;
    
SELECT q.ver_id FROM( 
	SELECT 
			eos.eb_obj_ver_id as ver_id, eos.status as t_status 
	FROM 
    	eb_objects_status eos WHERE eos.id IN (
				SELECT MAX(eos1.id) AS id1 FROM eb_objects_status eos1 WHERE eos1.eb_obj_ver_id IN(
                    SELECT eov.id FROM eb_objects_ver eov WHERE COALESCE(eov.eb_del,'F')='T' AND eov.eb_objects_id = ob_id ) GROUP BY eos1.eb_obj_ver_id )
              )q WHERE t_status=3 INTO tmp;          
 
IF ( statusv::int = 3 AND tmp::int != 0) THEN  RETURN tmp;  END IF; 

  
INSERT INTO
	eb_objects_status(eb_obj_ver_id)
SELECT
	id
FROM
	eb_objects_ver
WHERE
	refid=idv
RETURNING id INTO inserted_obj_ver_id;

UPDATE
	eb_objects_status 
SET
	status = statusv, uid = commit_uid, ts = NOW(), changelog = changelogv
WHERE
	id = inserted_obj_ver_id;
RETURN 0;
END;

$BODY$;

ALTER FUNCTION public.eb_objects_change_status(text, integer, integer, text)
    OWNER TO postgres;

