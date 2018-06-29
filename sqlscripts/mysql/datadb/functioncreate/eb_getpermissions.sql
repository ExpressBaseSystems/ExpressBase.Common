
-- DROP PROCEDURE IF EXISTS eb_getpermissions;

DELIMITER $$
CREATE DEFINER=`jith`@`%` PROCEDURE `eb_getpermissions`( IN roles VARCHAR(255))
BEGIN
	SELECT 
	   GROUP_CONCAT( permissionname) AS permissions
	FROM 
		eb_role2permission
	WHERE FIND_IN_SET(role_id,roles) AND eb_del='F';
END$$
DELIMITER ;

-- CALL eb_getpermissions('1,2,3,50')