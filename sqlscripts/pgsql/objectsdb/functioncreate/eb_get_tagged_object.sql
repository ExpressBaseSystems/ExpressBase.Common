-- FUNCTION: public.eb_get_tagged_object(text)

-- DROP FUNCTION public.eb_get_tagged_object(text);

CREATE OR REPLACE FUNCTION public.eb_get_tagged_object(
	in_tags text)
    RETURNS TABLE(obj_name text, refid text, version_num text, obj_type integer, status integer, objtags text) 
    LANGUAGE 'plpgsql'
AS $BODY$

BEGIN
	RETURN QUERY
    	SELECT 
			EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status,EO.obj_tags
                    FROM 
	                    eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS,unnest(string_to_array(EO.obj_tags, ',')) Tags
                    WHERE 
	                    Tags IN(in_tags) AND EO.id =EOV.eb_objects_id
                        AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);

END;
$BODY$;

ALTER FUNCTION public.eb_get_tagged_object(text)
    OWNER TO postgres;

