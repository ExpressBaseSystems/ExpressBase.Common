DROP FUNCTION IF EXISTS SPLIT_STR;

CREATE FUNCTION SPLIT_STR(x LONGTEXT,
	  delim VARCHAR(12),
	  pos INT) RETURNS varchar(255) 
	READS SQL DATA
    DETERMINISTIC
BEGIN

RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
		   LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
		   delim, '');
RETURN 1;

END 