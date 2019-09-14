DROP PROCEDURE IF EXISTS eb_security_usergroup;

CREATE PROCEDURE eb_security_usergroup(IN userid integer,
	IN id integer,
	IN name text,
	IN description text,
	IN users text,
	IN constraints_add text,
	IN constraints_del text,
    OUT out_gid integer)
BEGIN
DECLARE gid integer;
DECLARE _userid integer;
DECLARE _id integer;
DECLARE _name text;
DECLARE _description text;
DECLARE _users text;
DECLARE _constraints_add text;
DECLARE _constraints_del text;
DECLARE _keyid integer;
DECLARE _add_data text;
DECLARE _delete_ids text;
SET _userid = userid;
SET _id = id;
SET _name = name;
SET _description = description;
SET _users = users;
SET _constraints_add = constraints_add;
SET _constraints_del = constraints_del;

SET gid =_id;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_users;
		CREATE TEMPORARY TABLE temp_array_table(value INTEGER);
	CALL STR_TO_TBL(_users);  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_users SELECT `value` FROM temp_array_table;
SET SQL_SAFE_UPDATES = 0;

IF _id > 0 THEN
	UPDATE eb_usergroup SET name=_name, description=_description WHERE id=_id;
    
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT 
					`value`,_id,_userid,NOW() 
				FROM 
					( SELECT `value` FROM temp_users WHERE `value` NOT IN 
						(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) AS userid;
	UPDATE 
			eb_user2usergroup 
		SET 
			eb_del = 'T',revokedby = _userid,revokedat =NOW() 
		WHERE groupid = _id AND eb_del = 'F' AND userid IN(
		 SELECT * FROM (
			SELECT userid FROM eb_user2usergroup WHERE groupid = _id AND eb_del = 'F' AND userid NOT IN 
		(SELECT `value` FROM temp_users))as q1);	
ELSE
	INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F');
    SELECT LAST_INSERT_ID() INTO gid;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT `value`, gid,_userid,NOW() 
			FROM (SELECT `value` FROM temp_users) AS userid;
            
END IF;
SET _keyid = gid;
SET _add_data = _constraints_add;
SET _delete_ids	= _constraints_del;		

CALL eb_security_constraints(_userid, _keyid, _add_data, _delete_ids, @out_add_no, @out_del_no);
					  
SELECT gid INTO out_gid;
END