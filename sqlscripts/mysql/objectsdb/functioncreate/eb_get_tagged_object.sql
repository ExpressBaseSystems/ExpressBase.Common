CREATE PROCEDURE eb_get_tagged_object(in_tags text)
BEGIN
declare tags text;

SELECT 
			group_concat(EO.obj_tags) into tags
                    FROM 
	                    eb_objects EO;
                 
 
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS tags_tbl;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value text);
	CALL STR_TO_TBL(tags);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS tags_tbl SELECT `value` FROM temp_array_table;
    
SELECT 
			EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status,t.`value`
                    FROM 
	                    eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS, tags_tbl t
                    WHERE 
	                   t.`value` IN(in_tags) AND EO.id =EOV.eb_objects_id
                        AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);
END