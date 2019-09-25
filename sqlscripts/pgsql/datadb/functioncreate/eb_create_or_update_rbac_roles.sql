-- FUNCTION: public.eb_create_or_update_rbac_roles(integer, integer, integer, text, text, text, text, text, text, text)

-- DROP FUNCTION public.eb_create_or_update_rbac_roles(integer, integer, integer, text, text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_rbac_roles(
	roleid integer,
	applicationid integer,
	userid integer,
	role_name text,
	description text,
	isanonym text,
	users text,
	dependantroles text,
	permissions text,
	locations text)
    RETURNS integer
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE rid INTEGER;
_users INTEGER[];
_dependantroles INTEGER[];
_permissions TEXT[];
_locations INTEGER[];
BEGIN
rid := roleid;
_users := string_to_array(users, ',')::integer[];
_dependantroles := string_to_array(dependantroles, ',')::integer[];
_permissions := string_to_array(permissions, ',');
_locations := string_to_array(locations, ',')::integer[];

SELECT * FROM eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, _permissions, roleid) INTO rid;
  
IF isanonym = 'T' THEN
	_users := '{1}';
	_dependantroles := '{}';
END IF;

PERFORM eb_create_or_update_role2user(rid, userid, _users);

PERFORM eb_create_or_update_role2role(rid, userid, _dependantroles);

PERFORM	eb_create_or_update_role2loc(rid, userid, _locations);
   
RETURN 0;
END;

$BODY$;


