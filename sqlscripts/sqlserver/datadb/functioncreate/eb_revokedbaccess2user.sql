CREATE OR ALTER   PROCEDURE eb_revokedbaccess2user
	@username varchar(max),
	@dbname varchar(max)
AS
BEGIN
	DECLARE @i int = 1; DECLARE @db_cnt int = 0; DECLARE @db varchar(max);

	DROP TABLE IF EXISTS #dbs;
	CREATE TABLE #dbs
	(
		id int identity(1,1) primary key,
		value varchar(max)
	);
	INSERT INTO #dbs 
		SELECT name FROM master.dbo.sysdatabases where dbid > 4;

	SELECT @db_cnt = count(*) FROM master.dbo.sysdatabases where dbid > 4;
	WHILE @i<= @db_cnt
	BEGIN
		SELECT @db = value FROM #dbs WHERE id = @i;
		SET @i = @i + 1;
	END;
END;