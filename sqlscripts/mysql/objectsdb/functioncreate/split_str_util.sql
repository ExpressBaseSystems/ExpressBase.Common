CREATE FUNCTION SPLIT_STR(x VARCHAR(255),
	  delim VARCHAR(12),
	  pos INT) RETURNS varchar(255) CHARSET latin1
BEGIN
RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
		   LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
		   delim, '');
RETURN 1;
END