CREATE FUNCTION eb_createbot(solid text,
    name text,
    fullname text,
    url text,
    welcome_msg text,
    uid integer,
    botid integer) RETURNS text CHARSET latin1
BEGIN
DECLARE _botid text;
DECLARE insertedbotid text;
DECLARE returnid integer;
DECLARE appid integer;

IF (botid > 0) THEN
   	UPDATE eb_bots EB SET EB.name=name, EB.fullname = fullname, EB.url=url, EB.welcome_msg=welcome_msg, EB.modified_by=uid, EB.modified_at=NOW(), EB.botid=(select @botid:=EB.botid),EB.app_id=(select @app_id:=EB.app_id)  WHERE EB.id=botid; 
	SELECT @botid,@app_id
    INTO insertedbotid,appid;
    UPDATE eb_applications EA SET EA.applicationname = CONCAT(fullname,'(Chatbot)') WHERE EA.id = appid;
ELSE
    INSERT INTO eb_applications (applicationname, description) VALUES (CONCAT(fullname,'(Chatbot)'),'This is bot application' ) ;
    SELECT last_insert_id() INTO appid; 
	INSERT INTO eb_bots (name, url,fullname,app_id, welcome_msg, created_by, created_at) 
    SELECT name, url,fullname, appid, welcome_msg , uid, NOW();
    SELECT last_insert_id() INTO returnid;
    SET _botid = CONCAT_WS('-', solid, returnid, url);
	UPDATE eb_bots EB SET EB.botid = _botid WHERE EB.id=returnid ;
    SELECT _botid INTO insertedbotid; 
end if;
RETURN insertedbotid;
END