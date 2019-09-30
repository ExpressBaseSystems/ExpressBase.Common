DROP PROCEDURE IF EXISTS eb_get_tagged_object;

CREATE PROCEDURE eb_get_tagged_object(in_tags TEXT)
BEGIN
DECLARE tags TEXT;

DROP TEMPORARY TABLE IF EXISTS tags_tbl;
CREATE TEMPORARY TABLE IF NOT EXISTS tags_tbl 
SELECT 
		EO.id as idv, EO.obj_tags as obj_tags
	FROM 
		eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS
	WHERE 
		EO.id = EOV.eb_objects_id
		AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);
     

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS in_tags_tbl;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
CALL STR_TO_TBL(in_tags);  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS in_tags_tbl SELECT `value` FROM temp_array_table;
    
SELECT 
			EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status,t.obj_tags
                    FROM 
	                    eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS, tags_tbl t
                    WHERE 
	                   t.idv = EO.id AND t.obj_tags IN(SELECT `value` FROM in_tags_tbl) AND EO.id = EOV.eb_objects_id
                        AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);
END