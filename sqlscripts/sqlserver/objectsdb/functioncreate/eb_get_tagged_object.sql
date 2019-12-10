CREATE OR ALTER PROCEDURE eb_get_tagged_object
	@in_tags varchar(max)
	 
AS
BEGIN
	
	DECLARE @tags varchar(max);
	DROP TABLE IF EXISTS #tmp_tags;
		CREATE TABLE #tmp_tags(idv integer, value varchar(max));
		INSERT INTO #tmp_tags 
			SELECT 
				EO.id, EO.obj_tags	
                    FROM 
	                    eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS
                    WHERE 
	                    EO.id = EOV.eb_objects_id
                        AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);

	
	DROP TABLE IF EXISTS #tmp_in_tags;
		CREATE TABLE #tmp_in_tags(value varchar(max));
		INSERT INTO #tmp_in_tags 
			SELECT * FROM eb_str_to_tbl_util(@in_tags,',');
	SELECT 
			EO.obj_name, EOV.refid, EOV.version_num, EO.obj_type,EOS.status,EO.obj_tags,t.value 
		FROM 
			eb_objects EO, eb_objects_ver EOV,eb_objects_status EOS, #tmp_tags t
		WHERE 
			t.idv = EO.id AND t.value IN(SELECT value FROM #tmp_in_tags) AND EO.id =EOV.eb_objects_id
			AND EOS.eb_obj_ver_id = EOV.id AND EOS.status = 3 AND EO.obj_type IN(16 ,17);
    
END
GO


