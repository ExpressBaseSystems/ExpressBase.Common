CREATE PROCEDURE eb_currval(seq text)
BEGIN

DECLARE _curval int;
SELECT max(`value`) FROM tmp_currval WHERE name = seq INTO _curval;
IF _curval IS NULL THEN SET _curval=0; END IF; 

SELECT _curval;

END