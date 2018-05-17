-- FUNCTION: public.eb_createormodifyusergroup(integer, integer, text, text, text)

-- DROP FUNCTION public.eb_createormodifyusergroup(integer, integer, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_createormodifyusergroup(
	_userid integer,
	_id integer,
	_name text,
	_description text,
	_users text)
    RETURNS TABLE(gid integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE gid integer;
users INTEGER[];
BEGIN
gid:=_id;
users := string_to_array(_users, ',')::integer[];
IF _id > 0 THEN

UPDATE eb_usergroup SET name=_name, description=_description WHERE id=_id;
INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid,_id,_userid,NOW() FROM 
   UNNEST(array(SELECT unnest(users) except 
		SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')))) AS userid;
UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE userid IN(
	SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) except 
	SELECT UNNEST(users));

ELSE

INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F') returning id INTO gid;
INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid, gid,_userid,NOW() 
    FROM UNNEST(users) AS userid;

END IF;

RETURN QUERY SELECT gid;

END;

$BODY$;

ALTER FUNCTION public.eb_createormodifyusergroup(integer, integer, text, text, text)
    OWNER TO postgres;



