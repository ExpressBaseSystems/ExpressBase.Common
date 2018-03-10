create or replace FUNCTION eb_createormodifyuserandroles(
	in_userid NUMBER,
	in_id NUMBER,
	in_fullname VARCHAR2,
	in_nickname VARCHAR2,
	in_email VARCHAR2,
	in_pwd VARCHAR2,
	in_dob DATE,
	in_sex VARCHAR2,
	in_alternateemail VARCHAR2,
	in_phnoprimary VARCHAR2,
	in_phnosecondary VARCHAR2,
	in_landline VARCHAR2,
	in_phextension VARCHAR2,
	in_fbid VARCHAR2,
	in_fbname VARCHAR2,
	in_roles_temp VARCHAR2,
	in_group_temp VARCHAR2,
    in_statusid NUMBER,
	in_hide VARCHAR2,
    in_anonymoususerid NUMBER)
    RETURN NUMBER IS
    PRAGMA AUTONOMOUS_TRANSACTION;
      out_usid NUMBER; 
      out_statusid NUMBER;
BEGIN
   IF in_statusid > 99 THEN
	 out_statusid := in_statusid - 100;
    INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (in_id, out_statusid, in_userid, SYSTIMESTAMP);
   END IF;

   IF in_id > 1 THEN
           UPDATE eb_users SET fullname = in_fullname, nickname = in_nickname, email= in_email, dob= in_dob, sex= in_sex, alternateemail= in_alternateemail, phnoprimary= in_phnoprimary, phnosecondary= in_phnosecondary, landline= in_landline, phextension= in_phextension, fbid= in_fbid, fbname= in_fbname, statusid= in_statusid, hide= in_hide WHERE id = in_id;

           INSERT INTO eb_role2user(role_id,user_id,createdby,createdat) SELECT roleid, in_id,in_userid,SYSTIMESTAMP FROM 
           (SELECT regexp_substr(in_roles_temp,'[^,]+', 1, level) AS roleid from dual
             CONNECT BY regexp_substr(in_roles_temp, '[^,]+', 1, level) is not null MINUS 
                SELECT TO_CHAR(role_id) from eb_role2user WHERE user_id = in_id AND eb_del = 'F');

           UPDATE eb_role2user SET eb_del = 'T',revokedby = in_userid,revokedat = SYSTIMESTAMP WHERE role_id IN(
                SELECT TO_CHAR(role_id) from eb_role2user WHERE user_id = in_id AND eb_del = 'F' MINUS 
                SELECT regexp_substr(in_roles_temp,'[^,]+', 1, level) from dual
             CONNECT BY regexp_substr(in_roles_temp, '[^,]+', 1, level) is not null);

           INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT in_id,groupid,in_userid,SYSTIMESTAMP FROM 
            (SELECT regexp_substr(in_group_temp,'[^,]+', 1, level) AS groupid from dual
             CONNECT BY regexp_substr(in_group_temp, '[^,]+', 1, level) is not null MINUS 
                SELECT TO_CHAR(groupid) from eb_user2usergroup WHERE userid = in_id AND eb_del = 'F');

           UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = in_userid,revokedat = SYSTIMESTAMP WHERE groupid IN(
                SELECT TO_CHAR(groupid) from eb_user2usergroup WHERE userid = in_id AND eb_del = 'F' MINUS 
                SELECT regexp_substr(in_group_temp,'[^,]+', 1, level) from dual
             CONNECT BY regexp_substr(in_group_temp, '[^,]+', 1, level) is not null);       
        ELSE        
           INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide) 
            VALUES (in_fullname, in_nickname, in_email, in_pwd, in_dob, in_sex, in_alternateemail, in_phnoprimary, in_phnosecondary, in_landline, in_phextension, in_fbid, in_fbname, in_userid, SYSTIMESTAMP, in_statusid, in_hide) RETURNING id INTO out_usid;

           INSERT INTO eb_role2user (role_id,user_id,createdby,createdat) SELECT roleid, out_usid,in_userid,SYSTIMESTAMP 
             FROM (SELECT regexp_substr(in_roles_temp,'[^,]+', 1, level) AS roleid from dual
             CONNECT BY regexp_substr(in_roles_temp, '[^,]+', 1, level) is not null);

           INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT out_usid, groupid,in_userid,SYSTIMESTAMP 
             FROM (SELECT regexp_substr(in_group_temp,'[^,]+', 1, level) AS groupid from dual
             CONNECT BY regexp_substr(in_group_temp, '[^,]+', 1, level) is not null);          
        END IF;

        IF in_id > 0 THEN
            UPDATE eb_usersanonymous SET modifiedby = in_userid, modifiedat = SYSTIMESTAMP, ebuserid = out_usid
                WHERE id = in_anonymoususerid;
	    END IF;
        COMMIT;
        RETURN out_usid;
END;