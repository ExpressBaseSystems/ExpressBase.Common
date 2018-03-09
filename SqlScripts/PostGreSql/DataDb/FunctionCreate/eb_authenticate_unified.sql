-- FUNCTION: public.eb_authenticate_unified(text, text, text, text)

-- DROP FUNCTION public.eb_authenticate_unified(text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_authenticate_unified(
	uname text DEFAULT NULL::text,
	password text DEFAULT NULL::text,
	social text DEFAULT NULL::text,
	wc text DEFAULT NULL::text)
    RETURNS TABLE(userid integer, email text, fullname text, roles_a text, rolename_a text, permissions text) 
    LANGUAGE 'plpgsql'

   
AS $BODY$

DECLARE userid INTEGER;
DECLARE email TEXT;
DECLARE fullname TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE permissions TEXT;

BEGIN
	-- NORMAL
	IF uname IS NOT NULL AND password IS NOT NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname
        FROM eb_users WHERE eb_users.email = uname AND pwd = password INTO userid, email, fullname;
    END IF;
    -- SSO
    IF uname IS NOT NULL AND password IS NULL AND social IS NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname
        FROM eb_users WHERE eb_users.email = uname INTO userid, email, fullname;
    END IF;
    -- SOCIAL
    IF uname IS NULL AND password IS NULL AND social IS NOT NULL THEN
        SELECT eb_users.id, eb_users.email, eb_users.fullname
        FROM eb_users WHERE eb_users.socialid = social INTO userid, email, fullname;
    END IF;

	IF userid > 0 THEN
        SELECT roles, role_name FROM eb_getroles(userid, wc) INTO roles_a, rolename_a;

        SELECT eb_getpermissions(string_to_array(roles_a, ',')::int[]) INTO permissions;

        RETURN QUERY SELECT userid, email, fullname, roles_a, rolename_a, permissions;
   	END IF;
END;

$BODY$;

ALTER FUNCTION public.eb_authenticate_unified(text, text, text, text)
    OWNER TO postgres;

