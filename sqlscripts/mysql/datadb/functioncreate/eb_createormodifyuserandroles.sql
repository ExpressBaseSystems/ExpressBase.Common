CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_createormodifyuserandroles`(IN _userid integer,
    IN _id integer,
    IN _fullname text,
    IN _nickname text,
    IN _email text,
    IN _pwd text,
    IN _dob date,
    IN _sex text,
    IN _alternateemail text,
    IN _phnoprimary text,
    IN _phnosecondary text,
    IN _landline text,
    IN _phextension text,
    IN _fbid text,
    IN _fbname text,
    IN _roles_temp text,
    IN _group_temp text,
    IN _statusid integer,
    IN _hide text,
    IN _anonymoususerid integer,
    IN _preferences text)
BEGIN
DECLARE uid integer; 
-- DECLARE _roles integer[];
-- DECLARE _group integer[];

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
        
	CALL STR_TO_TBL(_roles);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _roles SELECT `value` FROM temp_array_table;
   drop temporary table if exists temp_array_table1;
   CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table1(value integer);
    
	CALL STR_TO_TBL(_group_temp);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _group SELECT `value` FROM temp_array_table1;
    
IF _id > 1 THEN
	IF _statusid > 99 THEN
		set _statusid = _statusid - 100;
	ELSE
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (_id, _statusid, _userid, NOW());
	END IF;

   UPDATE eb_users SET fullname= _fullname, nickname=_nickname, email=_email, dob=_dob, sex=_sex, alternateemail=_alternateemail, phnoprimary=_phnoprimary, phnosecondary=_phnosecondary, landline=_landline, phextension=_phextension, fbid=_fbid, fbname=_fbname, statusid=_statusid, hide=_hide, preferencesjson=_preferences WHERE id = _id;
			
   INSERT INTO eb_role2user(role_id,user_id,createdby,createdat) SELECT `value`,_id,_userid,NOW() FROM 
   (select `value` from _roles where `value` not in 
		(SELECT role_id from eb_role2user WHERE user_id = _id AND eb_del = 'F')) AS roleid;
   UPDATE eb_role2user SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE user_id = _id AND eb_del = 'F' AND role_id IN(
		SELECT role_id from eb_role2user WHERE user_id = _id AND eb_del = 'F' and role_id not in( 
		SELECT `value` from _roles));

   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT _id,`value`,_userid,NOW() FROM 
   (select `value` from _group where `value` not in(
		SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F')) AS groupid;
   UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE userid = _id AND eb_del = 'F' AND groupid IN(
		SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F' and groupid not in( 
		select `value` from _group)) ;

ELSE

   INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
    VALUES (_fullname, _nickname, _email, _pwd, _dob, _sex, _alternateemail, _phnoprimary, _phnosecondary, _landline, _phextension, _fbid, _fbname, _userid, NOW(), _statusid, _hide, _preferences);
    select last_insert_id() INTO uid;
      
   INSERT INTO eb_role2user (role_id,user_id,createdby,createdat) SELECT roleid, uid,_userid,NOW() 
    FROM (select `value` from _roles) AS roleid;
    
   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT uid, groupid,_userid,NOW() 
    FROM (select `value` from _group) AS groupid;
	
	IF _id > 0 THEN
		UPDATE eb_usersanonymous SET modifiedby = _userid, modifiedat = NOW(), ebuserid = uid
			WHERE id = _anonymoususerid;
	END IF;
	
	INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (uid, _statusid, _userid, NOW());
   
END IF;
  IF _userid > 0 THEN
	    	SELECT uid;
  END IF;

END