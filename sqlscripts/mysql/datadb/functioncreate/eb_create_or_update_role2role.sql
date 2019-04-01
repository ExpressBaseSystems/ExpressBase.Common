CREATE PROCEDURE eb_create_or_update_role2role(in roleid integer,
in userid integer,
in dependantroles text,
out out_r integer)
BEGIN
declare a integer;
drop temporary table if exists temp_array_table;
drop temporary table if exists dependantroles_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
        
CALL STR_TO_TBL(dependantroles);  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS dependantroles_tmp SELECT `value` FROM temp_array_table;
    
 UPDATE eb_role2role 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = userid 
    WHERE 
        role1_id = roleid AND eb_del = 'F' AND role2_id IN
            (select * from (SELECT role2_id from eb_role2role WHERE role1_id = roleid and eb_del = 'F'
       and  role2_id not in 
            (select `value` from dependantroles_tmp))as a) ;

    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat) 
    SELECT 
        `value`, roleid,userid, NOW() 
        
    FROM (select `value` from dependantroles_tmp where 
         `value` not in (select role2_id from eb_role2role WHERE role1_id = roleid and eb_del = 'F')) AS dependants;
         set a=0;
select a into out_r;
END