create or replace FUNCTION eb_create_or_update_role2role(
	roleid NUMBER,
	userid NUMBER,
	dependantroles VARCHAR2)
    RETURN NUMBER AS    
      rids NUMBER; 

BEGIN  
  UPDATE eb_role2role 
    SET 
        eb_del = 'T',revokedat = SYSTIMESTAMP,revokedby = userid 
    WHERE 
        role2_id IN(
           SELECT TO_CHAR(role2_id) FROM eb_role2role WHERE role1_id = roleid and eb_del = 'F'
        MINUS 
            SELECT regexp_substr(dependantroles,'[^,]+', 1, level) from dual
             CONNECT BY regexp_substr(dependantroles, '[^,]+', 1, level) is not null);

    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat)
    SELECT 
        dominants, roleid, userid, SYSTIMESTAMP 

    FROM (SELECT regexp_substr(dependantroles,'[^,]+', 1, level)  AS dominants from dual
             CONNECT BY regexp_substr(dependantroles, '[^,]+', 1, level) is not null
        MINUS 
        SELECT TO_CHAR(role2_id) from eb_role2role WHERE role1_id = roleid and eb_del = 'F');      
 RETURN 0;
END;

