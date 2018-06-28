-- FUNCTION: eb_createbot(text, text, text, text, text, integer, integer)

-- DROP FUNCTION IF EXISTS eb_createbot;
DELIMITER $$

CREATE FUNCTION eb_createbot(
	_sol_id text,
    _name text,
    _fullname text,
    _url text,
    _wel_msg text,
    _userid integer,
    _id integer)
    RETURNS text
    DETERMINISTIC
BEGIN
	DECLARE _botid text;
    DECLARE insertedbotid text;
    DECLARE returnid integer;
    DECLARE appid integer;
    
    IF (_id > 0) THEN
		UPDATE eb_bots
        SET 
			`name` = _name,
			fullname = _fullname,
			url = _url,
			welcome_msg = _wel_msg,
			modified_by = _userid,
			modified_at = now()
        WHERE id = _id;
        SELECT botid, app_id INTO insertedbotid, appid FROM eb_bots WHERE id = _id;
        UPDATE eb_applications SET applicationname = concat(_fullname, '(Chatbot)') WHERE id = appid;
	ELSE 
		INSERT INTO eb_applications (applicationname, description) VALUES (CONCAT(_fullname,'(Chatbot)'),'This is bot application' );
        SELECT last_insert_id() INTO appid;
		
		INSERT INTO eb_bots (`name`, url,fullname,app_id, welcome_msg, created_by, created_at)
		VALUES (_name, _url,_fullname, appid, _wel_msg , _userid, NOW());
        SELECT last_insert_id() INTO returnid;

		SET _botid := CONCAT_WS('-', _sol_id, returnid, _url);
		UPDATE eb_bots SET botid = _botid WHERE id=returnid;
		SET insertedbotid := (SELECT botid FROM eb_bots WHERE id=returnid);
	END IF;
    RETURN insertedbotid;
END$$