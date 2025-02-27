-- FUNCTION: public.eb_objects_save(text, text, text, integer, json, integer, text, text, text, text, text)

-- DROP FUNCTION public.eb_objects_save(text, text, text, integer, json, integer, text, text, text, text, text);

CREATE OR REPLACE FUNCTION public.eb_objects_save(
	refidv text,
	obj_namev text,
	obj_descv text,
	obj_typev integer,
	obj_jsonv json,
	commit_uidv integer,
	relationsstring text,
	tagsv text,
	appsstring text,
	disp_name text,
	hide_in_menuv text)

    RETURNS text
    LANGUAGE 'plpgsql'

AS $BODY$

DECLARE refidunique text; inserted_objid integer; inserted_obj_ver_id integer; objid integer; relationsv text[]; apps integer[];
BEGIN
	SELECT string_to_array(relationsstring,',')::text[] into relationsv;
	SELECT string_to_array(appsstring,',')::int[] into apps;
	SELECT eb_objects_id FROM eb_objects_ver into objid WHERE refid=refidv;
 	
	UPDATE eb_objects SET obj_name = obj_namev, obj_desc = obj_descv, obj_tags = tagsv , display_name = disp_name, hide_in_menu = hide_in_menuv WHERE id = objid RETURNING id INTO inserted_objid;
    UPDATE eb_objects_ver SET obj_json = obj_jsonv, commit_uid= commit_uidv, commit_ts = NOW() WHERE refid=refidv RETURNING id INTO inserted_obj_ver_id;
   
    --relations table
	UPDATE 
			eb_objects_relations 
		SET 
			eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
		WHERE 
			dominant IN(
				SELECT unnest(ARRAY(select dominant from eb_objects_relations WHERE dependant = refidv and eb_del ='F')) 
				EXCEPT 
				SELECT unnest(ARRAY[relationsv]));
            
        INSERT INTO eb_objects_relations 
			(dominant, dependant) 
			SELECT 
     				dominantvals, refidv
      			FROM 
					UNNEST(array(SELECT unnest(ARRAY[relationsv])
				EXCEPT 
      				SELECT unnest(array(select dominant from eb_objects_relations WHERE dependant = refidv and eb_del ='F' )))) as dominantvals;

--applications table 
	UPDATE 
			eb_objects2application 
		SET 
			eb_del = 'T', removed_by = commit_uidv , removed_at = NOW()
		WHERE 
			app_id IN(
				SELECT unnest(ARRAY(select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')) 
				EXCEPT 
				SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])]))
			AND obj_id = inserted_objid;
            
        INSERT INTO eb_objects2application 
			(app_id, obj_id) 
				SELECT 
     				appvals, inserted_objid
      				FROM UNNEST(array(SELECT unnest(ARRAY[COALESCE(apps, ARRAY[0])])
						EXCEPT 
      					SELECT unnest(array(select app_id from eb_objects2application WHERE obj_id = inserted_objid AND eb_del='F')))) as appvals;
        
	RETURN refidv;
END;

$BODY$;
