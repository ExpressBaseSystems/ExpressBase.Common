CREATE FUNCTION eb_createbot(_sol_id text,
    _name text,
    _fullname text,
    _url text,
    _wel_msg text,
    _userid integer,
    _id integer) RETURNS text CHARSET latin1
BEGIN
DECLARE _botid text;
DECLARE insertedbotid text;
DECLARE returnid integer;
DECLARE appid integer;

IF (_id > 0) THEN
   	UPDATE eb_bots SET name=_name, fullname = _fullname, url=_url, welcome_msg=_wel_msg, modified_by=_userid, modified_at=NOW(),botid=(select @botid1:=botid),app_id=(select @app_id1:=app_id)  WHERE id=_id; 
	select @botid1,@app_id1
    INTO insertedbotid,appid;
    UPDATE eb_applications SET applicationname = CONCAT(_fullname,'(Chatbot)') WHERE id = appid;
ELSE
    INSERT INTO eb_applications (applicationname, description) VALUES (CONCAT(_fullname,'(Chatbot)'),'This is bot application' ) ;
    select last_insert_id() INTO appid; 
	INSERT INTO eb_bots (name, url,fullname,app_id, welcome_msg, created_by, created_at) 
    SELECT _name, _url,_fullname, appid, _wel_msg , _userid, NOW();
    select last_insert_id() INTO returnid;
    set _botid = CONCAT_WS('-', _sol_id, returnid, _url);
	UPDATE eb_bots SET botid = (select @b:=_botid) WHERE id=returnid ;
    select @b INTO insertedbotid; 
end if;
RETURN insertedbotid;
END