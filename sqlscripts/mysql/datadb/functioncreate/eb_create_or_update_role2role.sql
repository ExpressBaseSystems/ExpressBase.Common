CREATE PROCEDURE eb_create_or_update_role2role(in rid integer,
in createdby integer,
in dependantroles_str text
-- ,out r2 integer
)
BEGIN
declare a integer;
drop temporary table if exists temp_array_table;
drop temporary table if exists dependantroles_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
        
CALL STR_TO_TBL(dependantroles_str);  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS dependantroles_tmp SELECT `value` FROM temp_array_table;
    
 UPDATE eb_role2role er2r
    SET 
        er2r.eb_del = 'T',er2r.revokedat = NOW(),er2r.revokedby = createdby 
    WHERE 
        er2r.role1_id = rid AND er2r.eb_del = 'F' AND er2r.role2_id IN
            (select * from (SELECT er2r1.role2_id from eb_role2role er2r1 WHERE er2r1.role1_id = rid and er2r1.eb_del = 'F'
       and  er2r1.role2_id not in 
            (select `value` from dependantroles_tmp))as a) ;

    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat) 
    SELECT 
        `value`, rid,createdby, NOW() 
        
    FROM (select `value` from dependantroles_tmp where 
         `value` not in (select er2r2.role2_id from eb_role2role er2r2 WHERE er2r2.role1_id = rid and er2r2.eb_del = 'F')) AS dependants;
        -- set a=0;
-- select a into r2;
END