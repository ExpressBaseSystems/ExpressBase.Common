-- FUNCTION: public.eb_authenticate_anonymous(text, text, text, text, integer, text)

-- DROP FUNCTION public.eb_authenticate_anonymous(text, text, text, text, integer, text);

CREATE OR REPLACE FUNCTION public.eb_authenticate_anonymous(
	_socialid text DEFAULT NULL::text,
	_fullname text DEFAULT NULL::text,
	_emailid text DEFAULT NULL::text,
	_phone text DEFAULT NULL::text,
	_appid integer DEFAULT NULL::integer,
	_wc text DEFAULT NULL::text)
    RETURNS TABLE(_userid integer, _email text, _firstname text, _roles_a text, _rolename_a text, _permissions text, _preferencesjson text) 
    LANGUAGE 'plpgsql'

  
AS $BODY$

DECLARE _userid INTEGER;
DECLARE _email TEXT;
DECLARE _firstname TEXT;
DECLARE _roles_a TEXT;
DECLARE _rolename_a TEXT;
DECLARE _permissions TEXT;
DECLARE _is_anon_auth_req BOOL;
DECLARE _preferencesjson TEXT;

BEGIN

_is_anon_auth_req := false;

IF _socialid IS NOT NULL THEN

    SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson
    FROM eb_authenticate_unified(social => _socialid, wc => _wc) 
    INTO _userid, _email, _firstname, _roles_a, _rolename_a, _permissions, _preferencesjson;
    
    IF _userid IS NULL THEN
    
		SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A WHERE A.socialid = _socialid AND appid = _appid
        INTO _userid, _email, _firstname;
            
		IF _userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (socialid, fullname, firstvisit, lastvisit, appid) VALUES (_socialid, _fullname, NOW(), NOW(), _appid);
		ELSE
			UPDATE eb_usersanonymous SET lastvisit = NOW(), totalvisits = totalvisits + 1 WHERE id = _userid;
		END IF;
       
        _is_anon_auth_req := TRUE;
        
    END IF;

ELSE

	IF _emailid IS NOT NULL OR _phone IS NOT NULL THEN
    
    	SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A 
        WHERE (A.email = _emailid OR A.phoneno = _phone) AND appid = _appid INTO _userid, _email, _firstname;
        
        IF _userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid) VALUES (_emailid, _phone, _fullname, NOW(), NOW(), _appid);
        ELSE
        	IF _email IS NULL THEN
            	UPDATE eb_usersanonymous SET email = _emailid, lastvisit = NOW(), totalvisits = totalvisits + 1 WHERE phoneno = _phone;
            ELSE
            	UPDATE eb_usersanonymous SET phoneno = _phone, lastvisit = NOW(), totalvisits = totalvisits + 1 WHERE email = _emailid;
            END IF;
        END IF;
        
        _is_anon_auth_req := TRUE;
        
    END IF;
    
END IF;

IF _is_anon_auth_req THEN
	SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson
    FROM eb_authenticate_unified(uname => 'anonymous@anonym.com', password => '294de3557d9d00b3d2d8a1e6aab028cf', wc => _wc) 
    INTO _userid, _email, _firstname, _roles_a, _rolename_a, _permissions, _preferencesjson;
END IF;

RETURN QUERY
    SELECT _userid, _email, _firstname, _roles_a, _rolename_a, _permissions, _preferencesjson;

END;

$BODY$;

ALTER FUNCTION public.eb_authenticate_anonymous(text, text, text, text, integer, text)
    OWNER TO postgres;

