CREATE PROCEDURE eb_create_or_update_role2user(in rid integer,
    in createdby integer,
    in users_str text
   -- ,out r1 integer
    )
BEGIN
declare a integer;
drop temporary table if exists temp_array_table;
drop temporary table if exists usersid_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
	CALL STR_TO_TBL(users_str);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS usersid_tmp SELECT `value` FROM temp_array_table;
UPDATE eb_role2user er2u
    SET 
        er2u.eb_del = 'T',er2u.revokedat = NOW(),er2u.revokedby = createdby 
    WHERE 
        er2u.role_id = rid AND er2u.eb_del = 'F' AND er2u.user_id IN(select * from (
            select user_id from eb_role2user WHERE role_id = rid and eb_del = 'F' and user_id not in 
       (SELECT `value` from usersid_tmp))as q) ;

    INSERT INTO eb_role2user 
        (user_id, role_id, createdby, createdat) 
    SELECT 
        `value`, rid, createdby, NOW() 
        
    FROM (select `value` from usersid_tmp 
     where `value` not in(select er2u1.user_id from eb_role2user er2u1 WHERE er2u1.role_id = rid and er2u1.eb_del = 'F')) AS users;
-- set a=0;
-- select a into r1;
END