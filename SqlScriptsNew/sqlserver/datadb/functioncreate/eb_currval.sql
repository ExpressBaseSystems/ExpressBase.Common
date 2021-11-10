CREATE OR ALTER FUNCTION eb_currval
(@seq varchar(max))
RETURNS int
AS
BEGIN
	DECLARE @currval int = 0;
	SELECT @currval = CAST(current_value AS int) FROM sys.sequences WHERE name = @seq ;
	RETURN @currval;
END;