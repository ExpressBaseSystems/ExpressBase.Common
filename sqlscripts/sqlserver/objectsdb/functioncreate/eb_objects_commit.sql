CREATE OR ALTER  PROCEDURE eb_objects_commit
	@idv VARCHAR(MAX),
	@obj_namev VARCHAR(MAX),
	@obj_descv VARCHAR(MAX),
	@obj_typev INTEGER,
	@obj_jsonv NVARCHAR(MAX),
	@obj_changelogv VARCHAR(MAX),
	@commit_uidv INTEGER,
	@relationsstring VARCHAR(MAX),
	@tagsv VARCHAR(MAX),
	@appsstring VARCHAR(MAX),
	@disp_name VARCHAR(MAX),
	@out_committed_refidunique varchar(max)

AS
BEGIN
	
	DECLARE @refidunique varchar(max),
			@inserted_obj_ver_id integer,
			@objid integer,
			@committed_refidunique varchar(max), 
			@major integer,
			@minor integer, 
			@patch integer,
			@version_number varchar(max); 
			
	SET NOCOUNT ON;
	DROP TABLE IF EXISTS #relationsv;
	DROP TABLE IF EXISTS #apps;
	
	CREATE TABLE #relationsv(value varchar(max));
	INSERT INTO #relationsv 
		SELECT * FROM eb_str_to_tbl_util(@relationsstring,',');

	CREATE TABLE #apps(value int);
	INSERT INTO #apps 
		SELECT * FROM eb_str_to_tbl_util(@appsstring,',');

	SELECT @objid = (SELECT eb_objects_id FROM eb_objects_ver WHERE refid=@idv);
	SELECT @major = (SELECT major_ver_num FROM eb_objects_ver WHERE refid = @idv);
	SELECT @minor = (SELECT minor_ver_num FROM eb_objects_ver WHERE refid = @idv);
	SELECT @patch = (SELECT patch_ver_num FROM eb_objects_ver WHERE refid = @idv);

	UPDATE 
			eb_objects 
		SET 
    		obj_name = @obj_namev, obj_desc = @obj_descv, obj_tags = @tagsv, display_name = @disp_name
		WHERE 
    		id = @objid;

	UPDATE 
			eb_objects_ver
		SET
    		obj_json = @obj_jsonv, obj_changelog = @obj_changelogv, commit_uid= @commit_uidv, commit_ts = CURRENT_TIMESTAMP
		WHERE    	
			refid = @idv;
	SET @committed_refidunique = @idv;

--majorversion.minorversion.patchversion
	SET @version_number = CONCAT_WS('.', @major, @minor, @patch);
	UPDATE 
			eb_objects_ver 
		SET 
			version_num = @version_number, working_mode = 'F' 
		WHERE 
			refid = @idv;

--relations table
	UPDATE 
			eb_objects_relations 
		SET 
			eb_del = 'T', removed_by = @commit_uidv , removed_at = CURRENT_TIMESTAMP
		WHERE 
			dominant IN(
					SELECT dominant FROM eb_objects_relations WHERE dependant = @idv AND dominant not in(
				           SELECT value FROM #relationsv));
            
	INSERT INTO eb_objects_relations 
			(dominant, dependant) 
		SELECT 
				value, @idv 
		FROM (SELECT value FROM #relationsv WHERE value not in(
				SELECT dominant FROM eb_objects_relations 
                            WHERE dependant = @idv )) as dominantvals; 
							
--application table
	UPDATE 
			eb_objects2application 
		SET 
			eb_del = 'T', removed_by = @commit_uidv , removed_at = CURRENT_TIMESTAMP
    WHERE 
        app_id IN(
        SELECT app_id FROM eb_objects2application WHERE obj_id = @objid AND eb_del='F' and app_id not in ( 
				       SELECT value FROM #apps))
		AND obj_id = @objid;
            
	INSERT INTO eb_objects2application 
			(app_id, obj_id) 
        SELECT 
     			value, @objid
      		FROM 
				(SELECT value FROM #apps WHERE value NOT IN(
				     	SELECT app_id FROM eb_objects2application WHERE obj_id = @objid AND eb_del='F')) as appvals;

SET @out_committed_refidunique = @committed_refidunique;
END
GO


