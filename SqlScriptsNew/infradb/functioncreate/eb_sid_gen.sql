-- FUNCTION: public.eb_sid_gen()

-- DROP FUNCTION public.eb_sid_gen();

CREATE OR REPLACE FUNCTION public.eb_sid_gen(
	)
    RETURNS text
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE
source_string text := 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
sid text;
curr_time text;
eb_sid text;
BEGIN
	SELECT INTO sid array_to_string(array(select substr(source_string,((random()*(62-1)+1)::integer),1) from generate_series(1,10)),'');		
	SELECT INTO curr_time to_char(now(), 'YYYYMMDDHH12MISS');
	eb_sid = concat('ebdb',sid,curr_time);
RETURN lOWER(eb_sid);
END;

$BODY$;

ALTER FUNCTION public.eb_sid_gen()
    OWNER TO postgres;

