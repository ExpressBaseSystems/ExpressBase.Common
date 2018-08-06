create or replace FUNCTION eb_create_or_update_role2user(
	roleid NUMBER,
	userid NUMBER,
	usersid VARCHAR2)
    RETURN NUMBER AS   
    PRAGMA AUTONOMOUS_TRANSACTION;
      u_id NUMBER; 

BEGIN  
    UPDATE eb_role2user 
        SET eb_del = 'T',revokedat = SYSTIMESTAMP,revokedby = userid     
        WHERE user_id IN(SELECT TO_CHAR(user_id) from eb_role2user WHERE role_id = roleid AND eb_del = 'F' MINUS 
            SELECT regexp_substr(usersid,'[^,]+', 1, level) from dual CONNECT BY regexp_substr(usersid, '[^,]+', 1, level) is not null);
    IF usersid IS NOT NULL THEN 
        INSERT INTO eb_role2user (user_id, role_id, createdby, createdat) 
            SELECT users, roleid, userid, SYSTIMESTAMP 
                FROM (SELECT regexp_substr(usersid,'[^,]+', 1, level)  AS users from dual CONNECT BY regexp_substr(usersid, '[^,]+', 1, level) is not null MINUS 
                    SELECT TO_CHAR(user_id) from eb_role2user WHERE role_id = roleid and eb_del = 'F');
    END IF;
    COMMIT;
    RETURN 0;
END;