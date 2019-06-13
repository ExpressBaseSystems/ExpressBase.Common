CREATE PROCEDURE eb_authenticate_unified(IN uname TEXT,
    IN pwd TEXT,
    IN social TEXT,
    IN wc TEXT,
    IN ipaddress TEXT,
    OUT tmp_userid INTEGER,
    OUT tmp_email TEXT,
    OUT tmp_fullname TEXT,
    OUT tmp_roles_a TEXT,
    OUT tmp_rolename_a TEXT,
    OUT tmp_permissions TEXT,
    OUT tmp_preferencesjson TEXT,
    OUT tmp_constraintstatus TEXT
    )
BEGIN
DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE fullname TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;
DECLARE preferencesjson TEXT;
DECLARE constraintstatus TEXT;

IF uname = '' THEN SET uname = NULL; END IF;
IF pwd = '' THEN SET pwd = NULL; END IF;
IF social = '' THEN SET social = NULL; END IF;
IF wc = '' THEN SET wc = NULL; END IF;
IF ipaddress = '' THEN SET ipaddress = NULL; END IF;

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
    CALL eb_getroles(userid, wc,@roless,@role_names);
        SELECT @roless, @role_names INTO roles_a, rolename_a;

        CALL eb_getpermissions(roles_a,@out_permission);
		SELECT @out_permission INTO permissions;
		SELECT eb_getconstraintstatus(userid, ipaddress) INTO constraintstatus;
  
  SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson, constraintstatus 
         INTO tmp_userid, tmp_email, tmp_fullname, tmp_roles_a, tmp_rolename_a, tmp_permissions, tmp_preferencesjson, tmp_constraintstatus;
   	
    END IF;
END