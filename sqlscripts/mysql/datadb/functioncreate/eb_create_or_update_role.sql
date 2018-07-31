-- FUNCTION: eb_create_or_update_role(integer, text, text, text, integer, text[], integer)

-- DROP FUNCTION eb_create_or_update_role;

DELIMITER $$
CREATE FUNCTION eb_create_or_update_role(
	application_id integer,
	role_name text,
	role_desc text,
	isanonym text,
	userid integer,
	permissions_str text,
	roleid integer)
	RETURNS INTEGER
	DETERMINISTIC
BEGIN
	DECLARE rid INTEGER;
	-- DECLARE errornum INTEGER;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(permissions_str);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS permissions SELECT `value` FROM temp_array_table;

    IF roleid = 0 THEN   
        INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous) VALUES (role_name,application_id,role_desc,isanonym);
        SELECT last_insert_id() INTO rid;
    ELSE
        UPDATE eb_roles SET role_name= role_name, applicationid= application_id, description = role_desc, is_anonymous = isanonym WHERE id = roleid;
        SET rid := roleid;
    END IF;

	UPDATE eb_role2permission 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = userid 
    WHERE 
        permissionname IN(SELECT permissionname FROM eb_role2permission WHERE role_id = roleid AND eb_del = 'F'
							AND  permissionname NOT IN (SELECT * FROM permissions));

	INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
        `value`,
		rid,
		userid,
		NOW(), 
        CAST(split_str(permissionname,'-',4) AS UNSIGNED INT),
        CAST(split_str(permissionname,'-',3) AS UNSIGNED INT)
    FROM (SELECT `value` 
			FROM permissions
			WHERE `value` 
			NOT IN (SELECT permissionname FROM eb_role2permission WHERE role_id = roleid AND eb_del = 'F')) AS a;
RETURN rid;

-- EXCEPTION unique_violation CODE HERE
END;
