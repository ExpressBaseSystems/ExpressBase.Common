
-- FUNCTION: public.eb_getpermissions(integer[])

-- DROP FUNCTION public.eb_getpermissions(integer[]);

CREATE OR REPLACE FUNCTION public.eb_getpermissions(
	roles integer[])
    RETURNS TABLE(permissions text) 
    LANGUAGE 'plpgsql'

    
AS $BODY$

BEGIN
	RETURN QUERY 
SELECT 
   array_to_string(array_agg(_per.permissionname), ',') 
FROM 
	eb_role2permission _per
WHERE role_id = ANY(roles) AND eb_del='F';
END;

$BODY$;

ALTER FUNCTION public.eb_getpermissions(integer[])
    OWNER TO postgres;

