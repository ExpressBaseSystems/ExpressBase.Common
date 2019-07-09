DROP PROCEDURE IF EXISTS eb_create_or_update_role2user;

CREATE PROCEDURE eb_create_or_update_role2user(IN rid INTEGER,
    IN createdby INTEGER,
    IN users_str TEXT   
    )
BEGIN
DECLARE a INTEGER;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS usersid_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value INTEGER);
	CALL STR_TO_TBL(users_str);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS usersid_tmp SELECT `value` FROM temp_array_table;
UPDATE 
	eb_role2user er2u
    SET 
        er2u.eb_del = 'T',er2u.revokedat = NOW(),er2u.revokedby = createdby 
    WHERE 
        er2u.role_id = rid AND er2u.eb_del = 'F' AND er2u.user_id IN(
			SELECT * FROM (
				SELECT user_id FROM eb_role2user WHERE role_id = rid AND eb_del = 'F' AND user_id NOT IN (
					SELECT `value` FROM usersid_tmp
			))AS q) ;

INSERT INTO 
		eb_role2user(user_id, role_id, createdby, createdat) 
    SELECT 
        `value`, rid, createdby, NOW()         
    FROM 
		(SELECT `value` FROM usersid_tmp 
     WHERE `value` NOT IN(SELECT er2u1.user_id FROM eb_role2user er2u1 WHERE er2u1.role_id = rid AND er2u1.eb_del = 'F'
	 )) AS users;

END 