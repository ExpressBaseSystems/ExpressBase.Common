-- FUNCTION: public.eb_authenticate_unified(text, text, text, text, text, text)

-- DROP FUNCTION public.eb_authenticate_unified(text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_authenticate_unified(
	uname text DEFAULT NULL::text,
	password text DEFAULT NULL::text,
	social text DEFAULT NULL::text,
	wc text DEFAULT NULL::text,
	ipaddress text DEFAULT NULL::text,
	deviceinfo text DEFAULT NULL::text)
    RETURNS TABLE(_userid integer, _status_id integer, _email text, _fullname text, _roles_a text, _rolename_a text, _permissions text, _preferencesjson text, _constraints_a text, _signin_id integer, _usergroup_a text, _public_ids text, _user_type integer, _phone text, _forcepwreset text) 
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
DECLARE _forcepwreset TEXT;

BEGIN
	_signin_id := 0;
	-- NORMAL
	IF uname IS NOT NULL AND password IS NOT NULL AND social IS NULL THEN
        SELECT id, email, fullname, preferencesjson, eb_user_types_id, statusid, phnoprimary, forcepwreset FROM eb_users 
		WHERE (email = uname OR phnoprimary = uname) AND (pwd = password OR pw = password) AND (statusid = 0 OR statusid = 4) INTO _userid, _email, _fullname, _preferencesjson, _user_type, _status_id, _phone, _forcepwreset;
		IF _userid IS NULL THEN			
			SELECT id, statusid FROM eb_users WHERE email = uname AND (pwd = password OR pw = password) INTO _userid, _status_id;
			IF _userid IS NULL THEN
				SELECT eb_users.id FROM eb_users WHERE eb_users.email = uname AND (statusid = 0 OR statusid = 4) INTO _userid;
				IF _userid > 0 THEN
					INSERT INTO eb_signin_log(user_id, ip_address, device_info, signin_at, is_attempt_failed)
					VALUES(_userid, ipaddress, deviceinfo, CURRENT_TIMESTAMP AT TIME ZONE 'UTC', 'T');				
					SELECT MAX(id) FROM eb_signin_log WHERE user_id = _userid AND is_attempt_failed = 'F' INTO _temp1;
					IF _temp1 IS NULL THEN
						SELECT COUNT(*) FROM eb_signin_log WHERE user_id = _userid AND is_attempt_failed = 'T' INTO _signin_id;
					ELSE
						SELECT COUNT(*) FROM eb_signin_log WHERE user_id = _userid AND is_attempt_failed = 'T' AND id > _temp1 INTO _signin_id;
					END IF;
				END IF;
			END IF;
			_userid := 0;
		END IF;
    END IF;
    -- SSO
    IF uname IS NOT NULL AND password IS NULL AND social IS NULL THEN
        SELECT id, email, fullname, preferencesjson, eb_user_types_id, statusid, phnoprimary, forcepwreset FROM eb_users 
		WHERE(email = uname OR phnoprimary = uname) AND (statusid = 0 OR statusid = 4) INTO _userid, _email, _fullname, _preferencesjson, _user_type, _status_id, _phone, _forcepwreset;
		IF _userid IS NULL THEN	
			SELECT statusid FROM eb_users WHERE email = uname INTO _status_id;
		END IF;
    END IF;
    -- SOCIAL
    IF uname IS NULL AND password IS NULL AND social IS NOT NULL THEN
        SELECT id, email, fullname, preferencesjson, eb_user_types_id, statusid, phnoprimary, _forcepwreset FROM eb_users 
		WHERE fbid = social AND (statusid = 0 OR statusid = 4) INTO _userid, _email, _fullname, _preferencesjson, _user_type, _status_id, _phone, _forcepwreset;
		IF _userid IS NULL THEN	
			SELECT statusid FROM eb_users WHERE fbid = social INTO _status_id;
		END IF;
    END IF;

	IF _userid > 0 THEN
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

		INSERT INTO eb_signin_log(user_id, ip_address, device_info, signin_at)
		VALUES(_userid, ipaddress, deviceinfo, CURRENT_TIMESTAMP AT TIME ZONE 'UTC') RETURNING id INTO _signin_id;		
   	END IF;
													 
	IF _userid IS NULL THEN
		_userid := 0;
	END IF;
	IF _status_id IS NULL THEN
		_status_id := 0;
	END IF;
    RETURN QUERY SELECT _userid, _status_id, _email, _fullname, _roles_a, _rolename_a, _permissions, _preferencesjson, _constraints_a, _signin_id, _usergroup_a, _public_ids, _user_type, _phone, _forcepwreset;
END;

$BODY$; 
