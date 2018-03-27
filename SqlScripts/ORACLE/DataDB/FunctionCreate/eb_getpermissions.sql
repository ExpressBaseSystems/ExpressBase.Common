create or replace FUNCTION eb_permissions(
	in_roles VARCHAR2)
    RETURN returnpermission_tbl as permissiontbl  returnpermission_tbl;

BEGIN     
    SELECT   
    	returnpermission_obj(LISTAGG(permissionname,',') within group(order by permissionname)) BULK COLLECT INTO permissiontbl  FROM 
        eb_role2permission 
    WHERE role_id = ANY(  SELECT regexp_substr(in_roles,'[^,]+', 1, level) from dual
             CONNECT BY regexp_substr(in_roles, '[^,]+', 1, level) is not null);	
    RETURN permissiontbl;
END;