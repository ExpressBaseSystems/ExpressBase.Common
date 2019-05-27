CREATE OR REPLACE FUNCTION public.cur_val(
	text)
    RETURNS integer
    LANGUAGE 'plpgsql'
    COST 100.0

AS $function$

DECLARE seq ALIAS FOR $1;
DECLARE result integer;
BEGIN
result := 0;
EXECUTE 'SELECT currval(''' || seq || ''')' INTO result;
RETURN result;
EXCEPTION WHEN OTHERS THEN
--do nothing
RETURN result;
END;

$function$;

