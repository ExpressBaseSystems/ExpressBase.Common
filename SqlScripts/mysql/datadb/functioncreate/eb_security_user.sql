DROP PROCEDURE IF EXISTS eb_security_user;

CREATE PROCEDURE eb_security_user(IN _userid integer,
	IN _id integer,
	IN _fullname text,
	IN _nickname text,
	IN _email text,
	IN _pwd text,
	IN _dob date,
	IN _sex text,
	IN _alternateemail text,
	IN _phprimary text,
	IN _phsecondary text,
	IN _phlandphone text,
	IN _extension text,
	IN _fbid text,
	IN _fbname text,
	IN _roles text,
	IN _groups text,
	IN _statusid integer,
	IN _hide text,
	IN _anonymoususerid integer,
	IN _preferences text,
	IN _consadd text,
	IN _consdel text,
    OUT out_uid integer)
BEGIN
DECLARE uid integer;
DECLARE _keyid integer;
DECLARE _add_data text;
DECLARE _delete_ids text;
SET uid = _id;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_roles;
		CREATE TEMPORARY TABLE temp_array_table(value INTEGER);
		CALL STR_TO_TBL(_roles);  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_roles SELECT `value` FROM temp_array_table;

		DROP TEMPORARY TABLE IF EXISTS temp_group;
		CALL STR_TO_TBL(_groups);  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_group SELECT `value` FROM temp_array_table;

IF _id > 1 THEN
	IF _statusid > 99 THEN
		SET _statusid = _statusid - 100;
	ELSE
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (_id, _statusid, _userid, NOW());
	END IF;

   UPDATE eb_users SET fullname= _fullname, nickname=_nickname, email=_email, dob=_dob, sex=_sex, alternateemail=_alternateemail, phnoprimary=_phprimary, phnosecondary=_phsecondary, landline=_phlandphone, phextension=_extension, fbid=_fbid, fbname=_fbname, statusid=_statusid, hide=_hide, preferencesjson=_preferences WHERE id = _id;
			
	INSERT INTO eb_role2user(role_id,user_id,createdby,createdat) 
		SELECT 
				`value`,_id,_userid,NOW() 
			FROM 
				((SELECT `value` FROM temp_roles WHERE `value` NOT IN
					(SELECT role_id from eb_role2user WHERE user_id = _id AND eb_del = 'F'))) AS roleid;
	UPDATE 
			eb_role2user 
		SET 
			eb_del = 'T',revokedby = _userid,revokedat =NOW() 
		WHERE 
			user_id = _id AND eb_del = 'F' AND role_id IN( SELECT * FROM(
				SELECT role_id FROM eb_role2user WHERE user_id = _id AND eb_del = 'F' AND role_id NOT IN( 
		SELECT `value` FROM temp_roles))AS q1) ;

	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT 
					_id,`value`,_userid,NOW() 
				FROM 
					(SELECT `value` FROM temp_group WHERE `value` NOT IN
							(SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F')) AS groupid;
	UPDATE 
			eb_user2usergroup 
		SET 
			eb_del = 'T',revokedby = _userid,revokedat =NOW() 
		WHERE 
			userid = _id AND eb_del = 'F' AND groupid IN(SELECT * FROM (
				SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F' AND groupid NOT IN (
					SELECT `value` FROM temp_group))as q2);
					 
ELSE

	INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
    VALUES (_fullname, _nickname, _email, _pwd, _dob, _sex, _alternateemail, _phprimary, _phsecondary, _phlandphone, _extension, _fbid, _fbname, _userid, NOW(), _statusid, _hide, _preferences);
    SELECT LAST_INSERT_ID() INTO uid;
      
   INSERT INTO eb_role2user (role_id,user_id,createdby,createdat) 
		SELECT 
				`value`, uid,_userid,NOW() 
			FROM (SELECT `value` FROM temp_roles) AS roleid;
    
   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
		SELECT 
				uid, `value`,_userid,NOW() 
			FROM (SELECT `value` FROM temp_group) AS groupid;
	
	IF _id > 0 THEN
		UPDATE eb_usersanonymous SET modifiedby = _userid, modifiedat = NOW(), ebuserid = uid
			WHERE id = _anonymoususerid;
	END IF;
	
	INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (uid, _statusid, _userid, NOW());
   
END IF;		
SET _keyid = uid;
SET _add_data = _consadd;
SET _delete_ids	= _consdel;		  
CALL eb_security_constraints(_userid, _keyid, _add_data, _delete_ids, @out_add_no, @out_del_no);	

SELECT uid INTO out_uid;
END