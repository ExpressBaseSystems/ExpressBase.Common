CREATE OR ALTER PROCEDURE eb_create_or_update_role2role

@roleid int,
@userid int,
@dependantroles varchar(max)

AS
BEGIN

	DROP TABLE IF EXISTS #dependantroles_tbl;
	CREATE TABLE #dependantroles_tbl(value int);
	INSERT INTO #dependantroles_tbl 
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@dependantroles,',');	

	UPDATE 
			eb_role2role 
		SET 
			eb_del = 'T',revokedat = CURRENT_TIMESTAMP,revokedby =@userid
		WHERE 
			role1_id = @roleid AND eb_del = 'F' AND role2_id IN(
					SELECT role2_id FROM eb_role2role WHERE role1_id = @roleid and eb_del = 'F' AND role2_id NOT IN(
							SELECT value FROM #dependantroles_tbl));

	INSERT INTO eb_role2role 
			(role2_id, role1_id, createdby, createdat) 
		SELECT 
				d.value, @roleid, @userid, current_timestamp        
			FROM 
				(SELECT value FROM #dependantroles_tbl WHERE value NOT IN(
			        SELECT  role2_id FROM eb_role2role WHERE role1_id = @roleid and eb_del = 'F')) AS d;
	return 0;
END;