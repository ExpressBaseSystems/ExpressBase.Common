CREATE FUNCTION eb_currval(seq text) RETURNS int(11)
BEGIN
DECLARE curval integer;
DECLARE exce text;
DECLARE CONTINUE HANDLER FOR SQLSTATE '42000' return 0; 
SELECT last_insert_id() into curval;
RETURN curval;
RETURN 1;
END