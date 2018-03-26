-- FUNCTION: public.eb_assignprivileges(text, text, text)

-- DROP FUNCTION public.eb_assignprivileges(text, text, text);

CREATE OR REPLACE FUNCTION public.eb_assignprivileges(
	unameadmin text,
	unamerouser text,
	unamerwuser text)
    RETURNS TABLE(passadmin text, passro text, passrw text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

   DECLARE
   passwordAdmin TEXT := '';
   DECLARE passwordRO TEXT := '';
   DECLARE passwordRW TEXT := '';
   chars text[] := '{0,1,2,3,4,5,6,7,8,9,A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z,a,b,c,d,e,f,g,h,i,j,k,l,m,n,o,p,q,r,s,t,u,v,w,x,y,z}';
   i integer := 0;
 
BEGIN
   
    for i in 1..8 loop
        passwordAdmin := passwordAdmin || chars[1+random()*(array_length(chars, 1)-1)];
        passwordRO := passwordRO || chars[1+random()*(array_length(chars, 1)-1)];
        passwordRW := passwordRW || chars[1+random()*(array_length(chars, 1)-1)];
    end loop;
   EXECUTE 'CREATE ROLE '|| unameadmin ||' WITH LOGIN PASSWORD '''|| passwordAdmin ||''' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION  VALID UNTIL ''infinity''';
 
   EXECUTE 'CREATE ROLE '|| unameROUser ||' WITH LOGIN PASSWORD '''|| passwordRO ||''' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION  VALID UNTIL ''infinity''';
   
   EXECUTE 'CREATE ROLE '|| unameRWUser ||' WITH LOGIN PASSWORD '''|| passwordRW ||''' NOSUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION  VALID UNTIL ''infinity''';
      
   RETURN QUERY SELECT passwordAdmin,passwordRO,passwordRW ;
END;


$BODY$;

ALTER FUNCTION public.eb_assignprivileges(text, text, text)
    OWNER TO postgres;


