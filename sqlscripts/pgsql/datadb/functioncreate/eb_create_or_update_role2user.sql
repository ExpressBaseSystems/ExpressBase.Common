-- FUNCTION: public.eb_create_or_update_role2user(integer, integer, integer[])

-- DROP FUNCTION public.eb_create_or_update_role2user(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role2user(
	roleid integer,
	userid integer,
	usersid integer[])
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

BEGIN
    UPDATE eb_role2user 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = $2 
    WHERE 
        role_id = $1 AND eb_del = 'F' AND user_id IN(
            SELECT unnest(ARRAY(select user_id from eb_role2user WHERE role_id = $1 and eb_del = 'F')) 
        except 
            SELECT unnest(ARRAY[$3]));

    INSERT INTO eb_role2user 
        (user_id, role_id, createdby, createdat) 
    SELECT 
        users, $1, $2, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[$3])
        except 
        SELECT unnest(array(select user_id from eb_role2user WHERE role_id = $1 and eb_del = 'F')))) AS users;
RETURN 0;

END;

$BODY$;

ALTER FUNCTION public.eb_create_or_update_role2user(integer, integer, integer[])
    OWNER TO postgres;

