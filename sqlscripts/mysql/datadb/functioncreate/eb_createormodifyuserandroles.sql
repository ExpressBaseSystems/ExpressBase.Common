CREATE PROCEDURE eb_createormodifyuserandroles(IN userid integer,
    IN id integer,
    IN fullname text,
    IN nickname text,
    IN email text,
    IN pwd text,
    IN dob date,
    IN sex text,
    IN alternateemail text,
    IN phprimary text,
    IN phsecondary text,
    IN phlandphone text,
    IN extension text,
    IN fbid text,
    IN fbname text,
    IN roles text,
    IN `groups` text,
    IN statusid integer,
    IN hide text,
    IN anonymoususerid integer,
    IN preference text,
    OUT out_uid integer)
BEGIN
DECLARE uid integer; 
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS _roles;
DROP TEMPORARY TABLE IF EXISTS _group;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);        
	CALL STR_TO_TBL(roles);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _roles SELECT `value` FROM temp_array_table;
  
	CALL STR_TO_TBL(`groups`);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _group SELECT `value` FROM temp_array_table;
    
IF id > 1 THEN
	IF statusid > 99 THEN
		set statusid = statusid - 100;
	ELSE
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (id, statusid, userid, NOW());
	END IF;

   UPDATE eb_users eu SET eu.fullname= fullname, eu.nickname=nickname, eu.email=email, eu.dob=dob, eu.sex=sex, 
	eu.alternateemail=alternateemail, eu.phnoprimary=phprimary, eu.phnosecondary=phsecondary, eu.landline=phlandphone, 
	eu.phextension=extension, eu.fbid=fbid, eu.fbname=fbname, eu.statusid=statusid, eu.hide=hide, eu.preferencesjson=preference 
   WHERE eu.id = id;
			
   INSERT INTO eb_role2user(user_id,createdby,createdat,role_id) SELECT id,userid,NOW(),`value` FROM 
   (SELECT `value` from _roles WHERE `value` not in 
		(SELECT er2u.role_id FROM eb_role2user er2u WHERE er2u.user_id = id AND er2u.eb_del = 'F')) AS roleid;
   UPDATE eb_role2user er2u2 SET er2u2.eb_del = 'T',er2u2.revokedby = userid,er2u2.revokedat =NOW() WHERE er2u2.user_id = id 
   AND er2u2.eb_del = 'F' AND er2u2.role_id IN(
		SELECT * FROM (SELECT er2u1.role_id from eb_role2user er2u1 WHERE er2u1.user_id = id AND er2u1.eb_del = 'F' and er2u1.role_id not in( 
		SELECT `value` FROM _roles))as aa);

   INSERT INTO eb_user2usergroup(userid,createdby,createdat,groupid) SELECT id,userid,NOW(),`value` FROM 
   (SELECT `value` FROM _group WHERE `value` NOT IN(
		SELECT eu2g.groupid FROM eb_user2usergroup eu2g WHERE eu2g.userid = id AND eu2g.eb_del = 'F')) AS groupid;
   UPDATE eb_user2usergroup eu2g SET eu2g.eb_del = 'T',eu2g.revokedby = userid,eu2g.revokedat =NOW() WHERE eu2g.userid = id 
	AND eu2g.eb_del = 'F' AND eu2g.groupid IN(SELECT * FROM (
		SELECT eu2g1.groupid FROM eb_user2usergroup eu2g1 WHERE eu2g1.userid = id AND eu2g1.eb_del = 'F' 
        and eu2g1.groupid not in( 
		SELECT `value` FROM _group))as ab);

ELSE

   INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
    VALUES (fullname, nickname, email, pwd, dob, sex, alternateemail, phprimary, phsecondary, phlandphone, extension, fbid, fbname, userid, NOW(), statusid, hide, preference);
    SELECT last_insert_id() INTO uid;
      
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
	    	SELECT uid into out_uid;
  END IF;

END