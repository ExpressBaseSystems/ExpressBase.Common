DROP PROCEDURE IF EXISTS eb_create_or_update_role;

CREATE PROCEDURE eb_create_or_update_role(IN applicationid INTEGER,
    IN role_name TEXT,
    IN description TEXT,
    IN is_anonym TEXT,
    IN createdby INTEGER,
    IN permissions_str TEXT,
    IN role_id INTEGER,
    OUT out_rid INTEGER)
BEGIN
DECLARE rid INTEGER; 
DECLARE errornum INTEGER;
-- DECLARE CONTINUE HANDLER FOR SQLSTATE '23505' select 0; 

IF role_id = 0 THEN SET role_id = NULL; END IF;

DROP TEMPORARY TABLE IF EXISTS eb_create_or_update_role_tmp;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS permissions_tmp;
 
CREATE TEMPORARY TABLE temp_array_table(value TEXT);
CALL STR_TO_TBL(permissions_str);  
CREATE TEMPORARY TABLE IF NOT EXISTS permissions_tmp SELECT `value` FROM temp_array_table;

SET errornum = 0;

IF role_id IS NULL THEN   
        INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous) VALUES (role_name,applicationid,description,is_anonym);
        SELECT LAST_INSERT_ID() INTO rid;
    ELSE
        UPDATE eb_roles er SET er.role_name = role_name, er.applicationid = applicationid, er.description = description, er.is_anonymous = is_anonym WHERE er.id = role_id;
      SET rid = role_id;
END IF;

UPDATE 
		eb_role2permission er2p
	SET 
        er2p.eb_del = 'T',er2p.revokedat = NOW(),er2p.revokedby = createdby 
    WHERE 
        er2p.role_id = role_id AND er2p.eb_del = 'F' AND er2p.permissionname IN(
			SELECT * FROM(
				SELECT 
					er2p1.permissionname 
						FROM 
							eb_role2permission er2p1 
						WHERE er2p1.role_id = role_id AND er2p1.eb_del = 'F' AND  er2p1.permissionname NOT IN (
							SELECT `value` FROM  permissions_tmp
			))AS a);
            
INSERT INTO 
	eb_role2permission(permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
         `value`, rid, createdby, NOW(), 
        CAST( SPLIT_STR(`value`,'-',4) AS UNSIGNED INT),
        CAST( SPLIT_STR(`value`,'-',3) AS UNSIGNED INT)
    FROM ( (SELECT `value` FROM permissions_tmp WHERE `value` NOT IN 
    (SELECT er2p2.permissionname FROM eb_role2permission er2p2 WHERE er2p2.role_id = role_id AND er2p2.eb_del = 'F')) )AS a;
        
SELECT rid INTO out_rid;
-- EXCEPTION WHEN unique_violation THEN errornum := 23505;
END 