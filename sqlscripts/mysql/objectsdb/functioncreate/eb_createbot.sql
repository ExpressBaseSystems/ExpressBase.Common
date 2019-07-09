DROP FUNCTION IF EXISTS eb_createbot;

CREATE FUNCTION eb_createbot(solid TEXT,
    name TEXT,
    fullname TEXT,
    url TEXT,
    welcome_msg TEXT,
    uid INTEGER,
    botid INTEGER) RETURNS text 
	READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE _botid TEXT;
DECLARE insertedbotid TEXT;
DECLARE returnid INTEGER;
DECLARE appid INTEGER;

IF (botid > 0) THEN
   	UPDATE eb_bots EB 
		SET EB.name = name, EB.fullname = fullname, EB.url = url, EB.welcome_msg = welcome_msg, EB.modified_by = uid, EB.modified_at = NOW(), EB.botid = (SELECT @botid:=EB.botid),EB.app_id = (SELECT @app_id:=EB.app_id) WHERE EB.id=botid; 
	SELECT @botid,@app_id
    INTO insertedbotid,appid;
    UPDATE eb_applications EA SET EA.applicationname = CONCAT(fullname,'(Chatbot)') WHERE EA.id = appid;
ELSE
    INSERT INTO eb_applications (applicationname, description) VALUES (CONCAT(fullname,'(Chatbot)'),'This is bot application' ) ;
    SELECT LAST_INSERT_ID() INTO appid; 
	INSERT INTO eb_bots (name, url,fullname,app_id, welcome_msg, created_by, created_at) 
    SELECT name, url,fullname, appid, welcome_msg , uid, NOW();
    SELECT LAST_INSERT_ID() INTO returnid;
    SET _botid = CONCAT_WS('-', solid, returnid, url);
	UPDATE eb_bots EB SET EB.botid = _botid WHERE EB.id=returnid ;
    SELECT _botid INTO insertedbotid; 
END IF;

RETURN insertedbotid;

END 