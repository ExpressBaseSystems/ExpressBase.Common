DROP PROCEDURE IF EXISTS eb_getpermissions;

CREATE PROCEDURE eb_getpermissions(
	IN roles TEXT,
	OUT out_permission TEXT)
BEGIN

DECLARE _permission TEXT;

SET _permission=(
	SELECT GROUP_CONCAT(CONCAT( _per.permissionname,':', _loc.locationid) SEPARATOR ',') FROM eb_role2permission _per, eb_role2location _loc
		WHERE _per.role_id = _loc.roleid AND FIND_IN_SET(_per.role_id,roles)  AND _per.eb_del='F' AND _loc.eb_del='F');

SELECT _permission INTO out_permission;

END