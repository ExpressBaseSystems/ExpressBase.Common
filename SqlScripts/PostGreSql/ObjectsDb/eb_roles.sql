--DROP FUNCTION public.eb_create_or_update_role(integer, text, text, integer, text[], integer);

CREATE OR REPLACE FUNCTION eb_create_or_update_role(  
    application_id integer,
    role_name text,
    role_desc text,
    userid integer,
    permissions text[], 
    roleid integer DEFAULT 0
) RETURNS INTEGER AS $$

DECLARE rid INTEGER; DECLARE errornum INTEGER;

BEGIN
errornum := 0;

    IF roleid = 0 THEN   
        INSERT INTO eb_roles (role_name,applicationid,description) VALUES ($2,$1,$3);
    ELSE
        UPDATE eb_roles SET role_name= $2, applicationid= $1, description = $3 WHERE id = roleid;
    END IF;

    IF roleid = 0 THEN
        SELECT CURRVAL('eb_roles_id_seq') INTO rid;
    ELSE
        rid := roleid;
    END IF;

    UPDATE eb_role2permission 
    SET 
        eb_del = TRUE,revokedat = NOW(),revokedby = $4 
    WHERE 
        permissionname IN(
            SELECT unnest(ARRAY(select permissionname from eb_role2permission WHERE role_id = $6 AND eb_del = FALSE)) 
        except 
            SELECT unnest(ARRAY[$5]));

    INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, obj_id, op_id) 
    SELECT 
        permissionname, rid, $4, NOW(), 
        split_part(permissionname,'_',2)::int,
        split_part(permissionname,'_',1)::int 
    FROM UNNEST(array(SELECT unnest(ARRAY[$5])
        except 
        SELECT unnest(array(select permissionname from eb_role2permission WHERE role_id = $6 AND eb_del = FALSE)))) AS permissionname;
RETURN errornum;

EXCEPTION WHEN unique_violation THEN errornum := 23505;
RETURN errornum;

END;
$$ LANGUAGE plpgsql;


---------------------------------------------------------------------------------------------------------------------------------------------


--DROP FUNCTION public.eb_create_or_update_role2role(integer, integer, integer[]);

CREATE OR REPLACE FUNCTION eb_create_or_update_role2role(  
    roleid integer,
    userid integer,
    dependantroles integer[])
    
 RETURNS INTEGER AS $$

BEGIN

    UPDATE eb_role2role 
    SET 
        eb_del = TRUE,revokedat = NOW(),revokedby = $2 
    WHERE 
        role2_id IN(
            SELECT unnest(ARRAY(select role2_id from eb_role2role WHERE role1_id = $1 and eb_del = FALSE)) 
        except 
            SELECT unnest(ARRAY[$3]));

    INSERT INTO eb_role2role 
        (role2_id, role1_id, createdby, createdat) 
    SELECT 
        dependants, $1, $2, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[$3])
        except 
        SELECT unnest(array(select role2_id from eb_role2role WHERE role1_id = $1 and eb_del = FALSE)))) AS dependants;
RETURN 0;

END;
$$ LANGUAGE plpgsql;