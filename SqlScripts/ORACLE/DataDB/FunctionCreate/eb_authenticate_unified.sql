create or replace FUNCTION eb_authenticate_unified(
	uname VARCHAR2 DEFAULT NULL,
	passwrd VARCHAR2 DEFAULT NULL,
	social VARCHAR2 DEFAULT NULL,
	wc VARCHAR2 DEFAULT NULL)
    RETURN authenticate_res_tbl as authenticatereturn  authenticate_res_tbl;
      userid NUMBER;
      email VARCHAR(50);
      fullname VARCHAR(50);
      roles_a VARCHAR2(100);
      rolename_a VARCHAR2(100);
      permissions VARCHAR2(100);
      preference CLOB;

    BEGIN
    IF uname IS NOT NULL AND passwrd IS NOT NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson INTO userid, email, fullname, preference
        FROM eb_users WHERE eb_users.email = uname AND pwd = passwrd;
    END IF;
    IF uname IS NOT NULL AND passwrd IS NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson INTO userid, email, fullname, preference
        FROM eb_users WHERE eb_users.email = uname;
    END IF;
    IF uname IS NULL AND passwrd IS NULL AND social IS NOT NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson INTO userid, email, fullname, preference
        FROM eb_users WHERE EB_USERS.FBID = social;
    END IF;
	IF userid > 0 THEN
        dbms_output.put_line(roles_a);
        SELECT rid, rname INTO roles_a, rolename_a FROM table(eb_getroles(userid,wc)); 

        SELECT permissioname INTO permissions from table(eb_permissions(roles_a));

        SELECT authenticate_res_obj(userid, email, fullname, roles_a, rolename_a, permissions, preference) BULK COLLECT INTO authenticatereturn FROM dual;
        RETURN authenticatereturn;
   	END IF;
    END;