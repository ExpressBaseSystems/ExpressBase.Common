CREATE PROCEDURE eb_create_or_update_rbac_roles(IN role_id INTEGER,
    IN applicationid INTEGER,
    IN createdby INTEGER,
    IN role_name TEXT,
    IN description TEXT,
    IN is_anonym TEXT,
    IN users TEXT,
    IN dependants TEXT,
    IN permission TEXT,
    IN locations TEXT,
    OUT out_r INTEGER)
BEGIN
DECLARE rid INTEGER;
DECLARE a INTEGER;
SET rid = role_id;

CALL eb_create_or_update_role(applicationid, role_name, description, is_anonym, createdby, permission, role_id,@out_rid);
 SELECT @out_rid INTO rid;

IF is_anonym = "T" THEN
	SET users = "1";
	SET dependants = "";
END IF;

 CALL eb_create_or_update_role2user(rid, createdby, users);

 CALL eb_create_or_update_role2role(rid, createdby, dependants);

 CALL eb_create_or_update_role2loc(rid, createdby, locations);

SET a = 0;
SELECT a INTO out_r;
END