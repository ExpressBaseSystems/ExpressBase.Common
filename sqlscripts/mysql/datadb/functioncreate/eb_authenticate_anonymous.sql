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
    OUT out_email TEXT,
    OUT out_fullname TEXT,
    OUT out_roles_a TEXT,
    OUT out_rolename_a TEXT,
    OUT out_permissions TEXT,
    OUT out_preferencesjson TEXT)
BEGIN
DECLARE temp_userid INTEGER;
DECLARE temp_email TEXT;
DECLARE temp_fullname TEXT;
DECLARE temp_roles_a TEXT;
DECLARE temp_rolename_a TEXT;
DECLARE temp_permissions TEXT;
DECLARE is_anon_auth_req BOOL;
DECLARE temp_preferencesjson TEXT;

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
  CALL eb_authenticate_unified('', '', in_socialid, in_wc, '', @tmp_userid, @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, tmp_constraintstatus);  
   SELECT @tmp_userid, @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraintstatus INTO temp_userid, temp_email, temp_fullname, temp_roles_a, temp_rolename_a, temp_permissions, temp_preferencesjson;    
    
    IF temp_userid IS NULL THEN    
		SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A WHERE A.socialid = in_socialid AND appid = in_appid AND ebuserid = 1
        INTO temp_userid, temp_email, temp_fullname;
            
		IF temp_userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (socialid, fullname, email, phoneno, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
				VALUES (in_socialid, in_fullname, in_emailid, in_phone, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
			SELECT LAST_INSERT_ID() INTO temp_userid;
		ELSE
			UPDATE eb_usersanonymous SET lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE id = temp_userid;
		END IF;       
        
        SET is_anon_auth_req = TRUE;        
    END IF;
ELSE
	IF in_emailid IS NOT NULL OR in_phone IS NOT NULL THEN
    
    	SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A 
        WHERE (A.email = in_emailid OR A.phoneno = in_phone) AND appid = in_appid INTO temp_userid, temp_email, temp_fullname;
        
        IF temp_userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
			VALUES (in_emailid, in_phone, in_fullname, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
			SELECT LAST_INSERT_ID() INTO temp_userid;
        ELSE
        	IF temp_email IS NULL THEN
            	UPDATE eb_usersanonymous SET email = in_emailid, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE phoneno = in_phone;
            ELSE
            	UPDATE eb_usersanonymous SET phoneno = in_phone, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE email = in_emailid;
            END IF;
        END IF;
        
       SET is_anon_auth_req = TRUE;        
    END IF;    
END IF;

IF is_anon_auth_req THEN  
   call eb_authenticate_unified('anonymous@anonym.com', '294de3557d9d00b3d2d8a1e6aab028cf','', in_wc, '', @tmp_userid, @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson, @tmp_constraintstatus);
	SELECT @tmp_email, @tmp_fullname, @tmp_roles_a, @tmp_rolename_a, @tmp_permissions, @tmp_preferencesjson
       INTO temp_email, temp_fullname, temp_roles_a, temp_rolename_a, temp_permissions, temp_preferencesjson;
END IF;
        SELECT temp_userid, temp_email, temp_fullname, temp_roles_a, temp_rolename_a, temp_permissions, temp_preferencesjson INTO 
        out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson ; 
END