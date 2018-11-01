-- FUNCTION: public.eb_createormodifyuserandroles(integer, integer, text, text, text, text, date, text, text, text, text, text, text, text, text, text, text, integer, text, integer, text)

-- DROP FUNCTION public.eb_createormodifyuserandroles(integer, integer, text, text, text, text, date, text, text, text, text, text, text, text, text, text, text, integer, text, integer, text);

CREATE OR REPLACE FUNCTION public.eb_createormodifyuserandroles(
	_userid integer,
	_id integer,
	_fullname text,
	_nickname text,
	_email text,
	_pwd text,
	_dob date,
	_sex text,
	_alternateemail text,
	_phnoprimary text,
	_phnosecondary text,
	_landline text,
	_phextension text,
	_fbid text,
	_fbname text,
	_roles_temp text,
	_group_temp text,
	_statusid integer,
	_hide text,
	_anonymoususerid integer,
	_preferences text)
    RETURNS TABLE(uid integer) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

DECLARE uid integer; _roles integer[]; _group integer[];
BEGIN
_roles := string_to_array(_roles_temp, ',');
_group := string_to_array(_group_temp, ',');

IF _id > 1 THEN
	IF _statusid > 99 THEN
		_statusid = _statusid - 100;
	ELSE
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (_id, _statusid, _userid, NOW());
	END IF;

   UPDATE eb_users SET fullname= _fullname, nickname=_nickname, dob=_dob, sex=_sex, alternateemail=_alternateemail, phnoprimary=_phnoprimary, phnosecondary=_phnosecondary, landline=_landline, phextension=_phextension, fbid=_fbid, fbname=_fbname, statusid=_statusid, hide=_hide, preferencesjson=_preferences WHERE id = _id;
			
   INSERT INTO eb_role2user(role_id,user_id,createdby,createdat) SELECT roleid,_id,_userid,NOW() FROM 
   UNNEST(array(SELECT unnest(_roles) except 
		SELECT UNNEST(array(SELECT role_id from eb_role2user WHERE user_id = _id AND eb_del = 'F')))) AS roleid;
   UPDATE eb_role2user SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE user_id = _id AND eb_del = 'F' AND role_id IN(
		SELECT UNNEST(array(SELECT role_id from eb_role2user WHERE user_id = _id AND eb_del = 'F')) except 
		SELECT UNNEST(_roles));

   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT _id,groupid,_userid,NOW() FROM 
   UNNEST(array(SELECT unnest(_group) except 
		SELECT UNNEST(array(SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F')))) AS groupid;
   UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE userid = _id AND eb_del = 'F' AND groupid IN(
		SELECT UNNEST(array(SELECT groupid from eb_user2usergroup WHERE userid = _id AND eb_del = 'F')) except 
		SELECT UNNEST(_group));

ELSE

   INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
    VALUES (_fullname, _nickname, _email, _pwd, _dob, _sex, _alternateemail, _phnoprimary, _phnosecondary, _landline, _phextension, _fbid, _fbname, _userid, NOW(), _statusid, _hide, _preferences) RETURNING id INTO uid;
      
   INSERT INTO eb_role2user (role_id,user_id,createdby,createdat) SELECT roleid, uid,_userid,NOW() 
    FROM UNNEST(_roles) AS roleid;
    
   INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT uid, groupid,_userid,NOW() 
    FROM UNNEST(_group) AS groupid;
	
	IF _id > 0 THEN
		UPDATE eb_usersanonymous SET modifiedby = _userid, modifiedat = NOW(), ebuserid = uid
			WHERE id = _anonymoususerid;
	END IF;
	
	INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (uid, _statusid, _userid, NOW());
   
END IF;
  IF _userid > 0 THEN
	RETURN QUERY
    	SELECT uid;
  END IF;
END;

$BODY$;

ALTER FUNCTION public.eb_createormodifyuserandroles(integer, integer, text, text, text, text, date, text, text, text, text, text, text, text, text, text, text, integer, text, integer, text)
    OWNER TO postgres;

