DROP PROCEDURE IF EXISTS eb_objects_save;

CREATE PROCEDURE eb_objects_save(IN id TEXT,
    IN obj_name TEXT,
    IN obj_desc TEXT,
    IN obj_type INTEGER,
    IN obj_json JSON,
    IN commit_uid INTEGER,
    IN relations TEXT,
    IN tags TEXT,
    IN app_id TEXT,
    IN disp_name TEXT,
    OUT out_refidv TEXT)
BEGIN
DECLARE refidunique TEXT;
DECLARE objid INTEGER;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS relationsv;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
CALL STR_TO_TBL(relations);  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS relationsv SELECT `value` FROM temp_array_table;

DROP TEMPORARY TABLE IF EXISTS apps;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;

CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value INTEGER);
CALL STR_TO_TBL(app_id);  -- fill to temp_array_table
CREATE TEMPORARY TABLE IF NOT EXISTS apps SELECT `value` FROM temp_array_table;

SELECT eb_objects_id INTO objid FROM eb_objects_ver WHERE refid=id;
 	 UPDATE eb_objects e SET e.obj_name = obj_name, e.obj_desc = obj_desc, e.obj_tags = tags , e.display_name = disp_name WHERE e.id = objid;
    
SET SQL_SAFE_UPDATES=0;
UPDATE eb_objects_ver eov SET eov.obj_json = obj_json WHERE eov.refid=id;    
        
-- relations table
UPDATE 
		eb_objects_relations 
	SET 
        eb_del = 'T', removed_by = commit_uid , removed_at = NOW()
    WHERE 
        dominant IN(
			SELECT * FROM ( SELECT dominant FROM eb_objects_relations WHERE dependant = id AND dominant NOT IN(
				SELECT `value` FROM relationsv)
			)AS a);
            
INSERT INTO 
		eb_objects_relations (dominant, dependant) 
	SELECT 
     	`value`, id
	FROM 
		(SELECT `value` FROM relationsv WHERE `value` NOT IN(
			SELECT dominant FROM eb_objects_relations WHERE dependant = id )
	) AS dominantvals;

-- applications table 
UPDATE 
		eb_objects2application eo2a
		SET 
		    eo2a.eb_del = 'T', eo2a.removed_by = commit_uid , eo2a.removed_at = NOW()
		WHERE 
			eo2a.app_id IN(
				SELECT * FROM( 
					SELECT 
						eo2a1.app_id 
					FROM 
						eb_objects2application eo2a1 
					WHERE eo2a1.obj_id = objid AND eo2a1.eb_del='F' AND eo2a1.app_id NOT IN(
						SELECT `value` FROM apps)
					)AS b)
			AND eo2a.obj_id = objid;
            
INSERT INTO eb_objects2application (app_id, obj_id) 
        SELECT 
     		`value`, objid
      	FROM (SELECT `value` FROM apps WHERE `value` NOT IN(
			SELECT app_id FROM eb_objects2application WHERE obj_id = objid AND eb_del = 'F')
		) AS appvals;

SELECT id INTO out_refidv;

END 