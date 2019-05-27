CREATE PROCEDURE cur_val(seq text, out curval int)
BEGIN
DECLARE _curval int;
SELECT `value` FROM tmp_currval WHERE name = seq INTO _curval;

SELECT _curval INTO curval;

END