-- FUNCTION: public.eb_createormodifyusergroup(integer, integer, text, text, text, text, text, text, text)

-- DROP FUNCTION public.eb_createormodifyusergroup(integer, integer, text, text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_createormodifyusergroup(
	_userid integer,
	_id integer,
	_name text,
	_description text,
	_users text,
	_ipconstr_new text,
	_ipconstr_old text,
	_dtconstr_new text,
	_dtconstr_old text)
    RETURNS TABLE(gid integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE 
	gid integer;
	users INTEGER[];
	ipnew TEXT[];
	dtnew TEXT[];
	ipdel INTEGER[];
	dtdel INTEGER[];
BEGIN
gid:=_id;
users := string_to_array(_users, ',')::integer[];
ipnew := string_to_array(_ipconstr_new, '$$')::text[];
dtnew := string_to_array(_dtconstr_new, '$$')::text[];
ipdel := string_to_array(_ipconstr_old, ',')::integer[];
dtdel := string_to_array(_dtconstr_old, ',')::integer[];

IF _id > 0 THEN
	UPDATE eb_usergroup SET name=_name, description=_description WHERE id=_id;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid,_id,_userid,NOW() FROM 
   		UNNEST(array(SELECT unnest(users) except 
			SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')))) AS userid;
	UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE groupid = _id AND eb_del = 'F' AND userid IN(
		SELECT UNNEST(array(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) except 
		SELECT UNNEST(users));
	
	UPDATE eb_constraints_ip SET eb_del = 'T', eb_revoked_by = _userid, eb_revoked_at = NOW()
		WHERE usergroup_id = _id AND eb_del = 'F' AND id IN(SELECT UNNEST(ipdel));
		
	UPDATE eb_constraints_datetime SET eb_del = 'T', eb_revoked_by = _userid, eb_revoked_at = NOW()
		WHERE usergroup_id = _id AND eb_del = 'F' AND id IN(SELECT UNNEST(dtdel));

ELSE

	INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F') returning id INTO gid;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid, gid,_userid,NOW() 
    	FROM UNNEST(users) AS userid;

END IF;

INSERT INTO eb_constraints_ip(usergroup_id, ip, description, eb_created_by, eb_created_at, eb_del)
	SELECT gid, nwip, nwdesc, _userid, NOW(), 'F'
		FROM UNNEST (string_to_array(ipnew[1], ',')::text[], string_to_array(ipnew[2], ',')::text[]) AS temp(nwip, nwdesc);

INSERT INTO eb_constraints_datetime(usergroup_id, title, description, type, start_datetime, end_datetime, days_coded, eb_created_by, eb_created_at, eb_del)
	SELECT gid, nwtitle, nwdesc, nwtype, nwstart, nwend, nwdays, _userid, NOW(), 'F' 
		FROM UNNEST (string_to_array(dtnew[1], ',')::text[],
					string_to_array(dtnew[2], ',')::text[],
					string_to_array(dtnew[3], ',')::integer[],
					string_to_array(dtnew[4], ',')::timestamp without time zone[],
					string_to_array(dtnew[5], ',')::timestamp without time zone[],
					string_to_array(dtnew[6], ',')::integer[]
					) AS temp(nwtitle, nwdesc, nwtype, nwstart, nwend, nwdays);

RETURN QUERY SELECT gid;

END;

$BODY$;

ALTER FUNCTION public.eb_createormodifyusergroup(integer, integer, text, text, text, text, text, text, text)
    OWNER TO postgres;

