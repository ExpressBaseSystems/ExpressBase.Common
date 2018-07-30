-- FUNCTION AS PROCEDURE: eb_authenticate_anonymous(text, text, text, text, text, text, text, text, text, text, text, text, text, integer, text)

-- DROP PROCEDURE IF EXISTS eb_authenticate_anonymous;

DELIMITER $$
CREATE PROCEDURE eb_authenticate_anonymous(
	in_socialid text,
	in_fullname text,
	in_emailid text,
	in_phone text,
	in_user_ip text,
	in_user_browser text,
	in_city text,
	in_region text,
	in_country text,
	in_latitude text,
	in_longitude text,
	in_timezone text,
	in_iplocationjson text,
	in_appid integer,
	in_wc text)
BEGIN

	DECLARE out_userid INTEGER;
	DECLARE out_email TEXT;
	DECLARE out_fullname TEXT;
	DECLARE out_roles_a TEXT;
	DECLARE out_rolename_a TEXT;
	DECLARE out_permissions TEXT;
	DECLARE is_anon_auth_req BOOL;
	DECLARE out_preferencesjson TEXT;
    
	IF in_socialid 			= '' THEN SET in_socialid 		= NULL; END IF;
	IF in_fullname 			= '' THEN SET in_fullname 		= NULL; END IF;
	IF in_emailid 			= '' THEN SET in_emailid 		= NULL; END IF;
	IF in_phone 			= '' THEN SET in_phone 			= NULL; END IF;
	IF in_user_ip 			= '' THEN SET in_user_ip 		= NULL; END IF;
	IF in_user_browser 		= '' THEN SET in_user_browser 	= NULL; END IF;
	IF in_city 				= '' THEN SET in_city 			= NULL; END IF;
	IF in_region 			= '' THEN SET in_region 		= NULL; END IF;
	IF in_country 			= '' THEN SET in_country 		= NULL; END IF;  
	IF in_latitude 			= '' THEN SET in_latitude 		= NULL; END IF;  
	IF in_longitude 		= '' THEN SET in_longitude 		= NULL; END IF;
	IF in_timezone 			= '' THEN SET in_timezone 		= NULL; END IF;
	IF in_iplocationjson 	= '' THEN SET in_iplocationjson = NULL; END IF;  
	IF in_appid 			= '' THEN SET in_appid 			= NULL; END IF;
	IF in_wc 				= '' THEN SET in_wc 			= NULL; END IF;
    
	SET is_anon_auth_req := FALSE;

	IF in_socialid IS NOT NULL THEN

		CALL eb_authenticate_unified('', '', social, in_wc); -- populates eb_authenticate_unified_tmp from eb_authenticate_unified

		SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson
		FROM eb_authenticate_unified_tmp
		INTO out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson;
		
		IF out_userid IS NULL THEN
		
			SELECT A.id, A.email, A.fullname 
            FROM eb_usersanonymous A 
            WHERE A.socialid = in_socialid AND appid = in_appid AND ebuserid = 1
			INTO out_userid, out_email, out_fullname;
				
			IF out_userid IS NULL THEN
				INSERT INTO eb_usersanonymous (socialid, fullname, email, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
				VALUES (in_socialid, in_fullname, in_emailid, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
			ELSE
				UPDATE eb_usersanonymous SET lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE id = out_userid;
			END IF;
		   
			SET is_anon_auth_req := TRUE;
			
		END IF;

	ELSE

		IF in_emailid IS NOT NULL OR in_phone IS NOT NULL THEN
		
			SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A 
			WHERE (A.email = in_emailid OR A.phoneno = in_phone) AND appid = in_appid INTO out_userid, out_email, out_fullname;
			
			IF out_userid IS NULL THEN
				INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
				VALUES (in_emailid, in_phone, in_fullname, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
			ELSE
				IF out_email IS NULL THEN
					UPDATE eb_usersanonymous SET email = in_emailid, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE phoneno = in_phone;
				ELSE
					UPDATE eb_usersanonymous SET phoneno = in_phone, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE email = in_emailid;
				END IF;
			END IF;
			
			SET is_anon_auth_req := TRUE;
			
		END IF;
		
	END IF;

	IF is_anon_auth_req THEN
		DROP TABLE IF EXISTS eb_authenticate_unified_tmp;
		CALL eb_authenticate_unified('anonymous@anonym.com', '294de3557d9d00b3d2d8a1e6aab028cf', '', ''); -- populates eb_authenticate_unified_tmp from eb_authenticate_unified
        
		SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson
		FROM eb_authenticate_unified_tmp 
		INTO out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson;
	END IF;

	SELECT out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson;
END;
