-- FUNCTION: public.eb_revokedbaccess2user(text, text)

-- DROP FUNCTION public.eb_revokedbaccess2user(text, text);

CREATE OR REPLACE FUNCTION public.eb_revokedbaccess2user(
	username text,
	dbname text)
    RETURNS boolean
    LANGUAGE 'plpgsql'    

AS $BODY$

DECLARE dbs text;
BEGIN
  
    FOR dbs IN (SELECT datname FROM pg_database WHERE datistemplate = false)
    LOOP
  	  EXECUTE 'REVOKE CONNECT ON DATABASE "' || dbs || '" FROM ' || username;
  	END LOOP;
    EXECUTE 'GRANT CONNECT ON DATABASE "' || dbname || '" TO ' || username;
    return true;
END;

$BODY$;




