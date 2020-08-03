-- FUNCTION: public.eb_getuserobject(integer, text)

-- DROP FUNCTION public.eb_getuserobject(integer, text);

CREATE OR REPLACE FUNCTION public.eb_getuserobject(
	uid integer,
	wc text DEFAULT NULL::text)
    RETURNS TABLE(_userid integer, _status_id integer, _email text, _fullname text, _roles_a text, _rolename_a text, _permissions text, _preferencesjson text, _constraints_a text, _signin_id integer, _usergroup_a text, _public_ids text, _user_type integer, _phone text) 
    LANGUAGE 'plpgsql'

AS $BODY$ 

DECLARE _userid INTEGER;
DECLARE _status_id INTEGER;
DECLARE _email TEXT;
DECLARE _fullname TEXT;
DECLARE _roles_a TEXT;
DECLARE _rolename_a TEXT;
DECLARE _usergroup_a TEXT;
DECLARE _permissions TEXT;
DECLARE _preferencesjson TEXT;
DECLARE _constraints_a TEXT;
DECLARE _ug_ids INTEGER[];
DECLARE _role_ids INTEGER[];
DECLARE _signin_id INTEGER;
DECLARE _temp1 INTEGER;
DECLARE _public_ids TEXT;
DECLARE _user_type INTEGER;
DECLARE _phone TEXT;

BEGIN
	_signin_id := 0;
	SELECT 
		id, email, fullname, preferencesjson, eb_user_types_id, statusid, phnoprimary FROM eb_users 
	WHERE 
		id = uid
	INTO 
		_userid, _email, _fullname, _preferencesjson, _user_type, _status_id, _phone;
		
    SELECT roles, role_name FROM eb_getroles(_userid, wc) INTO _roles_a, _rolename_a;
	SELECT eb_getpermissions(string_to_array(_roles_a, ',')::int[]) INTO _permissions;
	
	_role_ids := STRING_TO_ARRAY(_roles_a, ',');
		SELECT ARRAY(SELECT groupid FROM eb_user2usergroup
		WHERE userid = _userid AND eb_del = 'F') INTO _ug_ids;
		_usergroup_a := ARRAY_TO_STRING(_ug_ids, ',');
			
	SELECT ARRAY_TO_STRING(
	(SELECT ARRAY(SELECT id FROM eb_objects WHERE is_public = 'T' AND COALESCE(eb_del,'F') ='F')
	), ',') into _public_ids;

	SELECT STRING_AGG(m.id || ';' || m.key_id || ';' || m.key_type || ';' || l.id || ';' || l.c_operation || ';' || l.c_type || ';' || l.c_value, '$')
	FROM eb_constraints_master m, eb_constraints_line l
	WHERE m.id = l.master_id AND eb_del = 'F' AND
	((key_type = 1 AND m.key_id = _userid) OR
	(key_type = 2 AND m.key_id IN (SELECT UNNEST(_ug_ids))) OR
	(key_type = 3 AND m.key_id IN (SELECT UNNEST(_role_ids)))) INTO _constraints_a; 
	IF _userid IS NULL THEN
		_userid := 0;
	END IF;
	IF _status_id IS NULL THEN
		_status_id := 0;
	END IF;
	
    RETURN QUERY SELECT _userid, _status_id, _email, _fullname, _roles_a, _rolename_a, _permissions, _preferencesjson, _constraints_a, _signin_id, _usergroup_a, _public_ids, _user_type, _phone;
END;

$BODY$;

