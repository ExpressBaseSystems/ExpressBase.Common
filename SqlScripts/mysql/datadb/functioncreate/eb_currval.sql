CREATE FUNCTION eb_currval(seq TEXT) RETURNS int(11)
BEGIN

DECLARE _curval INTEGER;

SELECT MAX(`value`) FROM tmp_currval WHERE name = seq INTO _curval;
IF _curval IS NULL THEN SET _curval=0; END IF; 

RETURN _curval;
END