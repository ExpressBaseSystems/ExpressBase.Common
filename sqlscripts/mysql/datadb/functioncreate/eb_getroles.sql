CREATE PROCEDURE eb_getroles(IN userid integer,
    IN wc text,
    out roless text,
    out role_names text)
BEGIN
DECLARE app_type varchar(20);
IF wc = 'tc' OR wc = 'dc' THEN
    set app_type='1, 2, 3';
    END IF;
    IF wc = 'uc' THEN
    set app_type:='1';
    END IF;
	IF wc = 'mc' THEN
   set app_type:='2';
    END IF;
    IF wc = 'bc' THEN
   set app_type:='3';
    END IF;
    
   
    CREATE TEMPORARY TABLE IF NOT EXISTS eb_roles_tmp SELECT 	
		GROUP_CONCAT(UROLES.role_id) as roles,
		group_concat(CASE WHEN UROLES.role_name is NULL THEN 'SYS' ELSE UROLES.role_name END) as role_name 
	FROM 
		(SELECT role_id, r.role_name, r.applicationid FROM
		(
			SELECT DISTINCT role_id FROM
			(
				SELECT role_id FROM eb_role2user 
					WHERE user_id = userid AND eb_del = 'F'
				UNION ALL
				(
				
                select * from (
						SELECT e1.role2_id AS role_id FROM  eb_role2role e1 
                        join (SELECT e.role2_id,e.role1_id FROM eb_role2role e WHERE  e.eb_del='F')q on q.role2_id = e1.role2_id 
							WHERE e1.role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id = userid AND eb_del = 'F') AND e1.eb_del = 'F'
												
					)as r
				)ORDER BY role_id
			) AS ROLES
		) AS qury
		LEFT JOIN
			(SELECT * FROM eb_roles WHERE eb_del = 'F' AND FIND_IN_SET( applicationid , (SELECT eb_applications.id FROM eb_applications WHERE find_in_set(application_type,app_type))))r
		ON
			qury.role_id = r.id
		) UROLES
		WHERE 
			role_id < 100 OR 
			applicationid IS NOT NULL ;
            
 select roles,role_name from eb_roles_tmp into roless,role_names;
END