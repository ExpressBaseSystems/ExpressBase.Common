-- FUNCTION: eb_create_or_update_rbac_roles(integer, integer, integer, text, text, text, text, text, text)

-- DROP FUNCTION eb_create_or_update_rbac_roles;

DELIMITER $$
CREATE FUNCTION eb_create_or_update_rbac_roles(
	roleid integer,
	applicationid integer,
	userid integer,
	role_name text,
	description text,
	isanonym text,
	users text,
	dependantroles text,
	permissions text)
    RETURNS integer
    DETERMINISTIC
    
BEGIN
	DECLARE rid integer;
	DECLARE tmp integer;
	SET rid := roleid;
    
	IF permissions IS NOT NULL THEN
	  IF roleid > 0 THEN 
		SELECT eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, permissions, roleid) INTO rid;
	  ELSE
		SELECT eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, permissions, 0) INTO rid;
	  END IF;
	END IF;
	IF isanonym = 'T' THEN
		SET users := 1;    
		SET dependantroles :='' ;        
	END IF;
	SELECT eb_create_or_update_role2user(rid, userid, users) INTO tmp;
	SELECT eb_create_or_update_role2role(rid, userid, dependantroles) INTO tmp;
RETURN 0;
END;