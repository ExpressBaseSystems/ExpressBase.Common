DROP FUNCTION IF EXISTS eb_objects_change_status;

CREATE FUNCTION eb_objects_change_status(id TEXT,
    status INTEGER,
    commit_uid INTEGER,
    obj_changelog TEXT) RETURNS int(11)
	READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE inserted_obj_ver_id INTEGER;

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