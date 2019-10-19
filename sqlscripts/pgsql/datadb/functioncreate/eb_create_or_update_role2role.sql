-- FUNCTION: public.eb_create_or_update_role2role(integer, integer, integer[])

-- DROP FUNCTION public.eb_create_or_update_role2role(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role2role(
	roleid integer,
	userid integer,
	dependantroles integer[])
    RETURNS integer
    LANGUAGE 'plpgsql'
     
AS $BODY$

BEGIN

    UPDATE eb_role2role 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = $2 
    WHERE 
        role1_id = $1 AND eb_del = 'F' AND role2_id IN(
            SELECT unnest(ARRAY(select role2_id from eb_role2role WHERE role1_id = $1 and eb_del = 'F')) 
        except 
            SELECT unnest(ARRAY[$3]));

    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat) 
    SELECT 
        dependants, $1, $2, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[$3])
        except 
        SELECT unnest(array(select role2_id from eb_role2role WHERE role1_id = $1 and eb_del = 'F')))) AS dependants;
RETURN 0;

END;

$BODY$;


