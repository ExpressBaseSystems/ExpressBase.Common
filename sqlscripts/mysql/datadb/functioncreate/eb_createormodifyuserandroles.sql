-- FUNCTION: eb_createormodifyuserandroles(integer, integer, text, text, text, text, date, text, text, text, text, text, text, text, text, text, text, integer, text, integer, text)

-- DROP PROCEDURE IF EXISTS eb_createormodifyuserandroles;
DELIMITER $$
CREATE PROCEDURE eb_createormodifyuserandroles(
	_userid integer,
	_id integer,
	_fullname text,
	_nickname text,
	_email text,
	_pwd text,
	_dob date,
	_sex text,
	_alternateemail text,
	_phnoprimary text,
	_phnosecondary text,
	_landline text,
	_phextension text,
	_fbid text,
	_fbname text,
	_roles_temp text,
	_group_temp text,
	_statusid integer,
	_hide text,
	_anonymoususerid integer,
	_preferences text)
BEGIN
	DECLARE uid integer;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
        
	CALL STR_TO_TBL(_roles);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _roles SELECT `value` FROM temp_array_table;
        
	CALL STR_TO_TBL(_group_temp);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _group SELECT `value` FROM temp_array_table;
    

	IF _id > 1 THEN
		IF _statusid > 99 THEN
			SET _statusid := _statusid - 100;
		ELSE
			INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (_id, _statusid, _userid, NOW());
		END IF;

	   UPDATE eb_users 
	   SET fullname= _fullname, nickname=_nickname, email=_email, dob=_dob, sex=_sex,
		   alternateemail=_alternateemail, phnoprimary=_phnoprimary, phnosecondary=_phnosecondary, landline=_landline,
		   phextension=_phextension, fbid=_fbid, fbname=_fbname, statusid=_statusid, hide=_hide,
		   preferencesjson=_preferences
	   WHERE id = _id;
				
		INSERT INTO eb_role2user
			(role_id,user_id,createdby,createdat)
		SELECT `value`, _id, _userid,NOW()
        FROM 
		   (SELECT `value` FROM _roles 
           WHERE  `value` NOT IN
           (SELECT role_id FROM eb_role2user WHERE user_id = _id AND eb_del = 'F')) AS a;
                
		UPDATE eb_role2user 
        SET eb_del = 'T',
			revokedby = _userid,
			revokedat =NOW()
		WHERE role_id 
        IN(SELECT role_id FROM eb_role2user WHERE user_id = _id AND eb_del = 'F'AND role_id
			NOT IN(SELECT `value` FROM _roles));

	   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat)
       SELECT _id,`value`,_userid,NOW()
       FROM (SELECT `value` FROM _group  WHERE `value` 
	   NOT IN (SELECT groupid FROM eb_user2usergroup WHERE userid = _id AND eb_del = 'F')) AS a;
            
	   UPDATE eb_user2usergroup
	   SET 	eb_del = 'T',
			revokedby = _userid,
			revokedat =NOW()
		WHERE groupid IN(
			SELECT groupid from eb_user2usergroup
			WHERE userid = _id AND eb_del = 'F' AND  groupid NOT IN(SELECT `value` FROM _group));
	ELSE
		INSERT INTO eb_users
			(fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary,
			landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
		VALUES (_fullname, _nickname, _email, _pwd, _dob, _sex, _alternateemail,
				_phnoprimary, _phnosecondary, _landline, _phextension, _fbid,
				_fbname, _userid, NOW(), _statusid, _hide, _preferences);
		SELECT last_insert_id() INTO uid;
		  
		INSERT INTO eb_role2user
			(role_id,user_id,createdby,createdat)
		SELECT 
			`value`, uid, _userid, NOW() 
		FROM (SELECT `value` FROM _roles) AS b;
		
	   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT uid, groupid,_userid,NOW() 
		FROM (SELECT `value` FROM _group) AS c;
		
		IF _id > 0 THEN
			UPDATE eb_usersanonymous SET modifiedby = _userid, modifiedat = NOW(), ebuserid = uid
				WHERE id = _anonymoususerid;
		END IF;
		
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (uid, _statusid, _userid, NOW());
	   
	END IF;
	  IF _userid > 0 THEN
		SELECT uid;
	  END IF;
END;