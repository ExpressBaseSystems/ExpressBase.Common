-- FUNCTION: eb_create_or_update_role2role(integer, integer, comma seperated string)

-- DROP FUNCTION eb_create_or_update_role2role;

DELIMITER $$
CREATE FUNCTION eb_create_or_update_role2role(
	roleid integer,
	userid integer,
	dependantroles_str text)
    RETURNS integer
    DETERMINISTIC    
BEGIN
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
        
	CALL STR_TO_TBL(permissions_str);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS permissions SELECT `value` FROM temp_array_table;
    
    UPDATE eb_role2role 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = userid 
    WHERE 
        role2_id IN(SELECT role2_id FROM eb_role2role WHERE role1_id = roleid AND eb_del = 'F' 
        AND role2_id NOT IN(SELECT `value` FROM dependantroles));
        
    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat) 
    SELECT 
        `value`, roleid, userid, NOW()        
    FROM (SELECT `value` FROM dependantroles
        WHERE  role2_id NOT IN (SELECT role2_id FROM eb_role2role WHERE role1_id = roleid AND eb_del = 'F')) AS a;
RETURN 0;

END;