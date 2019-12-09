CREATE OR ALTER PROCEDURE eb_security_constraints
	@_userid int,
	@_keyid int,
	@_add_data varchar(max),
	@_delete_ids varchar(max),
	@add_no int OUT,
	@del_no int OUT

AS
BEGIN
	
	DECLARE @add_no1 int = 0; DECLARE @del_no1 int = 10; 
	DECLARE @cmaster_cnt int = 0; DECLARE @i int = 1;  DECLARE @cmaster varchar(max);
	DECLARE @add_con_cnt int = 0; DECLARE @con1 varchar(max); DECLARE @con2 varchar(max); DECLARE @con3 varchar(max);
	DECLARE @temp int =0; DECLARE @j int = 1; DECLARE @cline_temp_cnt int = 0; DECLARE @cline varchar(max);
	DECLARE @cline1 varchar(max); DECLARE @cline2 varchar(max); DECLARE @cline3 varchar(max);

	UPDATE eb_constraints_master SET eb_del = 'T', eb_lastmodified_by = @_userid, eb_lastmodified_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC' 
	WHERE eb_del = 'F' AND id IN(SELECT value FROM STRING_SPLIT(@_delete_ids, ','));
	SELECT @del_no1 = @@ROWCOUNT;

	DROP TABLE IF EXISTS #cmaster_temp;
	CREATE TABLE #cmaster_temp 
	(
		ID INT IDENTITY(1, 1) primary key,
		value varchar(max)
	);
	INSERT INTO #cmaster_temp
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@_add_data,'$$');
	SELECT @cmaster_cnt = @@ROWCOUNT;
	WHILE @i <= @cmaster_cnt
	BEGIN
		SELECT @cmaster = value FROM #cmaster_temp WHERE id = @i;

		DROP TABLE IF EXISTS #add_con;
		CREATE TABLE #add_con
		(
			id int identity(1,1) primary key,
			value varchar(max)
		);
		INSERT INTO #add_con 
			SELECT * FROM [dbo].[eb_str_to_tbl_util](@cmaster,'$');
		SELECT @add_con_cnt = @@ROWCOUNT;

		SELECT @con1 = value FROM #add_con WHERE id = 1;
		SELECT @con2 = value FROM #add_con WHERE id = 2;
		SELECT @con3 = value FROM #add_con WHERE id = 3;

		INSERT INTO eb_constraints_master(key_id, key_type, description, eb_created_by, eb_created_at)
		VALUES(@_keyid, CAST(@con1 AS int), @con2, @_userid, CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
		SELECT @temp = SCOPE_IDENTITY();
		SET @add_no1 = @add_no1 + 1;

		DROP TABLE IF EXISTS #cline_temp;
		CREATE TABLE #cline_temp
		(
			id int identity(1,1) primary key,
			value varchar(max)
		);
		INSERT INTO #cline_temp
			SELECT * FROM [dbo].[eb_str_to_tbl_util](@con3,';;');
		SELECT @cline_temp_cnt = @@ROWCOUNT;

		WHILE @j <= @cline_temp_cnt
		BEGIN
			SELECT @cline = value FROM #cline_temp WHERE id = @j;

			DROP TABLE IF EXISTS #temp;
			CREATE TABLE #temp
			(
				id int identity(1,1) primary key,
				value varchar(max)
			);
			INSERT INTO #temp
				SELECT * FROM [dbo].[eb_str_to_tbl_util](@cline,';');

			SELECT @cline1 = value FROM #temp WHERE id = 1;
			SELECT @cline2 = value FROM #temp WHERE id = 2;
			SELECT @cline3 = value FROM #temp WHERE id = 3;

			INSERT INTO eb_constraints_line(master_id, c_operation, c_type, c_value)
			VALUES(@temp, CAST(@cline1 AS int), CAST(@cline2 AS int), @cline3);

			SET @j = @j + 1;
		END;

		SET @i = @i + 1;
	END;

	SELECT @add_no = @add_no1, @del_no = @del_no1;
END;
