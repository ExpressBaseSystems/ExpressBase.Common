-- FUNCTION: public.eb_create_or_update_rbac_manageroles(integer, integer, integer, text, text, boolean, text, text, text)

-- DROP FUNCTION public.eb_create_or_update_rbac_manageroles(integer, integer, integer, text, text, boolean, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_rbac_manageroles(
	roleid integer,
	applicationid integer,
	userid integer,
	role_name text,
	description text,
	isanonym boolean,
	users text,
	dependantroles text,
	permissions text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    
AS $BODY$

DECLARE rid INTEGER;
_users INTEGER[];
_dependantroles INTEGER[];
_permissions TEXT[];
BEGIN
rid := roleid;
_users := string_to_array(users, ',')::integer[];
_dependantroles := string_to_array(dependantroles, ',')::integer[];
_permissions := string_to_array(permissions, ',');
   IF permissions IS NOT NULL THEN
      IF roleid > 0 THEN 
      	SELECT * FROM eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, _permissions, roleid) INTO rid;
      ELSE
        SELECT * FROM eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, _permissions, 0) INTO rid;
      END IF;
    END IF;
	IF isanonym THEN
		_users := '{1}';
		dependantroles := '{}';
	END IF;
    IF _users IS NOT NULL OR roleid > 0 THEN
    	PERFORM  eb_create_or_update_role2user(rid, userid, _users);
    END IF;
    IF _dependantroles IS NOT NULL OR roleid > 0 THEN
       PERFORM  eb_create_or_update_role2role(rid, userid, _dependantroles);
    END IF;    
RETURN 0;

END;

$BODY$;

ALTER FUNCTION public.eb_create_or_update_rbac_manageroles(integer, integer, integer, text, text, boolean, text, text, text)
    OWNER TO postgres;

