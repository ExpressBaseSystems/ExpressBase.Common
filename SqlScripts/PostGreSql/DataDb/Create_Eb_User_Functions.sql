-- FUNCTION: public.eb_authenticateuser(text, text, text)

-- DROP FUNCTION public.eb_authenticateuser(text, text, text);

CREATE OR REPLACE FUNCTION public.eb_authenticateuser(
	uname text,
	passwrd text,
	_socialid text)
    RETURNS TABLE(userid integer, email text, firstname text, profileimage text, prolink text, roles_a text, rolename_a text, permissions text, loginattempts integer) 
    LANGUAGE 'plpgsql'
AS $BODY$

DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE firstname TEXT;
DECLARE profileimage TEXT;
DECLARE prolink TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;
DECLARE loginattempts INTEGER;
BEGIN
IF _socialid != '' THEN 
    SELECT 
    	eb_users.id, eb_users.email,eb_users.firstname,eb_users.profileimg,eb_users.prolink,eb_users.loginattempts  
	FROM eb_users 
    WHERE eb_users.socialid = _socialid INTO userid, email, firstname, profileimage, prolink, loginattempts;
ELSE
	SELECT 
    	eb_users.id, eb_users.email,eb_users.firstname,eb_users.profileimg,eb_users.prolink,eb_users.loginattempts  
	FROM eb_users 
    WHERE eb_users.email = uname AND pwd = passwrd INTO userid, email, firstname, profileimage, prolink, loginattempts;
END IF;
    SELECT roles, rolename FROM eb_getroles(userid) INTO roles_a, rolename_a;
    
    SELECT eb_getpermissions(string_to_array(roles_a, ',')::int[]) INTO permissions;
    
    IF userid > 0 THEN
    RETURN QUERY
    	SELECT userid, email, firstname,profileimage,prolink, roles_a, rolename_a, permissions, loginattempts;
   	END IF;

END;

$BODY$;

ALTER FUNCTION public.eb_authenticateuser(text, text, text)
    OWNER TO postgres;


-- FUNCTION: public.eb_create_or_update_rbac_manageroles(integer, integer, integer, text, text, integer[], integer[], text[])

-- DROP FUNCTION public.eb_create_or_update_rbac_manageroles(integer, integer, integer, text, text, integer[], integer[], text[]);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_rbac_manageroles(
	roleid integer,
	applicationid integer,
	userid integer,
	role_name text,
	description text,
	users integer[],
	dependantroles integer[],
	permissions text[])
    RETURNS integer
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE rid INTEGER;
BEGIN
rid := roleid;
   IF permissions != '{}' THEN
      IF roleid > 0 THEN 
      	SELECT * FROM eb_create_or_update_role(applicationid, role_name, description, userid, permissions, roleid) INTO rid;
      ELSE
        SELECT * FROM eb_create_or_update_role(applicationid, role_name, description, userid, permissions) INTO rid;
      END IF;
    END IF;
    IF users != '{}' THEN
    	PERFORM  eb_create_or_update_role2user(rid, userid, users);
    END IF;
   IF dependantroles != '{}' THEN
       PERFORM  eb_create_or_update_role2role(rid, userid, dependantroles);
    END IF;    
RETURN 0;

END;

$BODY$;

ALTER FUNCTION public.eb_create_or_update_rbac_manageroles(integer, integer, integer, text, text, integer[], integer[], text[])
    OWNER TO postgres;


-- FUNCTION: public.eb_create_or_update_role2role(integer, integer, integer[])

-- DROP FUNCTION public.eb_create_or_update_role2role(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role2role(
	roleid integer,
	userid integer,
	dependantroles integer[])
    RETURNS integer
    LANGUAGE 'plpgsql'
    
AS $BODY$

BEGIN

    UPDATE eb_role2role 
    SET 
        eb_del = TRUE,revokedat = NOW(),revokedby = $2 
    WHERE 
        role2_id IN(
            SELECT unnest(ARRAY(select role2_id from eb_role2role WHERE role1_id = $1 and eb_del = FALSE)) 
        except 
            SELECT unnest(ARRAY[$3]));

    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat) 
    SELECT 
        dependants, $1, $2, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[$3])
        except 
        SELECT unnest(array(select role2_id from eb_role2role WHERE role1_id = $1 and eb_del = FALSE)))) AS dependants;
RETURN 0;

END;

$BODY$;

ALTER FUNCTION public.eb_create_or_update_role2role(integer, integer, integer[])
    OWNER TO postgres;


-- FUNCTION: public.eb_create_or_update_role2user(integer, integer, integer[])

-- DROP FUNCTION public.eb_create_or_update_role2user(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role2user(
	roleid integer,
	userid integer,
	usersid integer[])
    RETURNS integer
    LANGUAGE 'plpgsql'
    
AS $BODY$

BEGIN
    UPDATE eb_role2user 
    SET 
        eb_del = TRUE,revokedat = NOW(),revokedby = $2 
    WHERE 
        user_id IN(
            SELECT unnest(ARRAY(select user_id from eb_role2user WHERE role_id = $1 and eb_del = FALSE)) 
        except 
            SELECT unnest(ARRAY[$3]));

    INSERT INTO eb_role2user 
        (user_id, role_id, createdby, createdat) 
    SELECT 
        users, $1, $2, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[$3])
        except 
        SELECT unnest(array(select user_id from eb_role2user WHERE role_id = $1 and eb_del = FALSE)))) AS users;
RETURN 0;

END;

$BODY$;

ALTER FUNCTION public.eb_create_or_update_role2user(integer, integer, integer[])
    OWNER TO postgres;


-- FUNCTION: public.eb_create_or_update_role(integer, text, text, integer, text[], integer)

-- DROP FUNCTION public.eb_create_or_update_role(integer, text, text, integer, text[], integer);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role(
	application_id integer,
	role_name text,
	role_desc text,
	userid integer,
	permissions text[],
	roleid integer DEFAULT 0)
    RETURNS integer
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE rid INTEGER; DECLARE errornum INTEGER;

BEGIN
errornum := 0;

    IF roleid = 0 THEN   
        INSERT INTO eb_roles (role_name,applicationid,description) VALUES ($2,$1,$3);
    ELSE
        UPDATE eb_roles SET role_name= $2, applicationid= $1, description = $3 WHERE id = roleid;
    END IF;

    IF roleid = 0 THEN
        SELECT CURRVAL('eb_roles_id_seq') INTO rid;
    ELSE
        rid := roleid;
    END IF;

    UPDATE eb_role2permission 
    SET 
        eb_del = TRUE,revokedat = NOW(),revokedby = $4 
    WHERE 
        permissionname IN(
            SELECT unnest(ARRAY(select permissionname from eb_role2permission WHERE role_id = $6 AND eb_del = FALSE)) 
        except 
            SELECT unnest(ARRAY[$5]));

    INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, obj_id, op_id) 
    SELECT 
        permissionname, rid, $4, NOW(), 
        split_part(permissionname,'_',2)::int,
        split_part(permissionname,'_',1)::int 
    FROM UNNEST(array(SELECT unnest(ARRAY[$5])
        except 
        SELECT unnest(array(select permissionname from eb_role2permission WHERE role_id = $6 AND eb_del = FALSE)))) AS permissionname;
RETURN rid;

EXCEPTION WHEN unique_violation THEN errornum := 23505;
RETURN errornum;

END;

$BODY$;

ALTER FUNCTION public.eb_create_or_update_role(integer, text, text, integer, text[], integer)
    OWNER TO postgres;


-- FUNCTION: public.eb_getpermissions(integer[])

-- DROP FUNCTION public.eb_getpermissions(integer[]);

CREATE OR REPLACE FUNCTION public.eb_getpermissions(
	roles integer[])
    RETURNS TABLE(permissions text) 
    LANGUAGE 'plpgsql'
    
AS $BODY$

BEGIN
	RETURN QUERY 
SELECT 
   array_to_string(array_agg(_per.permissionname), ',') 
FROM 
	eb_role2permission _per
WHERE role_id = ANY(roles);
END;

$BODY$;

ALTER FUNCTION public.eb_getpermissions(integer[])
    OWNER TO postgres;


-- FUNCTION: public.eb_getroles(integer)

-- DROP FUNCTION public.eb_getroles(integer);

CREATE OR REPLACE FUNCTION public.eb_getroles(
	userid integer)
    RETURNS TABLE(roles text, rolename text) 
    LANGUAGE 'plpgsql'
    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

BEGIN
	RETURN QUERY  
    SELECT 
    	array_to_string(array_agg(id), ','), 
        array_to_string(array_agg(role_name), ',') FROM 
    (SELECT 
    	id, role_name FROM eb_roles WHERE id>=100 AND id = ANY(
    SELECT role_id FROM eb_role2user WHERE user_id=userid
	UNION ALL
	(WITH RECURSIVE role2role AS 
	(
    	SELECT 
        	role2_id AS role_id
    	FROM 
        	eb_role2role
    	WHERE 
        	role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id=userid)
    	UNION ALL
    	SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id
	) SELECT * FROM role2role)
	ORDER BY 
		role_id)
	UNION
    SELECT role_id as id, CAST('SysRole' as text) as role_name FROM eb_role2user  
    where user_id=userid AND role_id<100 AND eb_del='false') as ROLES;

END;

$BODY$;

ALTER FUNCTION public.eb_getroles(integer)
    OWNER TO postgres;


-- FUNCTION: public.eb_authenticateuser1(text, text)

-- DROP FUNCTION public.eb_authenticateuser1(text, text);

CREATE OR REPLACE FUNCTION public.eb_authenticateuser1(
	uname text,
	passwrd text)
    RETURNS TABLE(userid integer, email text, firstname text, profileimage text, prolink text, roles_a text, rolename_a text, permissions text, loginattempts integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE firstname TEXT;
DECLARE profileimage TEXT;
DECLARE prolink TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;
DECLARE loginattempts INTEGER;
BEGIN

	SELECT eb_users.id, eb_users.email,eb_users.firstname,eb_users.profileimg,eb_users.prolink,eb_users.loginattempts  
		FROM eb_users WHERE eb_users.email = uname AND pwd = passwrd INTO userid, email, firstname, profileimage, prolink, loginattempts;

    SELECT roles, rolename FROM eb_getroles(userid) INTO roles_a, rolename_a;
    
    SELECT eb_getpermissions(string_to_array(roles_a, ',')::int[]) INTO permissions;
    
    IF userid > 0 THEN
    RETURN QUERY
    	SELECT userid, email, firstname,profileimage,prolink, roles_a, rolename_a, permissions, loginattempts;
   	END IF;

END;

$BODY$;

ALTER FUNCTION public.eb_authenticateuser1(text, text)
    OWNER TO postgres;

-- FUNCTION: public.eb_authenticateuser2(text)

-- DROP FUNCTION public.eb_authenticateuser2(text);

CREATE OR REPLACE FUNCTION public.eb_authenticateuser2(
	_socialid text)
    RETURNS TABLE(userid integer, email text, firstname text, profileimage text, prolink text, roles_a text, rolename_a text, permissions text, loginattempts integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE firstname TEXT;
DECLARE profileimage TEXT;
DECLARE prolink TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;
DECLARE loginattempts INTEGER;
BEGIN

    SELECT eb_users.id, eb_users.email,eb_users.firstname,eb_users.profileimg,eb_users.prolink,eb_users.loginattempts  
		FROM eb_users WHERE eb_users.socialid = _socialid INTO userid, email, firstname, profileimage, prolink, loginattempts;

    SELECT roles, rolename FROM eb_getroles(userid) INTO roles_a, rolename_a;
    
    SELECT eb_getpermissions(string_to_array(roles_a, ',')::int[]) INTO permissions;
    
    IF userid > 0 THEN
    RETURN QUERY
    	SELECT userid, email, firstname,profileimage,prolink, roles_a, rolename_a, permissions, loginattempts;
   	END IF;

END;

$BODY$;

ALTER FUNCTION public.eb_authenticateuser2(text)
    OWNER TO postgres;


