CREATE OR REPLACE FUNCTION public.eb_currval(seq text)
RETURNS integer
LANGUAGE 'plpgsql'

AS $BODY$

DECLARE curval integer; 

BEGIN
SELECT currval(seq) into curval;
RETURN curval;
EXCEPTION WHEN OTHERS THEN
RETURN 0;
END;

$BODY$;