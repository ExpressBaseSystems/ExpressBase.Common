CREATE FUNCTION eb_objects_change_status(id TEXT,
    status INTEGER,
    commit_uid INTEGER,
    obj_changelog TEXT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE inserted_obj_ver_id INTEGER;
DECLARE ob_id integer;
DECLARE ck_status text;

SELECT
		DISTINCT eb_objects_id
	FROM
		eb_objects_ver
	WHERE
		refid=id INTO ob_id;

SELECT q.ver_id FROM( 
SELECT 
		eos.eb_obj_ver_id as ver_id, eos.status as t_status 
	FROM 
    	eb_objects_status eos WHERE eos.id IN (
				SELECT MAX(eos1.id) AS id1 FROM eb_objects_status eos1 WHERE eos1.eb_obj_ver_id IN(
                    SELECT eov.id FROM eb_objects_ver eov WHERE COALESCE(eov.eb_del,'F')='T' AND eov.eb_objects_id = ob_id ) GROUP BY eos1.eb_obj_ver_id )
                    ) AS q WHERE t_status=3 INTO @tmp;          
 
IF ( status = 3 AND @tmp != 0) THEN  RETURN @tmp;  END IF;            
           
INSERT INTO
	eb_objects_status(eb_obj_ver_id)
SELECT
	eov.id
FROM
	eb_objects_ver eov
WHERE
	eov.refid=id;
SELECT LAST_INSERT_ID() INTO inserted_obj_ver_id;

UPDATE
	eb_objects_status eos
SET
	eos.status = status, eos.uid = commit_uid, eos.ts = NOW(), eos.changelog = obj_changelog
WHERE
	eos.id = inserted_obj_ver_id;

RETURN 0;
END