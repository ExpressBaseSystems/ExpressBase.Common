CREATE OR ALTER FUNCTION eb_str_to_tbl_util
(
	@str  VARCHAR(MAX), @separator CHAR(1)
)
RETURNS
	@result TABLE(value VARCHAR(MAX))
AS
BEGIN
	
	DECLARE @separatorposition INT = CHARINDEX(@separator, @str ),
			@value VARCHAR(MAX), 
			@startposition INT = 1
 
	IF @separatorposition = 0  
	BEGIN
		INSERT INTO @result VALUES(@str)
		RETURN
	END
     
	SET @str = @str + @separator
	WHILE @separatorposition > 0
	BEGIN
		SET @value = SUBSTRING(@str , @startposition, @separatorposition- @startposition)
 
		IF( @value <> ''  ) 
			INSERT INTO @result VALUES(@value)
   
		SET @startposition = @separatorposition + 1
		SET @separatorposition = CHARINDEX(@separator, @str , @startposition)
	END    
     
 RETURN
END
GO


