DROP PROCEDURE IF EXISTS eb_create_or_update_role2role;

CREATE PROCEDURE eb_create_or_update_role2role(IN rid INTEGER,
IN createdby INTEGER,
IN dependantroles_str TEXT
)
BEGIN
DECLARE a INTEGER;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS dependantroles_tmp;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value INTEGER);      
CALL eb_str_to_tbl_util(dependantroles_str,',');  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS dependantroles_tmp SELECT `value` FROM temp_array_table;
    
UPDATE eb_role2role er2r
SET 
	  er2r.eb_del = 'T',er2r.revokedat = NOW(),er2r.revokedby = createdby 
WHERE 
	er2r.role1_id = rid AND er2r.eb_del = 'F' AND er2r.role2_id IN
		(SELECT * FROM (SELECT er2r1.role2_id FROM eb_role2role er2r1
							WHERE 
								er2r1.role1_id = rid AND er2r1.eb_del = 'F' AND er2r1.role2_id NOT IN(
									SELECT `value` FROM dependantroles_tmp
			))AS a) ;

INSERT INTO 
		eb_role2role (role2_id, role1_id, createdby, createdat) 
    SELECT 
        `value`, rid,createdby, NOW()        
    FROM (
		SELECT 
			`value` 
		FROM 
			dependantroles_tmp 
		WHERE 
        `value` NOT IN (
			SELECT er2r2.role2_id FROM eb_role2role er2r2 WHERE er2r2.role1_id = rid AND er2r2.eb_del = 'F'
		)) AS dependants;
 
END