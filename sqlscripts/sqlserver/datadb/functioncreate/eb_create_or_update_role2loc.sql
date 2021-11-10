CREATE OR ALTER     PROCEDURE eb_create_or_update_role2loc
	@roleid int,
	@userid int,
	@locations varchar(max)

AS
BEGIN
	DROP TABLE IF EXISTS #location_tbl;
	CREATE TABLE #location_tbl(value int);
	INSERT INTO #location_tbl 
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@locations,',');	
			
	UPDATE 
			eb_role2location 
		SET 
			eb_del = 'T', eb_revokedat = CURRENT_TIMESTAMP, eb_revokedby = @userid 
		WHERE 
			roleid = @roleid AND eb_del = 'F' AND locationid IN(
				SELECT locationid FROM eb_role2location WHERE roleid = @roleid AND eb_del = 'F' AND locationid NOT IN( 
						SELECT value FROM #location_tbl));

	INSERT INTO 
			eb_role2location(locationid, roleid, eb_createdby, eb_createdat) 
				SELECT 
						_locs.value, @roleid, @userid, CURRENT_TIMESTAMP 
					FROM 
						(SELECT value FROM #location_tbl WHERE value NOT IN(
								SELECT locationid FROM eb_role2location WHERE roleid = @roleid AND eb_del = 'F')) AS _locs;
	
	return 0;
END;
