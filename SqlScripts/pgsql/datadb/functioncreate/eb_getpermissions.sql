-- FUNCTION: public.eb_getpermissions(integer[])

-- DROP FUNCTION public.eb_getpermissions(integer[]);

CREATE OR REPLACE FUNCTION public.eb_getpermissions(
	roles integer[])
    RETURNS TABLE(permissions text) 
    LANGUAGE 'plpgsql'
    
AS $BODY$

BEGIN
	RETURN QUERY 
	
	SELECT array_to_string(array_agg(_per.permissionname || ':' || _loc.locationid), ',') FROM eb_role2permission _per, eb_role2location _loc
		WHERE _per.role_id = _loc.roleid AND _per.role_id = ANY(roles) AND _per.eb_del='F' AND _loc.eb_del='F';
		
END;

$BODY$;




