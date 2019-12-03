CREATE OR ALTER PROCEDURE eb_getpermissions
	@roles varchar(max),
	@permission varchar(max) OUTPUT
AS
BEGIN
	DECLARE @temp varchar(max); 

	DROP TABLE IF EXISTS #roles_tmp;
	CREATE TABLE #roles_tmp (value int);
	INSERT INTO #roles_tmp
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@roles,',');

	SELECT @temp = COALESCE(@temp + ',','') + CONCAT(_per.permissionname,':',_loc.locationid) FROM eb_role2permission _per, eb_role2location _loc
		WHERE _per.role_id = _loc.roleid AND _per.role_id = ANY(SELECT value FROM #roles_tmp) AND _per.eb_del='F' AND _loc.eb_del='F';

	SELECT @temp;
END;
