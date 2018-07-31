-- FUNCTION: eb_create_or_update_role2user(integer, integer, comma seperated string)

-- DROP FUNCTION eb_create_or_update_role2user

DELIMITER $$
CREATE FUNCTION eb_create_or_update_role2user(
	roleid integer,
	userid integer,
	usersid_str text)
    RETURNS integer
    DETERMINISTIC
    
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
    
	CALL STR_TO_TBL(usersid_str);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS usersid SELECT `value` FROM temp_array_table;
	
    UPDATE eb_role2user 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = userid 
    WHERE 
        user_id IN(
            SELECT user_id from eb_role2user WHERE role_id = roleid and eb_del = 'F'
        AND user_id NOT IN(SELECT `value` FROM usersid));

    INSERT INTO eb_role2user 
        (user_id, role_id, createdby, createdat) 
    SELECT 
        `value`, roleid, userid, NOW()        
    FROM (SELECT `value` FROM usersid 
        WHERE  `value` NOT IN (SELECT user_id from eb_role2user WHERE role_id = roleid and eb_del = 'F')) AS a;
RETURN 0;

END;