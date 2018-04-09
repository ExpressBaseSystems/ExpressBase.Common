
create or replace FUNCTION eb_authenticate_anonymous(	
	in_socialid VARCHAR2 DEFAULT NULL,
	in_fullname VARCHAR2 DEFAULT NULL,
	in_emailid VARCHAR2 DEFAULT NULL,
	in_phone VARCHAR2 DEFAULT NULL,
    in_user_ip VARCHAR2 DEFAULT NULL,
	in_user_browser VARCHAR2 DEFAULT NULL,
	in_city VARCHAR2 DEFAULT NULL,
	in_region VARCHAR2 DEFAULT NULL,
	in_country VARCHAR2 DEFAULT NULL,
	in_latitude VARCHAR2 DEFAULT NULL,
	in_longitude VARCHAR2 DEFAULT NULL,
	in_timezone VARCHAR2 DEFAULT NULL,
	in_iplocationjson VARCHAR2 DEFAULT NULL,
	in_appid NUMBER DEFAULT NULL,
	in_wc VARCHAR2 DEFAULT NULL)
    RETURN authenticate_res_tbl as authenticatereturn  authenticate_res_tbl;
    PRAGMA AUTONOMOUS_TRANSACTION;
      out_userid NUMBER;
      out_email VARCHAR(50);
      out_fullname VARCHAR(50);
      out_roles_a VARCHAR2(100);
      out_rolename_a VARCHAR2(100);
      out_permissions CLOB;
      is_anon_auth_req CHAR(1);
      out_preference CLOB;

    BEGIN
        is_anon_auth_req := 'F';

            IF in_socialid IS NOT NULL THEN  
                    BEGIN
                    SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson INTO out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions,out_preference FROM table(eb_authenticate_unified(social => in_socialid, wc => in_wc));         
                     EXCEPTION WHEN  NO_DATA_FOUND THEN 
                     out_userid := NULL;
                     out_email := NULL;
                     out_fullname := NULL;
                     out_roles_a := NULL;
                     out_rolename_a:= NULL;
                     out_permissions:= NULL;
                     out_preference := NULL;
                     END;

                     IF out_userid IS NULL THEN
                     BEGIN
                        SELECT A.id, A.email, A.fullname INTO out_userid, out_email, out_fullname FROM eb_usersanonymous A WHERE A.socialid = in_socialid AND appid = in_appid;
                    EXCEPTION WHEN  NO_DATA_FOUND THEN 
                     out_userid := NULL;
                     out_email := NULL;
                     out_fullname := NULL;
                    END;
                        IF out_userid IS NULL THEN
                            INSERT INTO eb_usersanonymous (socialid, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
                            VALUES (in_socialid, in_fullname, SYSTIMESTAMP, SYSTIMESTAMP, in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);    
                        ELSE
                            --UPDATE eb_usersanonymous SET lastvisit = SYSTIMESTAMP, totalvisits = totalvisits + 1 WHERE id = out_userid; 
                            UPDATE eb_usersanonymous SET lastvisit = SYSTIMESTAMP, totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE id = out_userid;        
                        END IF;
                        is_anon_auth_req := 'T';            
                    END IF; 
                 COMMIT;
              ELSE   
                   IF in_emailid IS NOT NULL OR in_phone IS NOT NULL THEN
                    BEGIN
                        SELECT A.id, A.email, A.fullname INTO out_userid, out_email, out_fullname FROM eb_usersanonymous A 
                            WHERE (A.email = in_emailid OR A.phoneno = in_phone) AND appid = in_appid;
                        EXCEPTION WHEN  NO_DATA_FOUND THEN 
                         out_userid := NULL;
                     out_email := NULL;
                     out_fullname := NULL;
                     END;
                        IF out_userid IS NULL THEN

                        INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson) 
			VALUES (in_emailid, in_phone, in_fullname, SYSTIMESTAMP, SYSTIMESTAMP, in_appid, in_user_ip, in_user_browser, in_city, in_region, in_country, in_latitude, in_longitude, in_timezone, in_iplocationjson);
                        ELSE
                            IF out_email IS NULL THEN
                            UPDATE eb_usersanonymous SET email = in_emailid, lastvisit = SYSTIMESTAMP, totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE phoneno = in_phone;
                                --UPDATE eb_usersanonymous SET email = in_emailid, lastvisit = SYSTIMESTAMP, totalvisits = totalvisits + 1 WHERE phoneno = in_phone;
                            ELSE

                            UPDATE eb_usersanonymous SET phoneno = in_phone, lastvisit = SYSTIMESTAMP, totalvisits = totalvisits + 1, ipaddress = in_user_ip, browser = in_user_browser, city = in_city, region = in_region, country = in_country, latitude = in_latitude, longitude = in_longitude, timezone = in_timezone, iplocationjson = in_iplocationjson WHERE email = in_emailid;  
                                --UPDATE eb_usersanonymous SET phoneno = in_phone, lastvisit = SYSTIMESTAMP, totalvisits = totalvisits + 1 WHERE email = in_emailid;
                            END IF;   
                         END IF;   
                    is_anon_auth_req := 'T';      
                END IF;
                COMMIT;
              END IF;

            IF is_anon_auth_req = 'T' THEN
                SELECT userid, email, fullname, roles_a, rolename_a, permissions, preferencesjson INTO out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preference
                FROM table(eb_authenticate_unified(uname => 'anonymous@anonym.com', passwrd => '294de3557d9d00b3d2d8a1e6aab028cf', wc => in_wc)); 

            END IF;

        SELECT authenticate_res_obj(out_userid, out_email, out_fullname, out_roles_a, out_rolename_a, out_permissions, out_preference) BULK COLLECT INTO authenticatereturn FROM dual;
        RETURN authenticatereturn;
    END;