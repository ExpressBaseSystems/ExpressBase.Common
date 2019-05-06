CREATE PROCEDURE eb_authenticate_anonymous(IN in_socialid text,
    IN in_fullname text ,
    IN in_emailid text ,
    IN in_phone text ,
    IN in_user_ip text,
    IN in_user_browser text ,
    IN in_city text ,
    IN in_region text,
    IN in_country text,
    IN in_latitude text,
    IN in_longitude text,
    IN in_timezone text ,
    IN in_iplocationjson text,
    IN in_appid integer,
    IN in_wc text,
    out out_userid1 integer,
    out out_email1 text,
    out out_fullname1 text,
    out out_roles_a1 text,
    out out_rolename_a1 text,
    out out_permissions1 text,
    out out_preferencesjson1 text)
BEGIN
DECLARE out_userid INTEGER;
DECLARE out_email TEXT;
DECLARE out_fullname TEXT;
DECLARE out_roles_a TEXT;
DECLARE out_rolename_a TEXT;
DECLARE out_permissions TEXT;
DECLARE is_anon_auth_req BOOL;
DECLARE out_preferencesjson TEXT;

If in_socialid ='' then set in_socialid=null; end if;
If in_fullname ='' then set in_fullname=null; end if; 
If in_emailid ='' then set in_emailid=null; end if; 
If in_phone ='' then set in_phone=null; end if; 
If in_user_ip ='' then set in_user_ip=null; end if; 
If in_user_browser ='' then set in_user_browser=null; end if; 
If in_city ='' then set in_city=null; end if; 
If in_region ='' then set in_region=null; end if; 
If in_country ='' then set in_country=null; end if; 
If in_latitude ='' then set in_latitude=null; end if; 
If in_longitude ='' then set in_longitude=null; end if; 
If in_timezone ='' then set in_timezone=null; end if; 
If in_iplocationjson ='' then set in_iplocationjson=null; end if; 
If in_appid ='' then set in_appid=null; end if; 
If in_wc ='' then set in_wc=null; end if; 
    
set is_anon_auth_req = FALSE;

IF in_socialid IS NOT NULL THEN
  CALL eb_authenticate_unified('', '',in_socialid,in_wc,'',@userid, @email, @fullname, @roles_a, @rolename_a, @permissions,@preferencesjson,@constraintstatus);
  
   select @userid, @email, @fullname, @roles_a, @rolename_a, @permissions,@preferencesjson,@constraintstatus INTO out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson;
    
    IF out_userid IS NULL THEN
    
		SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A WHERE A.socialid = in_socialid AND appid = in_appid AND ebuserid = 1
        INTO out_userid, out_email, out_fullname;
            
		IF out_userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (socialid, fullname, email, phoneno, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
			VALUES (in_socialid, in_fullname, in_emailid, in_phone, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
			select last_insert_id() from eb_usersanonymous INTO out_userid;
		ELSE
			UPDATE eb_usersanonymous SET lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE id = out_userid;
		END IF;
       
        set is_anon_auth_req = TRUE;
        
    END IF;

ELSE

	IF in_emailid IS NOT NULL OR in_phone IS NOT NULL THEN
    
    	SELECT A.id, A.email, A.fullname FROM eb_usersanonymous A 
        WHERE (A.email = in_emailid OR A.phoneno = in_phone) AND appid = in_appid INTO out_userid, out_email, out_fullname;
        
        IF out_userid IS NULL THEN
        	INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
			VALUES (in_emailid, in_phone, in_fullname, NOW(), NOW(), in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
			select last_insert_id() from eb_usersanonymous INTO out_userid;
        ELSE
        	IF out_email IS NULL THEN
            	UPDATE eb_usersanonymous SET email = in_emailid, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE phoneno = in_phone;
            ELSE
            	UPDATE eb_usersanonymous SET phoneno = in_phone, lastvisit = NOW(), totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE email = in_emailid;
            END IF;
        END IF;
        
       set is_anon_auth_req = TRUE;
        
    END IF;
    
END IF;

IF is_anon_auth_req THEN
  
   call eb_authenticate_unified('anonymous@anonym.com', '294de3557d9d00b3d2d8a1e6aab028cf','', in_wc,'',@userid, @email, @fullname, @roles_a, @rolename_a, @permissions,@preferencesjson,@constraintstatus);
	SELECT @email, @fullname, @roles_a, @rolename_a, @permissions,@preferencesjson
       INTO out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson;
END IF;
        SELECT out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preferencesjson into 
        out_userid1 ,out_email1, out_fullname1, out_roles_a1 ,out_rolename_a1 ,out_permissions1 ,out_preferencesjson1 ; 

END