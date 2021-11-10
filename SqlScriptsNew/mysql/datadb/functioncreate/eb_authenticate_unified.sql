DROP PROCEDURE IF EXISTS eb_authenticate_unified;

CREATE PROCEDURE eb_authenticate_unified(IN uname TEXT,
    IN pwd TEXT,
    IN social TEXT,
    IN wc TEXT,
    IN ipaddress TEXT,
    IN deviceinfo TEXT,
    OUT tmp_userid INTEGER,
    OUT tmp_status_id INTEGER,
    OUT tmp_email TEXT,
    OUT tmp_fullname TEXT,
    OUT tmp_roles_a TEXT,
    OUT tmp_rolename_a TEXT,
    OUT tmp_permissions TEXT,
    OUT tmp_preferencesjson TEXT,
    OUT tmp_constraints_a TEXT,
    OUT tmp_signin_id INTEGER,
    OUT tmp_usergroup_a TEXT, 
    OUT tmp_public_ids TEXT, 
    OUT tmp_user_type INTEGER
    )
BEGIN
DECLARE userid INTEGER;
DECLARE status_id INTEGER;
DECLARE email TEXT;
DECLARE fullname TEXT;
DECLARE roles_a TEXT;
DECLARE rolename_a TEXT;
DECLARE usergroup_a TEXT;
DECLARE permissions TEXT;
DECLARE preferencesjson TEXT;
DECLARE constraints_a TEXT;
DECLARE signin_id INTEGER;
DECLARE temp1 INTEGER;
DECLARE public_ids TEXT;
DECLARE user_type INTEGER;

IF uname = '' THEN SET uname = NULL; END IF;
IF pwd = '' THEN SET pwd = NULL; END IF;
IF social = '' THEN SET social = NULL; END IF;
IF wc = '' THEN SET wc = NULL; END IF;
IF ipaddress = '' THEN SET ipaddress = NULL; END IF;
IF deviceinfo = '' THEN SET deviceinfo = NULL; END IF;

SET signin_id = 0;
-- NORMAL
	IF uname IS NOT NULL AND pwd IS NOT NULL AND social IS NULL THEN
        SELECT 
				EU.id, EU.email, EU.fullname, EU.preferencesjson, EU.eb_user_types_id, EU.statusid
			FROM 
				eb_users EU
			WHERE 
				EU.email = uname AND EU.pwd = pwd AND (EU.statusid = 0 OR EU.statusid = 4)
			INTO userid, email, fullname, preferencesjson, user_type, status_id;
        IF userid IS NULL THEN			
			SELECT 
					ebu.id, ebu.statusid 
				FROM 
					eb_users ebu 
				WHERE 
					ebu.email = uname AND ebu.pwd = pwd 
				INTO userid, status_id;
            IF userid IS NULL THEN
				SELECT 
						EUS.id 
					FROM 
						eb_users EUS
					WHERE 
						EUS.email = uname AND (EUS.statusid = 0 OR EUS.statusid = 4)
					INTO userid;
                IF userid > 0 THEN
					INSERT INTO 
							eb_signin_log(user_id, ip_address, device_info, signin_at, is_attempt_failed)
					VALUES
							(userid, ipaddress, deviceinfo, utc_timestamp(), 'T');				
					SELECT 
							MAX(esl.id) 
						FROM 
							eb_signin_log esl 
						WHERE 
							esl.user_id = userid AND esl.is_attempt_failed = 'F' 
						INTO temp1;
                    IF temp1 IS NULL THEN
						SELECT 
								COUNT(*) 
							FROM 
								eb_signin_log 
							WHERE 
								user_id = userid AND is_attempt_failed = 'T' 
							INTO signin_id;
					ELSE
						SELECT 
								COUNT(*) 
							FROM 
								eb_signin_log 
							WHERE 
								user_id = userid AND is_attempt_failed = 'T' AND id > temp1 
							INTO signin_id;
					END IF;
                END IF;    
            END IF; 
            SET userid = 0;
        END IF;    
    END IF;
    
-- SSO
   IF uname IS NOT NULL AND pwd IS NULL AND social IS NULL THEN
        SELECT 
				EU.id, EU.email, EU.fullname, EU.preferencesjson, EU.eb_user_types_id, EU.statusid
			FROM 
				eb_users EU
			WHERE 
				EU.email = uname AND (EU.statusid = 0 OR EU.statusid = 4)
			INTO userid, email, fullname, preferencesjson, user_type, status_id;
        IF userid IS NULL THEN	
			SELECT statusid FROM eb_users WHERE email = uname INTO status_id;
		END IF;
    END IF;
    
 -- SOCIAL
    IF uname IS NULL AND pwd IS NULL AND social IS NOT NULL THEN
        SELECT 
				EU.id, EU.email, EU.fullname, EU.preferencesjson, EU.eb_user_types_id, EU.statusid
			FROM 
				eb_users EU 
			WHERE 
				EU.fbid = social AND (EU.statusid = 0 OR EU.statusid = 4)
			INTO userid, email, fullname, preferencesjson, user_type, status_id;
        IF userid IS NULL THEN	
			SELECT eus.statusid FROM eb_users eus WHERE eus.fbid = social INTO status_id;
		END IF;
    END IF;

IF userid > 0 THEN
    CALL eb_getroles(userid, wc,@roless,@role_names);
        SELECT @roless, @role_names INTO roles_a, rolename_a;
	if roles_a is null then set roles_a = ''; end if;
	CALL eb_getpermissions(roles_a,@out_permission);
		SELECT @out_permission INTO permissions;        
        
      DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_role_ids;
		CREATE TEMPORARY TABLE temp_array_table(value INTEGER);
		CALL eb_str_to_tbl_util(roles_a,',');  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_role_ids SELECT `value` FROM temp_array_table;
               
        DROP TEMPORARY TABLE IF EXISTS temp_ug_ids;
        CREATE TEMPORARY TABLE temp_ug_ids
			SELECT 
					eu2ug.groupid 
				FROM 
					eb_user2usergroup eu2ug
				WHERE 
					eu2ug.userid = userid AND eu2ug.eb_del = 'F';
                    
	SELECT GROUP_CONCAT(groupid) as groupid FROM temp_ug_ids INTO usergroup_a;
   
	SELECT GROUP_CONCAT(id) FROM eb_objects WHERE is_public = 'T' AND COALESCE(eb_del,'F') ='F' INTO public_ids;
        
		SELECT 
				GROUP_CONCAT(m.id || ';' || m.key_id || ';' || m.key_type || ';' || l.id || ';' || l.c_operation || ';' || l.c_type || ';' || l.c_value, '$')
			FROM 
				eb_constraints_master m, eb_constraints_line l
			WHERE 
				m.id = l.master_id AND eb_del = 'F' AND
				((key_type = 1 AND m.key_id = userid) OR
					(key_type = 2 AND m.key_id IN (SELECT groupid FROM temp_ug_ids))) OR
				(key_type = 3 AND m.key_id IN (SELECT `value` FROM temp_role_ids)) INTO constraints_a; 

		INSERT INTO eb_signin_log(user_id, ip_address, device_info, signin_at)
		VALUES(userid, ipaddress, deviceinfo, UTC_TIMESTAMP());
        SELECT LAST_INSERT_ID()  INTO signin_id;
	
END IF;
													 
IF userid IS NULL THEN
	SET userid = 0;
END IF;
IF status_id IS NULL THEN
	SET status_id = 0;
END IF;
  
SELECT userid, status_id, email, fullname, roles_a, rolename_a, permissions, preferencesjson, constraints_a, signin_id
         INTO tmp_userid, tmp_status_id, tmp_email, tmp_fullname, tmp_roles_a, tmp_rolename_a, tmp_permissions, tmp_preferencesjson, tmp_constraints_a, tmp_signin_id;
   	    
END