-- FUNCTION: public.eb_update_rel(integer, text[])

-- DROP FUNCTION public.eb_update_rel(integer, text[]);

CREATE OR REPLACE FUNCTION public.eb_update_rel(
	commit_uidv integer,
	relationsv text[])
    RETURNS integer
    LANGUAGE 'plpgsql'

    
AS $BODY$

BEGIN
    UPDATE eb_objects_relations 
    SET 
        eb_del = 'T', removed_by= commit_uidv , removed_at=NOW()
    WHERE 
        dominant IN(
            SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = 'eb_roby_dev-eb_roby_dev-2-429-788'  )) 
        except 
            SELECT unnest(ARRAY['eb_roby_dev-eb_roby_dev-12-420-754']));

    INSERT INTO eb_objects_relations 
        (dominant, dependant, removed_by, removed_at) 
    SELECT 
        dominant, dependant, commit_uidv, NOW() 
        
    FROM UNNEST(array(SELECT unnest(ARRAY[relationsv])
        except 
        SELECT unnest(array(select dominant from eb_objects_relations WHERE dependant = 'eb_roby_dev-eb_roby_dev-2-429-788'  ))));
RETURN 0;

END;

$BODY$;

