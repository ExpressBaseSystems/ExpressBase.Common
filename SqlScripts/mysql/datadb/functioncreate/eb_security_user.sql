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
    IN _usertype integer,
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
CALL eb_str_to_tbl_util(_roles,',');  
CREATE TEMPORARY TABLE IF NOT EXISTS temp_roles SELECT `value` FROM temp_array_table;

DROP TEMPORARY TABLE IF EXISTS temp_group;
CALL eb_str_to_tbl_util(_groups,',');  
CREATE TEMPORARY TABLE IF NOT EXISTS temp_group SELECT `value` FROM temp_array_table;

IF _id > 1 THEN
	IF _statusid > 99 THEN
		SET _statusid = _statusid - 100;
	ELSE
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (_id, _statusid, _userid, NOW());
	END IF;

	UPDATE eb_users u 
	SET 
		u.fullname= _fullname, u.nickname=_nickname, u.email=_email, u.dob=_dob, u.sex=_sex, u.alternateemail=_alternateemail, u.phnoprimary=_phprimary, u.phnosecondary=_phsecondary, u.landline=_phlandphone, 
        u.phextension=_extension, u.fbid=_fbid, u.fbname=_fbname, u.statusid=_statusid, u.hide=_hide, u.preferencesjson=_preferences, u.eb_user_types_id=_usertype, u.eb_lastmodified_by=_userid, u.eb_lastmodified_at=NOW() 
	WHERE 
		u.id = _id;
			
	INSERT INTO eb_role2user(role_id,user_id,createdby,createdat) 
		SELECT 
				r.`value`,_id,_userid,NOW() 
			FROM 
				((SELECT `value` FROM temp_roles WHERE `value` NOT IN
					(SELECT role_id from eb_role2user WHERE user_id = _id AND eb_del = 'F'))) AS r;
	UPDATE eb_role2user er2u
	SET 
		er2u.eb_del = 'T',er2u.revokedby = _userid,er2u.revokedat =NOW() 
	WHERE 
		er2u.user_id = _id AND er2u.eb_del = 'F' AND er2u.role_id IN( SELECT * FROM(
			SELECT role_id FROM eb_role2user WHERE user_id = _id AND eb_del = 'F' AND role_id NOT IN( 
				SELECT `value` FROM temp_roles))AS q1) ;

	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
		SELECT 
				_id,`value`,_userid,NOW() 
			FROM 
				(SELECT `value` FROM temp_group WHERE `value` NOT IN
						(SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F')) AS groupid;
	UPDATE	eb_user2usergroup eu2g
	SET 
			eu2g.eb_del = 'T',eu2g.revokedby = _userid,eu2g.revokedat =NOW() 
	WHERE 
			eu2g.userid = _id AND eu2g.eb_del = 'F' AND eu2g.groupid IN(SELECT * FROM (
				SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F' AND groupid NOT IN (
					SELECT `value` FROM temp_group))as q2);
	SET _keyid = uid;
	SET _add_data = _consadd;
	SET _delete_ids	= _consdel;		  
	CALL eb_security_constraints(_userid, _keyid, _add_data, _delete_ids, @out_add_no, @out_del_no);	
				 
ELSE
	SET uid = 0;
	SELECT COUNT(*) FROM eb_users WHERE LOWER(email)=LOWER(_email) AND COALESCE(eb_del, 'F')='F' INTO uid;
	IF(uid > 0) THEN
		SET uid = -2;
	ELSE
		INSERT INTO eb_users 
			(fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, eb_created_by, eb_created_at, statusid, hide, preferencesjson, eb_user_types_id) 
		VALUES 
			(_fullname, _nickname, _email, _pwd, _dob, _sex, _alternateemail, _phprimary, _phsecondary, _phlandphone, _extension, _fbid, _fbname, _userid, NOW(), _statusid, _hide, _preferences, _usertype);
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
			UPDATE eb_usersanonymous 
				SET modifiedby = _userid, modifiedat = NOW(), ebuserid = uid
				WHERE id = _anonymoususerid;
		END IF;
	
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (uid, _statusid, _userid, NOW());
		SET _keyid = uid;
		SET _add_data = _consadd;
		SET _delete_ids	= _consdel;		  
		CALL eb_security_constraints(_userid, _keyid, _add_data, _delete_ids, @out_add_no, @out_del_no);	
	END IF;	
END IF;

SELECT uid INTO out_uid;
END