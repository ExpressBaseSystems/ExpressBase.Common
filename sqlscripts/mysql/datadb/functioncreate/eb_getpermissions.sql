CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_getpermissions`(IN roles text)
BEGIN
declare _permission text;
drop temporary table if exists permissions_tmp;
set _permission=(
	SELECT GROUP_CONCAT(concat( _per.permissionname,':', _loc.locationid) separator ',') FROM eb_role2permission _per, eb_role2location _loc
		WHERE _per.role_id = _loc.roleid AND _per.role_id = FIND_IN_SET(role_id,roles) AND _per.eb_del='F' AND _loc.eb_del='F');
create temporary table permissions_tmp(value text);
insert into permissions_tmp(value) values (_permission);	
select * from permissions_tmp;
END