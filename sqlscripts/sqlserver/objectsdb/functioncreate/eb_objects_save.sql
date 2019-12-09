CREATE OR ALTER PROCEDURE eb_objects_save
	@refidv varchar(max),
	@obj_namev varchar(max),
	@obj_descv varchar(max),
	@obj_typev integer,
	@obj_jsonv nvarchar(max),
	@commit_uidv integer,
	@relationsstring varchar(max),
	@tagsv varchar(max),
	@appsstring varchar(max),
	@disp_name varchar(max),
	@out_refidv varchar(max) out
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @refidunique VARCHAR(MAX),
			@inserted_objid integer,
			@inserted_obj_ver_id integer,
			@objid integer;
-- Insert statements for procedure here
	DROP TABLE IF EXISTS #relationsv;
	DROP TABLE IF EXISTS #apps;
	
	CREATE TABLE #relationsv(value varchar(max));
	INSERT INTO #relationsv 
		SELECT * FROM eb_str_to_tbl_util(@relationsstring,',');

	CREATE TABLE #apps(value int);
	INSERT INTO #apps 
		SELECT * FROM eb_str_to_tbl_util(@appsstring,',');

	SELECT @objid = (SELECT eb_objects_id FROM eb_objects_ver WHERE refid= @refidv);
	
	UPDATE 
			eb_objects 
		SET 
			obj_name = @obj_namev, obj_desc = @obj_descv, obj_tags = @tagsv , display_name = @disp_name 
		WHERE 
			id = @objid;
	
    UPDATE 
			eb_objects_ver 
		SET 
			obj_json = @obj_jsonv 
		WHERE 
			refid=@refidv;

--relations table
	UPDATE eb_objects_relations 
	SET 
		eb_del = 'T', removed_by = @commit_uidv , removed_at = current_timestamp
    WHERE 
		dominant IN(
						SELECT dominant FROM eb_objects_relations WHERE dependant = @refidv and dominant not in(
							SELECT value FROM #relationsv));
            
	INSERT INTO eb_objects_relations (dominant, dependant) 
	SELECT 
			value, @refidv
		FROM (SELECT value FROM #relationsv WHERE value not in (
						select dominant from eb_objects_relations WHERE dependant = @refidv )) as dominantvals;

--applications table 
	UPDATE 
			eb_objects2application 
		SET 
			eb_del = 'T', removed_by = @commit_uidv , removed_at = CURRENT_TIMESTAMP
		WHERE 
			app_id IN(
						SELECT app_id FROM eb_objects2application WHERE obj_id = @objid AND eb_del='F' AND app_id NOT IN (       
								SELECT value FROM #apps ))
				AND obj_id = @inserted_objid;
            
	INSERT INTO eb_objects2application (app_id, obj_id) 
	SELECT 
		value, @inserted_objid
      	FROM (SELECT value FROM #apps WHERE value not in(
					SELECT app_id FROM eb_objects2application WHERE obj_id = @objid AND eb_del='F')) as appvals;

	SET @out_refidv = @refidv;
END
GO


