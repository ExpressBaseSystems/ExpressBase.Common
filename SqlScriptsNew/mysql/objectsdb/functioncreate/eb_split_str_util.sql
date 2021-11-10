DROP FUNCTION IF EXISTS eb_split_str_util;

CREATE FUNCTION eb_split_str_util(x LONGTEXT,
	  delim VARCHAR(12),
	  pos INT) RETURNS varchar(255) CHARSET latin1
    READS SQL DATA
    DETERMINISTIC
BEGIN

RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
		   LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
		   delim, '');
RETURN 1;

END