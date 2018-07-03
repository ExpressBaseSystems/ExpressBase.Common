-- FUNCTION: public.eb_get_tagged_object(text)

-- DROP PROCEDURE IF EXISTS eb_get_tagged_object;

DELIMITER $$       
CREATE PROCEDURE eb_get_tagged_object( IN in_tags text)
BEGIN
    DECLARE obj_tag_str text;
    
    SELECT eb_objects FROM eb_objects INTO obj_tag_str;
    
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
        
	CALL STR_TO_TBL(obj_tag_str);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS obj_tags_tbl SELECT `value` FROM temp_array_table;
    
	SELECT 
		EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type, EOS.status, EO.eb_objects
	FROM 
		eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS,obj_tags_tbl Tags
	WHERE 
		Tags IN(in_tags) AND EO.id =EOV.eb_objects_id
		AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);
END$$
