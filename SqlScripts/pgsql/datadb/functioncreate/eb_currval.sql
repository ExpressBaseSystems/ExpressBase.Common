-- FUNCTION: public.eb_currval(text)

-- DROP FUNCTION public.eb_currval(text);

CREATE OR REPLACE FUNCTION public.eb_currval(
	seq text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$
DECLARE curval integer; exce text;
BEGIN
SELECT currval(seq) into curval;
RETURN curval;
EXCEPTION WHEN OTHERS THEN
	IF SQLSTATE = '55000' THEN
    	RETURN 0;      
    ELSE
    	RAISE EXCEPTION '%', SQLERRM;
    END IF;
END;

$BODY$;

ALTER FUNCTION public.eb_currval(text)
    OWNER TO postgres;