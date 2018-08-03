create or replace FUNCTION eb_create_or_update_rbac_roles(
	roleid NUMBER,
	applicationid NUMBER,
	userid NUMBER,
	role_name VARCHAR2,
	description CLOB,
	isanonym CHAR,
	users CLOB,
	dependantroles CLOB,
	permissions CLOB)
    RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
      rid NUMBER; 
      reslt NUMBER;
      in_users CLOB;
      in_dependantroles CLOB;
      in_permissions CLOB;

BEGIN  
  rid := roleid;
  in_users := users;
  in_dependantroles := dependantroles;
  in_permissions := permissions;

    rid := eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, in_permissions, roleid);

	IF isanonym = 'T' THEN
		in_users := '1';
		in_dependantroles := NULL;
	END IF;
    reslt :=  eb_create_or_update_role2user(rid, userid, in_users);
    reslt :=  eb_create_or_update_role2role(rid, userid, in_dependantroles);
    COMMIT;
RETURN 0;
END ;