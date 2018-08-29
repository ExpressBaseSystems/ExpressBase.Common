CREATE OR REPLACE FUNCTION public.eb_currval(seq text)
RETURNS integer
LANGUAGE 'plpgsql'
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






