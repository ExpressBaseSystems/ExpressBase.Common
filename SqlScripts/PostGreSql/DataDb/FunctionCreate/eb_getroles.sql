-- FUNCTION: public.eb_getroles(integer, text)

-- DROP FUNCTION public.eb_getroles(integer, text);

CREATE OR REPLACE FUNCTION public.eb_getroles(
	userid integer,
	wc text)
    RETURNS TABLE(roles text, role_name text) 
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
    ROWS 1000
AS $BODY$

	DECLARE app_type integer[];
BEGIN
	
    IF wc = 'tc' OR wc = 'dc' THEN
    app_type:='{1, 2, 3}';
    END IF;
    IF wc = 'uc' THEN
    app_type:='{1}';
    END IF;
	IF wc = 'mc' THEN
    app_type:='{2}';
    END IF;
    IF wc = 'bc' THEN
    app_type:='{3}';
    END IF;
    
	RETURN QUERY 	
    SELECT 	
		array_to_string(array_agg(role_id), ','),
		array_to_string(array_agg(CASE WHEN UROLES.role_name is NULL THEN 'SYS' ELSE UROLES.role_name END), ',') 
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
							WHERE role1_id = ANY(SELECT role_id FROM eb_role2user WHERE user_id = userid AND eb_del = 'F')
						UNION ALL
						SELECT e.role2_id FROM eb_role2role e, role2role r WHERE e.role1_id = r.role_id AND eb_del='F'
					) SELECT * FROM role2role
				)ORDER BY role_id
			) AS ROLES
		) AS qury
		LEFT JOIN
			(SELECT * FROM eb_roles WHERE eb_del = 'F' AND applicationid = ANY(SELECT eb_applications.id FROM eb_applications WHERE application_type=ANY(app_type))) r
		ON
			qury.role_id = r.id
		) UROLES
		WHERE 
			role_id < 100 OR 
			applicationid IS NOT NULL ;
END;

$BODY$;

ALTER FUNCTION public.eb_getroles(integer, text)
    OWNER TO postgres;

