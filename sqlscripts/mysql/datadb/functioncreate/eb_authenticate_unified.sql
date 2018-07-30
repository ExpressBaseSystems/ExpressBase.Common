-- FUNCTION: eb_authenticate_unified(text, text, text, text)

-- DROP PROCEDURE IF EXISTS eb_authenticate_unified;

DELIMITER $$
CREATE PROCEDURE eb_authenticate_unified(
	uname text ,
	pwd text,
	social text,
	wc text)
BEGIN
	DECLARE userid INTEGER;
	DECLARE email TEXT;
	DECLARE fullname TEXT;
	DECLARE roles_a TEXT;
	DECLARE rolename_a TEXT;
	DECLARE permissions TEXT;
	DECLARE preferencesjson TEXT;
    
	IF uname 	= '' THEN SET uname 	= NULL; END IF;
	IF pwd 		= '' THEN SET pwd 		= NULL; END IF;
	IF social 	= '' THEN SET social 	= NULL; END IF;
	IF wc 		= '' THEN SET wc 		= NULL; END IF;
	-- NORMAL
	IF uname IS NOT NULL AND pwd IS NOT NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson
        FROM eb_users WHERE eb_users.email = uname AND pwd = pwd AND statusid = 0 INTO userid, email, fullname, preferencesjson;
    END IF;
    -- SSO
    IF uname IS NOT NULL AND pwd IS NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson
        FROM eb_users WHERE eb_users.email = uname AND statusid = 0 INTO userid, email, fullname, preferencesjson;
    END IF;
    -- SOCIAL
    IF uname IS NULL AND pwd IS NULL AND social IS NOT NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson
        FROM eb_users WHERE eb_users.fbid = social AND statusid = 0 INTO userid, email, fullname, preferencesjson;
    END IF;

	IF userid > 0 THEN
		CALL eb_getroles(userid, wc);-- it will create eb_roles_tmp with values 
    
        SELECT roles, role_name FROM eb_roles_tmp INTO roles_a, rolename_a;

        SELECT eb_getpermissions(group_concat(roles_a)) INTO permissions;

        CREATE TEMPORARY TABLE IF NOT EXISTS eb_authenticate_unified  
			SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson;
   	END IF;
END;