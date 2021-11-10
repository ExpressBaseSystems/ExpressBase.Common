create or replace FUNCTION eb_getpermissions(
	in_roles VARCHAR2)
    RETURN returnpermission_tbl as permissiontbl  returnpermission_tbl;

BEGIN     
    SELECT   
    	returnpermission_obj(LISTAGG(per.permissionname || ':' || loc.locationid,',') within group(order by permissionname)) BULK COLLECT INTO permissiontbl  
	FROM         
		eb_role2permission per,eb_role2location loc
    WHERE 
		per.eb_del = 'F' AND per.role_id = ANY(  SELECT regexp_substr(in_roles,'[^,]+', 1, level) from dual CONNECT BY regexp_substr(in_roles, '[^,]+', 1, level) is not null)
		AND per.role_id = loc.roleid AND loc.eb_del='F';
	    
	RETURN permissiontbl;
END;