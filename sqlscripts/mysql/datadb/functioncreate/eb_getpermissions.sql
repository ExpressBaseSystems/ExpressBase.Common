
-- DROP FUNCTION  IF EXISTS  eb_getpermissions;

DELIMITER $$
CREATE FUNCTION eb_getpermissions(
	roles VARCHAR(255))
RETURNS TEXT
DETERMINISTIC
BEGIN
	
    DECLARE _permissions  TEXT;
    SET _permissions = 
    (SELECT 
	   GROUP_CONCAT( permissionname) AS permissions
	FROM 
		eb_role2permission
	WHERE FIND_IN_SET(role_id,roles) AND eb_del='F');
    RETURN _permissions;
END$$
DELIMITER ;

-- SELECT eb_getpermissions('1,2,3,50')