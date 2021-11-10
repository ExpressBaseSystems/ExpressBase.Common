create or replace FUNCTION eb_create_or_update_role2loc(
	role_id NUMBER,
	userid NUMBER,
	locations VARCHAR2) 
    RETURN NUMBER AS   
    PRAGMA AUTONOMOUS_TRANSACTION; 
      u_id NUMBER; 

BEGIN  
    UPDATE eb_role2location 
        SET eb_del = 'T',eb_revokedat = SYSTIMESTAMP,eb_revokedby = userid     
        WHERE locationid IN(SELECT TO_CHAR(locationid) from eb_role2location WHERE roleid = role_id AND eb_del = 'F' MINUS 
            SELECT regexp_substr(locations,'[^,]+', 1, level) from dual CONNECT BY regexp_substr(locations, '[^,]+', 1, level) is not null);
    IF locations IS NOT NULL THEN 
        INSERT INTO eb_role2location (locationid, roleid, eb_createdby, eb_createdat) 
            SELECT users, role_id, userid, SYSTIMESTAMP 
                FROM (SELECT regexp_substr(locations,'[^,]+', 1, level)  AS users from dual CONNECT BY regexp_substr(locations, '[^,]+', 1, level) is not null MINUS 
                    SELECT TO_CHAR(locationid) from eb_role2location WHERE roleid = role_id and eb_del = 'F');
    END IF;
    COMMIT;
    RETURN 0;
END;