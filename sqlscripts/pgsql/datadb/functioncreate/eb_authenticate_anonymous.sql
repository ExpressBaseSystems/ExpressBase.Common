CREATE OR REPLACE FUNCTION public.eb_authenticate_anonymous(
	in_socialid text DEFAULT NULL::text,
	in_fullname text DEFAULT NULL::text,
	in_emailid text DEFAULT NULL::text,
	in_phone text DEFAULT NULL::text,
	in_user_ip text DEFAULT NULL::text,
	in_user_browser text DEFAULT NULL::text,
	in_city text DEFAULT NULL::text,
	in_region text DEFAULT NULL::text,
	in_country text DEFAULT NULL::text,
	in_latitude text DEFAULT NULL::text,
	in_longitude text DEFAULT NULL::text,
	in_timezone text DEFAULT NULL::text,
	in_iplocationjson text DEFAULT NULL::text,
	in_appid integer DEFAULT NULL::integer,
	in_wc text DEFAULT NULL::text)
    RETURNS TABLE(out_userid integer, out_status_id integer, out_email text, out_fullname text, out_roles_a text, out_rolename_a text, out_permissions text, out_preferencesjson text, out_constraints_a text, out_signin_id integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE out_userid INTEGER;
DECLARE out_status_id INTEGER;
DECLARE out_email TEXT;
DECLARE out_fullname TEXT;
DECLARE out_roles_a TEXT;
DECLARE out_rolename_a TEXT;
DECLARE out_permissions TEXT;
DECLARE out_preferencesjson TEXT;
DECLARE out_constraints_a TEXT;
DECLARE out_signin_id INTEGER;
DECLARE is_anon_auth_req BOOL;

BEGIN

is_anon_auth_req := FALSE;

IF in_socialid IS NOT NULL THEN

    SELECT _userid, _status_id, _email, _fullname, _roles_a, _rolename_a, _permissions, _preferencesjson, _constraints_a, _signin_id
    FROM eb_authenticate_unified(social => in_socialid, wc => in_wc, ipaddress => in_user_ip) 
    INTO out_userid, out_status_id, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson, out_constraints_a, out_signin_id;
    
    IF out_userid = 0 THEN
    
		SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A WHERE A.socialid = in_socialid AND appid = in_appid AND ebuserid = 1
        INTO out_userid, out_email, out_fullname;
           
IF out_userid IS NULL THEN
        INSERT INTO eb_usersanonymous (socialid, fullname, email, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson)
VALUES (in_socialid, in_fullname, in_emailid, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson)
RETURNING id INTO out_userid;
ELSE
UPDATE eb_usersanonymous SET lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE id = out_userid;
END IF;
      
        is_anon_auth_req := TRUE;
       
    END IF;

ELSE

IF in_emailid IS NOT NULL OR in_phone IS NOT NULL THEN
   
    SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A
        WHERE (A.email = in_emailid OR A.phoneno = in_phone) AND appid = in_appid INTO out_userid, out_email, out_fullname;
       
        IF out_userid IS NULL THEN
        INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson)
VALUES (in_emailid, in_phone, in_fullname, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson)
RETURNING id INTO out_userid;
        ELSE
        IF out_email IS NULL THEN
            UPDATE eb_usersanonymous SET email = in_emailid, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE phoneno = in_phone;
            ELSE
            UPDATE eb_usersanonymous SET phoneno = in_phone, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE email = in_emailid;
            END IF;
        END IF;
       
        is_anon_auth_req := TRUE;
       
    END IF;
   
END IF;

IF is_anon_auth_req THEN
	SELECT _userid, _email, _status_id, _fullname, _roles_a, _rolename_a, _permissions, _preferencesjson, _constraints_a, _signin_id
    FROM eb_authenticate_unified(uname => 'anonymous@anonym.com', password => '294de3557d9d00b3d2d8a1e6aab028cf', wc => in_wc, ipaddress => in_user_ip) 
    INTO out_userid, out_email, out_status_id, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson, out_constraints_a, out_signin_id;
END IF;

RETURN QUERY
    SELECT out_userid, out_status_id, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson, out_constraints_a, out_signin_id;

END;

$BODY$;