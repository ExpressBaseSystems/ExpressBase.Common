﻿DROP PROCEDURE IF EXISTS eb_authenticate_anonymous;

CREATE PROCEDURE eb_authenticate_anonymous(IN in_socialid TEXT,
    IN in_fullname TEXT,
    IN in_emailid TEXT,
    IN in_phone TEXT,
    IN in_user_ip TEXT,
    IN in_user_browser TEXT,
    IN in_city TEXT,
    IN in_region TEXT,
    IN in_country TEXT,
    IN in_latitude TEXT,
    IN in_longitude TEXT,
    IN in_timezone TEXT ,
    IN in_iplocationjson TEXT,
    IN in_appid INTEGER,
    IN in_wc TEXT,
    OUT out_userid INTEGER,
    OUT out_status_id INTEGER,
    OUT out_email TEXT,
    OUT out_fullname TEXT,
    OUT out_roles_a TEXT,
    OUT out_rolename_a TEXT,
    OUT out_permissions TEXT,
    OUT out_preferencesjson TEXT,
    OUT out_constraints_a TEXT,
    OUT out_signin_id INTEGER,
    OUT out_usergroup_a TEXT, 
    OUT out_public_ids TEXT, 
    OUT out_user_type INTEGER
    )
BEGIN
DECLARE tmp_userid INTEGER;
DECLARE tmp_status_id INTEGER;
DECLARE tmp_email TEXT;
DECLARE tmp_fullname TEXT;
DECLARE tmp_roles_a TEXT;
DECLARE tmp_rolename_a TEXT;
DECLARE tmp_permissions TEXT;
DECLARE tmp_preferencesjson TEXT;
DECLARE tmp_constraints_a TEXT;
DECLARE tmp_signin_id INTEGER;
DECLARE is_anon_auth_req BOOL;
DECLARE tmp_usergroup_a TEXT;
DECLARE tmp_public_ids TEXT;
DECLARE tmp_user_type TEXT;

IF in_socialid = '' THEN SET in_socialid = NULL; END IF;
IF in_fullname = '' THEN SET in_fullname = NULL; END IF;
IF in_emailid = '' THEN SET in_emailid = NULL; END IF;
IF in_phone = '' THEN SET in_phone = NULL; END IF; 
IF in_user_ip = '' THEN SET in_user_ip = NULL; END IF;
IF in_user_browser = '' THEN SET in_user_browser = NULL; END IF;
IF in_city = '' THEN SET in_city = NULL; END IF;
IF in_region = '' THEN SET in_region = NULL; END IF; 
IF in_country = '' THEN SET in_country = NULL; END IF;
IF in_latitude = '' THEN SET in_latitude = NULL; END IF;
IF in_longitude = '' THEN SET in_longitude = NULL; END IF;
IF in_timezone = '' THEN SET in_timezone = NULL; END IF;
IF in_iplocationjson = '' THEN SET in_iplocationjson = NULL; END IF; 
IF in_appid = '' THEN SET in_appid = NULL; END IF;
IF in_wc = '' THEN SET in_wc = NULL; END IF;
    
SET is_anon_auth_req = FALSE;

IF in_socialid IS NOT NULL THEN
	CALL eb_authenticate_unified('', '', in_socialid, in_wc, in_user_ip, '', @out_userid, @out_status_id, @out_email, @out_fullname, @out_roles_a, @out_rolename_a, @out_permissions, @out_preferencesjson, @out_constraints_a, @out_signin_id, @out_usergroup_a, @out_public_ids, @out_user_type); 
	SELECT 
			@out_userid, @out_status_id, @out_email, @out_fullname, @out_roles_a, @out_rolename_a, @out_permissions, @out_preferencesjson, @out_constraints_a, @out_signin_id, @out_usergroup_a, @out_public_ids, @out_user_type
		INTO 
			tmp_userid, tmp_status_id, tmp_email, tmp_fullname, tmp_roles_a, tmp_rolename_a, tmp_permissions, tmp_preferencesjson, tmp_constraints_a, tmp_signin_id, tmp_usergroup_a, tmp_public_ids, tmp_user_type;
    
    IF tmp_userid IS NULL OR tmp_userid = 0  THEN    
		SELECT 
				A.id, A.email, A.fullname 
			FROM 
				eb_usersanonymous A 
			WHERE 
				A.socialid = in_socialid AND appid = in_appid AND ebuserid = 1
			INTO tmp_userid, tmp_email, tmp_fullname;
           
		IF tmp_userid IS NULL THEN
			INSERT INTO 
					eb_usersanonymous (socialid, fullname, email, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson)
				VALUES 
					(in_socialid, in_fullname, in_emailid, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
				SELECT LAST_INSERT_ID() INTO tmp_userid;
		ELSE
			UPDATE 
					eb_usersanonymous 
				SET 
					lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson 
				WHERE id = tmp_userid;
		END IF;
      
        SET is_anon_auth_req = TRUE;
       
    END IF;

ELSE

	IF in_emailid IS NOT NULL OR in_phone IS NOT NULL THEN   
		SELECT 
				A.id, A.email, A.fullname 
			FROM 
				eb_usersanonymous A
			WHERE 
				(A.email = in_emailid OR A.phoneno = in_phone) AND A.appid = in_appid 
			INTO tmp_userid, tmp_email, tmp_fullname;
       
        IF tmp_userid IS NULL THEN
			INSERT INTO 
					eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson)
				VALUES 
					(in_emailid, in_phone, in_fullname, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
				SELECT LAST_INSERT_ID() INTO tmp_userid;
        ELSE
			IF tmp_email IS NULL THEN
				UPDATE 
						eb_usersanonymous 
					SET 
						email = in_emailid, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson 
					WHERE 
						phoneno = in_phone;
            ELSE
				UPDATE 
						eb_usersanonymous 
					SET 
						phoneno = in_phone, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson 
				WHERE 
					email = in_emailid;
            END IF;
        END IF;
       
       SET is_anon_auth_req = TRUE;
       
    END IF;
   
END IF;

IF is_anon_auth_req THEN
	
	CALL eb_authenticate_unified('anonymous@anonym.com', '294de3557d9d00b3d2d8a1e6aab028cf', '', in_wc, in_user_ip, '', @out_userid, @out_status_id, @out_email, @out_fullname, @out_roles_a, @out_rolename_a, @out_permissions, @out_preferencesjson, @out_constraints_a, @out_signin_id, @out_usergroup_a, @out_public_ids, @out_user_type);
    SELECT 
			@out_userid, @out_status_id, @out_email, @out_fullname, @out_roles_a, @out_rolename_a, @out_permissions, @out_preferencesjson, @out_constraints_a, @out_signin_id, @out_usergroup_a, @out_public_ids, @out_user_type  
    INTO 
		tmp_userid ,tmp_status_id, tmp_email, tmp_fullname, tmp_roles_a, tmp_rolename_a, tmp_permissions, tmp_preferencesjson, tmp_constraints_a, tmp_signin_id, tmp_usergroup_a, tmp_public_ids, tmp_user_type;
END IF;

SELECT 
		tmp_userid, tmp_status_id, tmp_email, tmp_fullname, tmp_roles_a, tmp_rolename_a, tmp_permissions, tmp_preferencesjson, tmp_constraints_a, tmp_signin_id, tmp_usergroup_a, tmp_public_ids, tmp_user_type
	INTO 
        out_userid, out_status_id, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson, out_constraints_a, out_signin_id, out_usergroup_a, out_public_ids, out_user_type; 
END