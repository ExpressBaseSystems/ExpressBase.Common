create or replace FUNCTION eb_createormodifyusergroup(
	in_userid NUMBER,
	in_id NUMBER,
	in_name VARCHAR2,
	in_description VARCHAR2,
	in_users VARCHAR2)
    RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
      out_gid NUMBER; 
BEGIN
      out_gid := in_id;
     IF in_id > 0 THEN

            UPDATE eb_usergroup SET name=in_name, description=in_description WHERE id = in_id;
            INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid,in_id,in_userid,SYSTIMESTAMP FROM 
             (SELECT regexp_substr(in_users,'[^,]+', 1, level) AS userid from dual
                 CONNECT BY regexp_substr(in_users, '[^,]+', 1, level) is not null  MINUS 
                    SELECT TO_CHAR(userid) from eb_user2usergroup WHERE groupid = in_id AND eb_del = 'F');

            UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = in_userid,revokedat = SYSTIMESTAMP WHERE userid IN(
                SELECT TO_CHAR(userid) from eb_user2usergroup WHERE groupid = in_id AND eb_del = 'F' MINUS 
                SELECT regexp_substr(in_users,'[^,]+', 1, level) from dual
                 CONNECT BY regexp_substr(in_users, '[^,]+', 1, level) is not null);

        ELSE

            INSERT INTO eb_usergroup (name,description,eb_del) VALUES (in_name,in_description,'F') returning id INTO out_gid;

            INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT userid, out_gid,in_userid,SYSTIMESTAMP 
                FROM (SELECT regexp_substr(in_users,'[^,]+', 1, level) AS userid from dual
                 CONNECT BY regexp_substr(in_users, '[^,]+', 1, level) is not null);
        END IF;
        COMMIT;
        RETURN out_gid;
END;