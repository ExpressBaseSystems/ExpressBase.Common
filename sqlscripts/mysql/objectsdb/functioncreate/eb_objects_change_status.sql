CREATE FUNCTION eb_objects_change_status(id text,
    status integer,
    commit_uid integer,
    obj_changelog text) RETURNS int(11)
BEGIN
DECLARE inserted_obj_ver_id integer;

INSERT INTO
	eb_objects_status(eb_obj_ver_id)
SELECT
	eov.id
FROM
	eb_objects_ver eov
WHERE
	eov.refid=id;
select last_insert_id() INTO inserted_obj_ver_id;

UPDATE
	eb_objects_status eos
SET
	eos.status = status, eos.uid = commit_uid, eos.ts = NOW(), eos.changelog = obj_changelog
WHERE
	eos.id = inserted_obj_ver_id;
RETURN 0;
END