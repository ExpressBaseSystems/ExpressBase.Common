CREATE PROCEDURE eb_getroles(IN userid integer,
    IN wc text,
    out roless text,
     out role_names text
    )
BEGIN
DECLARE app_type varchar(20);
IF wc = 'tc' OR wc = 'dc' THEN
    set app_type='1, 2, 3';
    END IF;
    IF wc = 'uc' THEN
    set app_type='1';
    END IF;
	IF wc = 'mc' THEN
   set app_type='2';
    END IF;
    IF wc = 'bc' THEN
   set app_type='3';
    END IF;
    
	   SELECT 	
		GROUP_CONCAT(UROLES.role_id) as roles,
		group_concat(CASE WHEN UROLES.role_name is NULL THEN 'SYS' ELSE UROLES.role_name END) as role_name 
	FROM 
		(SELECT qury.role_id, r.role_name, r.applicationid FROM
		(
			SELECT DISTINCT ROLES.role_id FROM
			(
				SELECT er2u.role_id FROM eb_role2user er2u
					WHERE er2u.user_id = userid AND er2u.eb_del = 'F'
				UNION ALL
				(
					WITH RECURSIVE role2role AS
					(
						SELECT role2_id AS role_id FROM eb_role2role
							WHERE role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id = userid AND eb_del = 'F') AND eb_del = 'F'
						UNION ALL
						SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id AND eb_del='F'
					) SELECT * FROM role2role
				)ORDER BY role_id
			) AS ROLES
		) AS qury
		LEFT JOIN
			(SELECT * FROM eb_roles er WHERE er.applicationid = ANY(SELECT ea.id FROM eb_applications ea WHERE find_in_set(ea.application_type,app_type)) AND er.eb_del = 'F' ) r
		ON
			qury.role_id = r.id
		) UROLES
		WHERE 
			role_id < 100 OR 
			applicationid IS NOT NULL into roless,role_names;
END