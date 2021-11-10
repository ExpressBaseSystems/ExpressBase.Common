CREATE OR ALTER PROCEDURE eb_create_or_update_role2user
	@roleid	int,
	@userid int,
	@usersid varchar(max)

AS
BEGIN
	DROP TABLE IF EXISTS #userid_tbl;
	CREATE TABLE #userid_tbl(value int);
	INSERT INTO #userid_tbl 
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@usersid,',');

	UPDATE 
			eb_role2user 
		SET 
			eb_del = 'T',revokedat = CURRENT_TIMESTAMP,revokedby =  @userid
		WHERE 
			role_id = @roleid AND eb_del = 'F' AND user_id IN(
					SELECT user_id FROM eb_role2user WHERE role_id = @roleid and eb_del = 'F' AND user_id NOT IN( 
							SELECT value FROM #userid_tbl));


	INSERT INTO eb_role2user 
        (user_id, role_id, createdby, createdat) 
    SELECT 
        u.value, @roleid, @userid, CURRENT_TIMESTAMP         
    FROM 
		(SELECT value FROM #userid_tbl WHERE value NOT IN(      
				SELECT user_id FROM eb_role2user WHERE role_id = @roleid and eb_del = 'F')) AS u;

	RETURN 0;
END;