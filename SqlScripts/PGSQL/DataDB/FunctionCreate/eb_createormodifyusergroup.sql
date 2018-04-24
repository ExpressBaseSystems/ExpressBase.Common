-- FUNCTION: public.eb_createormodifyusergroup(integer, integer, text, text, integer[])

-- DROP FUNCTION public.eb_createormodifyusergroup(integer, integer, text, text, integer[]);

CREATE OR REPLACE FUNCTION public.eb_createormodifyusergroup(
	_userid integer,
	_id integer,
	_name text,
	_description text,
	_users integer[])
    RETURNS TABLE(gid integer) 
    LANGUAGE 'plpgsql'

    
AS $BODY$

DECLARE gid integer;
BEGIN
gid:=_id;
IF _id > 0 THEN

UPDATE eb_usergroup SET name=_name, description=_description WHERE id=_id;
INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid,_id,_userid,NOW() FROM 
   UNNEST(array(SELECT unnest(_users) except 
		SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')))) AS userid;
UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE userid IN(
	SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) except 
	SELECT UNNEST(_users));

ELSE

INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F') returning id INTO gid;
INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid, gid,_userid,NOW() 
    FROM UNNEST(_users) AS userid;

END IF;

RETURN QUERY SELECT gid;

END;

$BODY$;

ALTER FUNCTION public.eb_createormodifyusergroup(integer, integer, text, text, integer[])
    OWNER TO postgres;

