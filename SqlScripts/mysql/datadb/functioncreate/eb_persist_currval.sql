CREATE PROCEDURE eb_persist_currval(seq_name text)
BEGIN

CREATE TEMPORARY TABLE IF NOT EXISTS tmp_currval(name text, value integer);
INSERT INTO tmp_currval(name, value) VALUES(seq_name,(SELECT LAST_INSERT_ID()));

END