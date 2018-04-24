create or replace FUNCTION eb_create_or_update_role(
	application_id NUMBER,
	rolename VARCHAR2,
	roledesc VARCHAR2,
	isanonym CHAR,
	userid NUMBER,
	permissions VARCHAR2,
	roleid NUMBER DEFAULT 0)
    RETURN NUMBER AS    
      rid NUMBER; 


    BEGIN  
    IF roleid = 0 THEN   
        INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous) VALUES (rolename,application_id,roledesc,isanonym) RETURNING ID INTO rid;
        DBMS_OUTPUT.PUT_LINE(rid);
    ELSE
        UPDATE eb_roles SET role_name= rolename, applicationid= application_id, description = roledesc, is_anonymous = isanonym WHERE id = roleid;
        rid := roleid;
    END IF;

    UPDATE eb_role2permission 
    SET 
        eb_del = 'T',revokedat = SYSTIMESTAMP,revokedby = userid 
    WHERE 
        permissionname IN(
            select permissionname from eb_role2permission WHERE role_id = roleid AND eb_del = 'F' 
        MINUS 
            SELECT regexp_substr(permissions,'[^,]+', 1, level) from dual
             CONNECT BY regexp_substr(permissions, '[^,]+', 1, level) is not null);

    INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
        permission, rid, userid, SYSTIMESTAMP, 
        regexp_substr(permission, '[^-]+', 1, 3),
        regexp_substr(permission, '[^-]+', 1, 4) 
        FROM (SELECT regexp_substr(permissions,'[^,]+', 1, level) as permission from dual
             CONNECT BY regexp_substr(permissions, '[^,]+', 1, level) is not null
        MINUS 
        SELECT permissionname from eb_role2permission WHERE role_id = roleid AND eb_del = 'F');
RETURN rid;
    END;

