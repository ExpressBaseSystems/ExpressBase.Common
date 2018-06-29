-- FUNCTION: public.eb_objects_change_status(text, integer, integer, text)

-- DROP FUNCTION IF EXISTS  eb_objects_change_status;
DELIMITER $$

CREATE FUNCTION eb_objects_change_status(
	idv text,
	statusv integer,
	commit_uid integer,
	changelogv text)
    RETURNS boolean
    DETERMINISTIC   
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
	SELECT last_insert_id() INTO inserted_obj_ver_id;

	UPDATE
		eb_objects_status 
	SET
		status = statusv, uid = commit_uid, ts = NOW(), changelog = changelogv
	WHERE
		id = inserted_obj_ver_id;
        RETURN true;
END$$