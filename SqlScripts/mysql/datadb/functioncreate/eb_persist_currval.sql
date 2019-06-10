CREATE FUNCTION eb_persist_currval(seq_name TEXT) RETURNS int(11)
BEGIN

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_currval(name TEXT, value INTEGER);
INSERT INTO tmp_currval(name, value) VALUES(seq_name,(SELECT LAST_INSERT_ID()));

RETURN 1;
END