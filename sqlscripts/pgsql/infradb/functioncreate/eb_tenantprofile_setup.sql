-- FUNCTION: public.eb_tenantprofile_setup(text, text, text, text, text)

-- DROP FUNCTION public.eb_tenantprofile_setup(text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_tenantprofile_setup(
	_firstname text,
	_company text,
	_country text,
	_pwd text,
	_email text)
    RETURNS integer
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE    
    _id integer;
BEGIN
UPDATE eb_users SET fullname =_firstname,company=_company,country=_country,pwd=_pwd 
WHERE email=_email RETURNING id INTO _id;
IF _id > 0 THEN
INSERT INTO eb_role2user(role_id,user_id,createdby,createdat) VALUES(2,_id,_id,NOW());
end if;
RETURN _id;
END;

$BODY$;

ALTER FUNCTION public.eb_tenantprofile_setup(text, text, text, text, text)
    OWNER TO postgres;

