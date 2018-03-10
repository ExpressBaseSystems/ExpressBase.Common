-- FUNCTION: public.eb_objects_create_patch_version(text, integer, integer, text, text, text)

-- DROP FUNCTION public.eb_objects_create_patch_version(text, integer, integer, text, text, text);

create or replace FUNCTION eb_objects_change_status(
	idv varchar,
	statusv NUMBER,
	commit_uid NUMBER,
	changelogv varchar) 
RETURN NUMBER
	IS
	PRAGMA AUTONOMOUS_TRANSACTION;
	inserted_obj_ver_id NUMBER;

BEGIN 

SELECT id INTO inserted_obj_ver_id FROM eb_objects_ver WHERE refid=idv;

INSERT INTO eb_objects_status(eb_obj_ver_id,status,userid,ts,changelog) VALUES (inserted_obj_ver_id,statusv,commit_uid,SYSTIMESTAMP,changelogv);
COMMIT;
RETURN 0;
END;