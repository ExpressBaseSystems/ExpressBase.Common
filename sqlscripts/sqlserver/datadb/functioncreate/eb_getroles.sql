CREATE OR ALTER PROCEDURE eb_getroles
	@userid int,
	@wc varchar(max),
	@roles varchar(max) output,
	@role_name varchar(max) output
AS
BEGIN
	DECLARE @app_type varchar(max);
	
	IF @wc = 'tc' OR @wc = 'dc' 
		SET @app_type = '1, 2, 3';
    
    IF @wc = 'uc' 
		SET @app_type = '1';
   
	IF @wc = 'mc' 
		SET @app_type ='2';
   
    IF @wc = 'bc' 
		SET @app_type = '3';

	DROP TABLE IF EXISTS #app_type1;
	CREATE TABLE #app_type1(value int);
	INSERT INTO #app_type1
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@app_type,',');
    
	WITH role2role(role_id) AS
	(
		SELECT role2_id AS role_id FROM eb_role2role WHERE role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id = @userid AND eb_del = 'F')AND eb_del = 'F'
		UNION ALL
		SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id AND eb_del='F'
	)
	SELECT 
		@roles = STRING_AGG(role_id,','),@role_name = STRING_AGG(role_name,',')
	FROM
	(
		SELECT role_id, r.role_name, r.applicationid FROM
		(
			SELECT DISTINCT role_id FROM
			(
				SELECT role_id FROM eb_role2user WHERE user_id = @userid AND eb_del = 'F'
				UNION ALL
				SELECT role_id FROM role2role
				--)ORDER BY role_id
			)ROLES
		)QURY
		LEFT JOIN
			(SELECT * FROM eb_roles WHERE eb_del = 'F' AND applicationid = ANY(SELECT eb_applications.id FROM eb_applications WHERE application_type=ANY(select value from #app_type1))) r
		ON
			qury.role_id = r.id
	)UROLES
		WHERE 
			role_id < 100 OR 
			applicationid IS NOT NULL;
	SELECT @roles,@role_name;
END;
