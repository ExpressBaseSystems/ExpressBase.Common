CREATE PROCEDURE eb_authenticate_unified(IN uname text,
    IN pwd text,
    IN social text,
    IN wc text,
    IN ipaddress text,
    out tmp_userid integer,
    out tmp_email text,
    out tmp_fullname text,
    out tmp_roles_a TEXT,
	out tmp_rolename_a TEXT,
	out tmp_permissions TEXT,
	out tmp_preferencesjson text,
	out tmp_constraintstatus TEXT
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

If uname ='' then set uname=null; end if;
If pwd ='' then set pwd=null; end if;
If social ='' then set social=null; end if;
If wc ='' then set wc=null; end if;
If ipaddress ='' then set ipaddress=null; end if;

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
    call eb_getroles(userid, wc,@roless,@role_names);
        SELECT @roless, @role_names INTO roles_a, rolename_a;

        call eb_getpermissions(roles_a,@out_permission);
		select @out_permission into permissions;
		SELECT eb_getconstraintstatus(userid, ipaddress)  INTO constraintstatus;
  
  SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson, constraintstatus 
         into tmp_userid, tmp_email, tmp_fullname, tmp_roles_a, tmp_rolename_a, tmp_permissions, tmp_preferencesjson, tmp_constraintstatus;
   	
    END IF;
END