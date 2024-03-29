-- FUNCTION: public.eb_create_or_update_role(integer, text, text, text, integer, text[], integer)

-- DROP FUNCTION public.eb_create_or_update_role(integer, text, text, text, integer, text[], integer);

CREATE OR REPLACE FUNCTION public.eb_create_or_update_role(
	application_id integer,
	role_name text,
	role_desc text,
	isanonym text,
	isprimary text,
	userid integer,
	permissions text[],
	roleid integer DEFAULT 0)
    RETURNS integer
    LANGUAGE 'plpgsql'

AS $BODY$

   

DECLARE rid INTEGER; DECLARE errornum INTEGER;

BEGIN
errornum := 0;

    IF roleid = 0 THEN   
        INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous,is_primary) VALUES ($2,$1,$3,$4,$5) RETURNING ID INTO rid;
    ELSE
        UPDATE eb_roles SET role_name= $2, applicationid= $1, description = $3, is_anonymous = $4, is_primary = $5 WHERE id = roleid;
        rid := roleid;
    END IF;

    UPDATE eb_role2permission 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = $6 
    WHERE 
        role_id = $8 AND eb_del = 'F' AND permissionname IN(
            SELECT unnest(ARRAY(select permissionname from eb_role2permission WHERE role_id = $8 AND eb_del = 'F')) 
        except 
            SELECT unnest(ARRAY[$7]));

    INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
        permissionname, rid, $6, NOW(), 
        split_part(permissionname,'-',4)::int,
        split_part(permissionname,'-',3)::int 
    FROM UNNEST(array(SELECT unnest(ARRAY[$7])
        except 
        SELECT unnest(array(select permissionname from eb_role2permission WHERE role_id = $8 AND eb_del = 'F')))) AS permissionname;
RETURN rid;

EXCEPTION WHEN unique_violation THEN errornum := 23505;
RETURN errornum;

END;

$BODY$;



