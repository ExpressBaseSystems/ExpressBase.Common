CREATE OR ALTER PROCEDURE eb_object_create_patch_version
	@idv varchar(max),
	@obj_typev integer,
	@commit_uidv integer,
	@src_pid varchar(max),
	@cur_pid varchar(max),
	@relationsstring varchar(max),
	@committed_refidunique varchar(max) OUT
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @refidunique varchar(max), 
			@inserted_obj_ver_id integer, 
			@objid integer, 
			@temp_committed_refidunique varchar(max),
			@major integer,
			@minor integer, 
			@patch integer, 
			@version_number varchar(max);
	
	DROP TABLE IF EXISTS #relationsv;
	CREATE TABLE #relationsv(value varchar(max));
	INSERT INTO #relationsv 
		SELECT * FROM eb_str_to_tbl_util(@relationsstring,',');
		
	SET @objid = (SELECT eb_objects_id FROM eb_objects_ver WHERE refid=@idv);
	SET @major = (SELECT major_ver_num FROM eb_objects_ver WHERE refid=@idv);
	SET @minor = (SELECT minor_ver_num FROM eb_objects_ver WHERE refid=@idv);
	SET @patch = (SELECT patch_ver_num FROM eb_objects_ver WHERE refid=@idv);
	
	INSERT INTO	eb_objects_ver 
			(eb_objects_id, obj_json, major_ver_num, minor_ver_num)
		SELECT
				eb_objects_id, obj_json, major_ver_num, minor_ver_num
			FROM 
				eb_objects_ver
			WHERE
				refid=@idv;
	SET @inserted_obj_ver_id = SCOPE_IDENTITY();

	SET @version_number = CONCAT_WS('.', @major, @minor, @patch + 1,'w');

	UPDATE 
			eb_objects_ver
		SET
			commit_ts = CURRENT_TIMESTAMP, commit_uid = @commit_uidv, version_num = @version_number, working_mode = 'T', patch_ver_num = @patch + 1
		WHERE
			id = @inserted_obj_ver_id ;

	SET @refidunique = CONCAT_WS('-', @src_pid, @cur_pid, @obj_typev, @objid, @inserted_obj_ver_id, @objid, @inserted_obj_ver_id);  
	SET @temp_committed_refidunique = @refidunique;

	UPDATE 
			eb_objects_ver 
		SET 
			refid = @refidunique 
		WHERE 
			id = @inserted_obj_ver_id;

	INSERT INTO eb_objects_status
			(eb_obj_ver_id, status, uid, ts) 
		VALUES
			(@inserted_obj_ver_id, 0, @commit_uidv, CURRENT_TIMESTAMP);

	UPDATE 
			eb_objects_relations 
		SET 
			eb_del = 'T', removed_by = @commit_uidv , removed_at = CURRENT_TIMESTAMP
		WHERE 
			dominant IN(
				SELECT dominant FROM eb_objects_relations WHERE dependant = @refidunique AND dominant NOT IN( 
					SELECT value FROM #relationsv));

	INSERT INTO eb_objects_relations 
			(dominant, dependant) 
		SELECT 
				value, @refidunique 
			FROM (SELECT value FROM #relationsv WHERE value NOT IN(
					SELECT dominant FROM eb_objects_relations 
							WHERE dependant = @refidunique )) as dominantvals;
							
SET @committed_refidunique = @temp_committed_refidunique;
END
GO


