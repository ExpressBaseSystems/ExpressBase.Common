-- FUNCTION: public.eb_authenticate_unified(text, text, text, text)

-- DROP FUNCTION public.eb_authenticate_unified(text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_authenticate_unified(
	uname text DEFAULT NULL::text,
	password text DEFAULT NULL::text,
	social text DEFAULT NULL::text,
	wc text DEFAULT NULL::text)
    RETURNS TABLE(userid integer, email text, fullname text, roles_a text, rolename_a text, permissions text, preferencesjson text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE fullname TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;
DECLARE preferencesjson TEXT;

BEGIN
	-- NORMAL
	IF uname IS NOT NULL AND password IS NOT NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson
        FROM eb_users WHERE eb_users.email = uname AND pwd = password AND statusid = 0 INTO userid, email, fullname, preferencesjson;
    END IF;
    -- SSO
    IF uname IS NOT NULL AND password IS NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson
        FROM eb_users WHERE eb_users.email = uname AND statusid = 0 INTO userid, email, fullname, preferencesjson;
    END IF;
    -- SOCIAL
    IF uname IS NULL AND password IS NULL AND social IS NOT NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname, eb_users.preferencesjson
        FROM eb_users WHERE eb_users.fbid = social AND statusid = 0 INTO userid, email, fullname, preferencesjson;
    END IF;

	IF userid > 0 THEN
        SELECT roles, role_name FROM eb_getroles(userid, wc) INTO roles_a, rolename_a;

        SELECT eb_getpermissions(string_to_array(roles_a, ',')::int[]) INTO permissions;

        RETURN QUERY SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson;
   	END IF;
END;

$BODY$;

ALTER FUNCTION public.eb_authenticate_unified(text, text, text, text)
    OWNER TO postgres;

