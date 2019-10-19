-- FUNCTION: public.eb_security_usergroup(integer, integer, text, text, text, text, text)

-- DROP FUNCTION public.eb_security_usergroup(integer, integer, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_security_usergroup(
	_userid integer,
	_id integer,
	_name text,
	_description text,
	_users text,
	_constraints_add text,
	_constraints_del text)
    RETURNS TABLE(gid integer) 
    LANGUAGE 'plpgsql'
    
AS $BODY$

DECLARE 
	gid integer;
	users INTEGER[];
BEGIN
gid:=_id;
users := string_to_array(_users, ',')::integer[];

IF _id > 0 THEN
	UPDATE eb_usergroup SET name=_name, description=_description WHERE id=_id;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid,_id,_userid,NOW() FROM 
   		UNNEST(array(SELECT unnest(users) except 
			SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')))) AS userid;
	UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE groupid = _id AND eb_del = 'F' AND userid IN(
		SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) except 
		SELECT UNNEST(users));	
ELSE
	INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F') returning id INTO gid;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid, gid,_userid,NOW() 
    	FROM UNNEST(users) AS userid;
END IF;
PERFORM eb_security_constraints(_userid, gid, _constraints_add, _constraints_del);
					  
RETURN QUERY SELECT gid;
END;

$BODY$;