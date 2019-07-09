DROP PROCEDURE IF EXISTS eb_getpermissions;

CREATE PROCEDURE eb_getpermissions(
	IN roles TEXT,
	OUT out_permission TEXT)
BEGIN

DECLARE _permission TEXT;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS roles_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value INTEGER);
        
CALL STR_TO_TBL(roles);  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS roles_tmp SELECT `value` FROM temp_array_table;

SET _permission=(
	SELECT GROUP_CONCAT(CONCAT( _per.permissionname,':', _loc.locationid) SEPARATOR ',') FROM eb_role2permission _per, eb_role2location _loc
		WHERE _per.role_id = _loc.roleid AND _per.role_id = ANY(SELECT `value` FROM roles_tmp) AND _per.eb_del='F' AND _loc.eb_del='F');

SELECT _permission INTO out_permission;

END