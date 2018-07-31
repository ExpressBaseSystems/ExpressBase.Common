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

	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value INTEGER);
        
	CALL STR_TO_TBL(users);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _users SELECT `value` FROM temp_array_table;
	
	CALL STR_TO_TBL(dependantroles);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _dependantroles SELECT `value` FROM temp_array_table;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);


	SET rid := roleid;
    
	IF permissions IS NOT NULL THEN
	  IF roleid > 0 THEN 
		SELECT eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, permissions, roleid) INTO rid;
	  ELSE
		SELECT eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, permissions, 0) INTO rid;
	  END IF;
	END IF;
	IF isanonym = 'T' THEN
		DELETE FROM _users;
        INSERT INTO _users VALUES(1);    
		DELETE FROM dependantroles;        
	END IF;
	IF _users IS NOT NULL OR roleid > 0 THEN
		SELECT eb_create_or_update_role2user(rid, userid, _users) INTO tmp;
	END IF;
	IF _dependantroles IS NOT NULL OR roleid > 0 THEN
	   SELECT eb_create_or_update_role2role(rid, userid, _dependantroles) INTO tmp;
	END IF;    
RETURN 0;
END;