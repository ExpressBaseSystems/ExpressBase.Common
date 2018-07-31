-- FUNCTION : eb_createormodifyusergroup(integer, integer, text, text, text)

-- DROP FUNCTION IF EXISTS eb_createormodifyusergroup;
DELIMITER $$

CREATE FUNCTION eb_createormodifyusergroup(
	_userid integer,
	_id integer,
	_name text,
	_description text,
	_users text)
    RETURNS integer
    DETERMINISTIC
BEGIN
	DECLARE gid integer;
    

	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	
	CALL STR_TO_TBL(_users);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS users SELECT `value` FROM temp_array_table;
    
	SET gid:=_id;
	IF _id > 0 THEN

		UPDATE eb_usergroup
			SET name=_name,
            description=_description WHERE id=_id;
            
		INSERT INTO eb_user2usergroup
			(userid,groupid,createdby,createdat)
            SELECT 
				`value`,_id,_userid,NOW()
			FROM (SELECT `value` FROM users  WHERE `value` 
				NOT IN(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) AS a;
           
		UPDATE eb_user2usergroup
			SET eb_del = 'T',
            revokedby = _userid,
            revokedat =NOW()
		WHERE userid
			IN( SELECT userid 
				FROM eb_user2usergroup
				WHERE groupid = _id AND eb_del = 'F' 
				AND  userid NOT IN( SELECT `value` FROM users));
		ELSE
			INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F');
            SELECT last_insert_id() INTO gid;
            
			INSERT INTO eb_user2usergroup
				(userid,groupid,createdby,createdat)
			SELECT `value`, gid,_userid,NOW() 
			FROM (SELECT `value` FROM users) AS b;

	END IF;

	RETURN gid;
END;