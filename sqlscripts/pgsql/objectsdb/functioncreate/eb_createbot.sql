-- FUNCTION: public.eb_createbot(text, text, text, text, text, integer, integer)

-- DROP FUNCTION public.eb_createbot(text, text, text, text, text, integer, integer);

CREATE OR REPLACE FUNCTION public.eb_createbot(
	_sol_id text,
	_name text,
	_fullname text,
	_url text,
	_wel_msg text,
	_userid integer,
	_id integer)
    RETURNS text
    LANGUAGE 'plpgsql'

    
AS $BODY$

DECLARE _botid text; insertedbotid text; returnid integer; appid integer;

BEGIN	

IF (_id > 0) THEN
   
	UPDATE eb_bots SET name=_name, fullname = _fullname, url=_url, welcome_msg=_wel_msg, modified_by=_userid, modified_at=NOW() WHERE id=_id RETURNING botid,app_id INTO insertedbotid,appid;
    UPDATE eb_applications SET applicationname = CONCAT(_fullname,'(Chatbot)') WHERE id = appid;
ELSE
    INSERT INTO eb_applications (applicationname, description) VALUES (CONCAT(_fullname,'(Chatbot)'),'This is bot application' ) RETURNING id INTO appid; 
	
    INSERT INTO eb_bots (name, url,fullname,app_id, welcome_msg, created_by, created_at) 
    SELECT _name, _url,_fullname, appid, _wel_msg , _userid, NOW() RETURNING id INTO returnid;

	_botid := CONCAT_WS('-', _sol_id, returnid, _url);
	UPDATE eb_bots SET botid = _botid WHERE id=returnid RETURNING botid INTO insertedbotid;
    
    
END IF;

RETURN insertedbotid; 	

END;

$BODY$;

