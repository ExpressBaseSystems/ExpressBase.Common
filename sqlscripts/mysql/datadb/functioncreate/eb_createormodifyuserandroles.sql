CREATE PROCEDURE eb_createormodifyuserandroles(IN userid INTEGER,
    IN id INTEGER,
    IN fullname TEXT,
    IN nickname TEXT,
    IN email TEXT,
    IN pwd TEXT,
    IN dob DATE,
    IN sex TEXT,
    IN alternateemail TEXT,
    IN phprimary TEXT,
    IN phsecondary TEXT,
    IN phlandphone TEXT,
    IN extension TEXT,
    IN fbid TEXT,
    IN fbname TEXT,
    IN roles TEXT,
    IN `groups` TEXT,
    IN statusid INTEGER,
    IN hide TEXT,
    IN anonymoususerid INTEGER,
    IN preference TEXT,
    OUT out_uid INTEGER)
BEGIN
DECLARE uid INTEGER; 
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS _roles;
DROP TEMPORARY TABLE IF EXISTS _group;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value INTEGER);        
	CALL STR_TO_TBL(roles);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _roles SELECT `value` FROM temp_array_table;
  
	CALL STR_TO_TBL(`groups`);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _group SELECT `value` FROM temp_array_table;
    
IF id > 1 THEN
	IF statusid > 99 THEN
		SET statusid = statusid - 100;
	ELSE
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (id, statusid, userid, NOW());
	END IF;

   UPDATE eb_users eu SET eu.fullname= fullname, eu.nickname=nickname, eu.email=email, eu.dob=dob, eu.sex=sex, 
	eu.alternateemail=alternateemail, eu.phnoprimary=phprimary, eu.phnosecondary=phsecondary, eu.landline=phlandphone, 
	eu.phextension=extension, eu.fbid=fbid, eu.fbname=fbname, eu.statusid=statusid, eu.hide=hide, eu.preferencesjson=preference 
   WHERE eu.id = id;
			
   INSERT INTO eb_role2user(user_id,createdby,createdat,role_id) SELECT id,userid,NOW(),`value` FROM 
   (SELECT `value` from _roles WHERE `value` NOT IN 
		(SELECT er2u.role_id FROM eb_role2user er2u WHERE er2u.user_id = id AND er2u.eb_del = 'F')) AS roleid;
   UPDATE eb_role2user er2u2 SET er2u2.eb_del = 'T',er2u2.revokedby = userid,er2u2.revokedat =NOW() WHERE er2u2.user_id = id 
   AND er2u2.eb_del = 'F' AND er2u2.role_id IN(
		SELECT * FROM (SELECT er2u1.role_id from eb_role2user er2u1 WHERE er2u1.user_id = id AND er2u1.eb_del = 'F' and er2u1.role_id NOT IN( 
		SELECT `value` FROM _roles))AS aa);

   INSERT INTO eb_user2usergroup(userid,createdby,createdat,groupid) SELECT id,userid,NOW(),`value` FROM 
   (SELECT `value` FROM _group WHERE `value` NOT IN(
		SELECT eu2g.groupid FROM eb_user2usergroup eu2g WHERE eu2g.userid = id AND eu2g.eb_del = 'F')) AS groupid;
   UPDATE eb_user2usergroup eu2g SET eu2g.eb_del = 'T',eu2g.revokedby = userid,eu2g.revokedat =NOW() WHERE eu2g.userid = id 
	AND eu2g.eb_del = 'F' AND eu2g.groupid IN(SELECT * FROM (
		SELECT eu2g1.groupid FROM eb_user2usergroup eu2g1 
			WHERE 
				eu2g1.userid = id AND eu2g1.eb_del = 'F' AND eu2g1.groupid NOT IN( 
		SELECT `value` FROM _group))AS ab);

ELSE

   INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
    VALUES (fullname, nickname, email, pwd, dob, sex, alternateemail, phprimary, phsecondary, phlandphone, extension, fbid, fbname, userid, NOW(), statusid, hide, preference);
    SELECT LAST_INSERT_ID() INTO uid;
      
   INSERT INTO eb_role2user (role_id,user_id,createdby,createdat) SELECT `value`, uid,userid,NOW() 
    FROM (SELECT `value` FROM _roles) AS roleid;
    
   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT uid, `value`,userid,NOW() 
    FROM (SELECT `value` FROM _group) AS groupid;
	
	IF id > 0 THEN
		UPDATE eb_usersanonymous SET modifiedby = userid, modifiedat = NOW(), ebuserid = uid
			WHERE id = anonymoususerid;
	END IF;
	
	INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (uid, statusid, userid, NOW());
   
END IF;
  IF userid > 0 THEN
	    	SELECT uid INTO out_uid;
  END IF;

END