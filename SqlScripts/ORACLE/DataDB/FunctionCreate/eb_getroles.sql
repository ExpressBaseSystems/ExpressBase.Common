create or replace FUNCTION eb_getroles(
	userid number,
    wc1 VARCHAR DEFAULT NULL)
    RETURN rtntblrole as roles_tbl  rtntblrole;         
   l_numbers apptype;
    BEGIN  
    IF wc1 = 'tc' OR wc1 = 'dc' THEN
        l_numbers := apptype(1, 2, 3);          
    ELSIF  wc1 = 'uc' THEN
        l_numbers := apptype(1); 
    ELSIF  wc1 = 'mc' THEN
        l_numbers := apptype(2); 
    ELSIF  wc1 = 'bc' THEN
         l_numbers := apptype(3); 
    ELSE
         l_numbers := apptype(NULL);
    END IF;
    SELECT 
    	tblroleobj(LISTAGG(role_id,',') within group(order by role_id),LISTAGG(CASE WHEN UROLES.role_name is NULL THEN 'SYS' ELSE UROLES.role_name END,',') within group(order by role_id)) BULK COLLECT INTO roles_tbl FROM 
         (SELECT role_id, r.role_name, r.applicationid FROM       
         (SELECT DISTINCT role_id FROM
				(
                WITH role2role(role_id) AS 
                 (
					SELECT 
						role2_id AS roleid FROM eb_role2role
					WHERE role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id = 2 AND eb_del = 'F')
					UNION ALL
					SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id AND eb_del='F'
				  ) SELECT * FROM role2role  
                  UNION ALL
                 SELECT 
					role_id FROM eb_role2user 
		 		WHERE user_id = 2 AND eb_del = 'F')) qury
		      LEFT JOIN             
               (SELECT * FROM eb_roles WHERE eb_del = 'F' AND applicationid = ANY(SELECT eb_applications.id FROM eb_applications WHERE application_type=ANY(select * from table(l_numbers)))) r
		ON
			qury.role_id = r.id
		) UROLES
		WHERE 
			role_id < 100 OR 
			applicationid IS NOT NULL ;
    RETURN roles_tbl;
END;