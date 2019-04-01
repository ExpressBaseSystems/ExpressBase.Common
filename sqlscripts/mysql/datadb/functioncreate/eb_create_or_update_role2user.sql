CREATE PROCEDURE eb_create_or_update_role2user(in roleid integer,
    in userid integer,
    in usersid text,
    out out_r integer)
BEGIN
declare a integer;
drop temporary table if exists temp_array_table;
drop temporary table if exists usersid_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
	CALL STR_TO_TBL(usersid);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS usersid_tmp SELECT `value` FROM temp_array_table;
UPDATE eb_role2user 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = userid 
    WHERE 
        role_id = roleid AND eb_del = 'F' AND user_id IN(select * from (
            select user_id from eb_role2user WHERE role_id = roleid and eb_del = 'F' and user_id not in 
       (SELECT `value` from usersid_tmp))as q) ;

    INSERT INTO eb_role2user 
        (user_id, role_id, createdby, createdat) 
    SELECT 
        `value`, roleid, userid, NOW() 
        
    FROM (select `value` from usersid_tmp 
     where `value` not in(select user_id from eb_role2user WHERE role_id = roleid and eb_del = 'F')) AS users;
set a=0;
select a into out_r;
END