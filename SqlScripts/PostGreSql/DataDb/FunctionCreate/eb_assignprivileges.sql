-- FUNCTION: public.eb_assignprivileges(text, text, text, text, text, text)

-- DROP FUNCTION public.eb_assignprivileges(text, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_assignprivileges(
	unameadmin text,
	passwordadmin text,
	unamerouser text,
	passwordro text,
	unamerwuser text,
	passwordrw text)
    RETURNS text
    LANGUAGE 'plpgsql'

AS $BODY$

 
BEGIN
   EXECUTE 'CREATE ROLE '|| unameadmin ||' WITH LOGIN PASSWORD '''|| passwordAdmin ||''' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION  VALID UNTIL ''infinity''';
 
   EXECUTE 'CREATE ROLE '|| unameROUser ||' WITH LOGIN PASSWORD '''|| passwordRO ||''' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION  VALID UNTIL ''infinity''';
   
   EXECUTE 'CREATE ROLE '|| unameRWUser ||' WITH LOGIN PASSWORD '''|| passwordRW ||''' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION  VALID UNTIL ''infinity''';
      
   RETURN 'T';
END;

$BODY$;

ALTER FUNCTION public.eb_assignprivileges(text, text, text, text, text, text)
    OWNER TO postgres;

