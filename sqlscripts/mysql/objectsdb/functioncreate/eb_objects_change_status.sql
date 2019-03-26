CREATE DEFINER=`josevin`@`%` FUNCTION `eb_objects_change_status`(idv text,
    statusv integer,
    commit_uid integer,
    changelogv text) RETURNS int(11)
BEGIN
DECLARE inserted_obj_ver_id integer;

INSERT INTO
	eb_objects_status(eb_obj_ver_id)
SELECT
	id
FROM
	eb_objects_ver
WHERE
	refid=idv;
select last_insert_id() INTO inserted_obj_ver_id;

UPDATE
	eb_objects_status 
SET
	status = statusv, uid = commit_uid, ts = NOW(), changelog = changelogv
WHERE
	id = inserted_obj_ver_id;
RETURN 0;
END