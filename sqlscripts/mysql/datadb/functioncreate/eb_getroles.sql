
-- DROP PROCEDURE IF EXISTS eb_getroles;

DELIMITER $$

CREATE DEFINER=`jith`@`%` PROCEDURE `eb_getroles`( IN userid INT, IN wc VARCHAR(10))
BEGIN
	DECLARE app_type VARCHAR(20);
	IF wc = 'tc' OR wc = 'dc' THEN
		SET app_type:='1, 2, 3';
	END IF;
	IF wc = 'uc' THEN
		SET app_type:='1';
	END IF;
	IF wc = 'mc' THEN
		SET app_type:='2';
	END IF;
	IF wc = 'bc' THEN
		SET app_type:='3';
	END IF;
    
    
		CREATE TEMPORARY TABLE IF NOT EXISTS eb_roles_tmp SELECT 	-- STORE TO A TEMP TABLE
		GROUP_CONCAT(role_id) AS roles,
		GROUP_CONCAT(CASE WHEN UROLES.role_name is NULL THEN 'SYS' ELSE UROLES.role_name END) AS role_name
	FROM 
		(SELECT role_id, r.role_name, r.applicationid FROM
		(
			SELECT DISTINCT role_id FROM
			(
				SELECT role_id FROM eb_role2user 
					WHERE user_id = userid AND eb_del = 'F'
				UNION ALL
				(
					WITH RECURSIVE role2role AS
					(
						SELECT role2_id AS role_id FROM eb_role2role
							WHERE role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id = userid AND eb_del = 'F')AND eb_del = 'F'
						UNION ALL
						SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id AND eb_del='F'
					) SELECT * FROM role2role
				)ORDER BY role_id
			) AS ROLES
		) AS qury
		LEFT JOIN
			(SELECT * FROM eb_roles WHERE eb_del = 'F' AND FIND_IN_SET(applicationid,(SELECT eb_applications.id FROM eb_applications WHERE FIND_IN_SET(application_type,app_type)))) r
		ON
			qury.role_id = r.id
		) UROLES
		WHERE 
			role_id < 100 OR 
			applicationid IS NOT NULL ;
END$$

DELIMITER ;

-- call eb_getroles(1,'wc')
