CREATE OR ALTER PROCEDURE eb_objects_create_new_object
	@obj_namev varchar(max),
	@obj_descv varchar(max),
	@obj_typev integer,
	@obj_cur_statusv integer,
	@obj_jsonv nvarchar(max),
	@commit_uidv integer,
	@src_pid varchar(max),
	@cur_pid varchar(max),
	@relationsstring varchar(max),
	@issave varchar(3),
	@tagsv varchar(max),
	@appsstring varchar(max),
	@s_obj_id varchar(max),
	@s_ver_id varchar(max),
	@disp_name varchar(max),
	@out_refid_of_commit_version varchar(max) out

AS
BEGIN
	DECLARE @refidunique varchar(MAX); 
	DECLARE @inserted_objid integer; 
	DECLARE @inserted_obj_ver_id integer; 
	DECLARE @refid_of_commit_version varchar(MAX);
	DECLARE @version_number varchar(MAX); 
	DECLARE @relationsv varchar(MAX); 
	DECLARE @apps integer; 
	
	SET NOCOUNT ON;

	DROP TABLE IF EXISTS #relationsv;
	DROP TABLE IF EXISTS #apps;
	
	CREATE TABLE #relationsv(value varchar(max));
	INSERT INTO #relationsv 
		SELECT * FROM eb_str_to_tbl_util(@relationsstring,',');

	CREATE TABLE #apps(value int);
	INSERT INTO #apps 
		SELECT * FROM eb_str_to_tbl_util(@appsstring,',');
	
	INSERT INTO eb_objects  
		(obj_name, obj_desc, obj_type, obj_cur_status, obj_tags, owner_uid, owner_ts, display_name, is_logenabled, eb_del)
	VALUES
		(@obj_namev, @obj_descv, @obj_typev, @obj_cur_statusv, @tagsv, @commit_uidv, CURRENT_TIMESTAMP, @disp_name, 'F','F');
	SET @inserted_objid = SCOPE_IDENTITY();
    
	INSERT INTO eb_objects_ver
        (eb_objects_id, obj_json, commit_uid, commit_ts, major_ver_num, minor_ver_num, patch_ver_num, working_mode) 
    VALUES
        (@inserted_objid, @obj_jsonv, @commit_uidv, CURRENT_TIMESTAMP,1,0,0,@issave);
	SET @inserted_obj_ver_id = SCOPE_IDENTITY();
		
	IF (@issave = 'T')
		SET @version_number = CONCAT_WS('.',1,0,0,'w');
    ELSE
    	SET @version_number =  CONCAT_WS('.',1,0,0);

	IF @s_obj_id = '0' AND @s_ver_id='0' 
		SET @refidunique = CONCAT_WS('-', @src_pid, @cur_pid, @obj_typev, @inserted_objid, @inserted_obj_ver_id, @inserted_objid, @inserted_obj_ver_id); 
	ELSE
		SET @refidunique = CONCAT_WS('-', @src_pid, @cur_pid, @obj_typev, @inserted_objid, @inserted_obj_ver_id, @s_obj_id, @s_ver_id); 
		    
	SET @refid_of_commit_version = @refidunique;
	
	UPDATE 
			eb_objects_ver 
		SET 
			refid = @refidunique, version_num = @version_number 
		WHERE 
			id = @inserted_obj_ver_id;
	INSERT INTO eb_objects_status
		(eb_obj_ver_id, status, uid, ts, changelog) 
	VALUES
		(@inserted_obj_ver_id, @obj_cur_statusv, @commit_uidv, CURRENT_TIMESTAMP, 'Created');

--relations table    
	INSERT INTO eb_objects_relations 
		(dominant,dependant)  
		SELECT value, @refidunique FROM #relationsv ;

--applications table
	INSERT INTO eb_objects2application 
		(app_id,obj_id) 
	SELECT value, @inserted_objid FROM #apps;		

	SET @out_refid_of_commit_version = @refid_of_commit_version;
	
END
GO


