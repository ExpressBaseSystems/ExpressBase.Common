CREATE OR ALTER PROCEDURE eb_objects_getversiontoopen
	@_id integer,
	@out_idv integer out, 
	@out_namev varchar(max) out, 
    @out_typev integer out, 
	@out_status integer out, 
	@out_description varchar(max) out, 
	@out_changelog varchar(max) out, 
	@out_commitat varchar(max) out, 
	@out_commitby varchar(max) out, 
	@out_refidv varchar(max) out, 
	@out_ver_num varchar(max) out, 
	@out_work_mode char out, 
	@out_workingcopies varchar(max) out, 
	@out_json_wc nvarchar(max) out, 
	@out_json_lc nvarchar(max) out, 
	@out_major_ver integer out, 
	@out_minor_ver integer out, 
	@out_patch_ver integer out, 
	@out_tags varchar(max) out, 
	@out_app_id varchar(max) out, 
	@out_dispnamev varchar(max) out, 
	@out_is_log char out
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE  @workingcopies varchar(max), @json_wc nvarchar(max), @json_lc nvarchar(max), @no_of_workcopies integer,
			 @idv integer, @namev varchar(max), @typev integer, @status integer,	@description varchar(max), @changelog varchar(max), 
			 @commitat varchar(max), @commitby varchar(max), @refidv varchar(max), @ver_num varchar(max), @work_mode char,
			 @major_ver integer, @minor_ver integer, @patch_ver integer, @tags varchar(max), @app_id varchar(max), 
			 @lastversionnumber varchar(max), @lastversionrefid varchar(max), @liveversionnumber varchar(max), 
			 @liveversionrefid varchar(max), @dispnamev varchar(max),@is_log char;
    
	SET @workingcopies = NULL;
	SET @json_wc = NULL;
	SET @json_lc =NULL;

--Fetching all working copies

	SELECT 
			@workingcopies = STRING_AGG(concat('{"',version_num ,'":"', refid , '"}'),','), @no_of_workcopies = count(*) 
		FROM 
			eb_objects_ver 
		WHERE 
			eb_objects_id=@_id AND working_mode='T';

	SELECT 
			@app_id = STRING_AGG(EA.applicationname,',') 
		FROM 
			eb_objects2application E2O ,eb_applications EA 
		WHERE 
			obj_id = @_id and E2O.eb_del = 'F' and EA.id = E2O.app_id;
--one working copy	
	IF @no_of_workcopies = 1 
	BEGIN
		SELECT 
				@idv = EO.id, @namev = EO.obj_name, @typev = EO.obj_type, @status = EOS.status, @description = EO.obj_desc,
				@json_wc = EOV.obj_json, @changelog = EOV.obj_changelog, @commitat = EOV.commit_ts, @refidv = EOV.refid, 
				@ver_num = EOV.version_num, @work_mode = EOV.working_mode, @commitby = EU.firstname, @major_ver = EOV.major_ver_num, 
				@minor_ver = EOV.minor_ver_num, @patch_ver = EOV.patch_ver_num, @tags = EO.obj_tags, @dispnamev = EO.display_name, 
				@is_log = EO.is_logenabled	
			FROM 
				eb_objects EO, eb_objects_ver EOV
		LEFT JOIN
			eb_users EU
			ON 
				EOV.commit_uid=EU.id
		LEFT JOIN
			eb_objects_status EOS
			ON 
				EOS.eb_obj_ver_id = EOV.id										 
		WHERE 
			EO.id = @_id AND EOV.eb_objects_id = EO.id AND working_mode='T'
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);
	END
--No working copy			
	ELSE IF @no_of_workcopies = 0
	BEGIN
		SELECT 
                @idv = EO.id, @namev = EO.obj_name, @typev = EO.obj_type, @status = EOS.status, @description = EO.obj_desc, 
                @json_lc = EOV.obj_json, @changelog = EOV.obj_changelog, @commitat = EOV.commit_ts, @refidv = EOV.refid, 
				@ver_num = EOV.version_num, @work_mode = EOV.working_mode, @commitby = EU.firstname, @major_ver = EOV.major_ver_num, 
				@minor_ver = EOV.minor_ver_num, @patch_ver = EOV.patch_ver_num, @tags = EO.obj_tags, @dispnamev = EO.display_name, 
				@is_log = EO.is_logenabled
			FROM  
                eb_objects EO, eb_objects_ver EOV
		LEFT JOIN
                eb_users EU
			ON 
                EOV.commit_uid=EU.id	
		LEFT JOIN
				eb_objects_status EOS
			ON 
				EOS.eb_obj_ver_id = EOV.id									 
        WHERE 
                EO.id = @_id AND EOV.eb_objects_id = EO.id  AND
                major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=@_id) AND 
                minor_ver_num=(Select max(minor_ver_num) from eb_objects_ver where eb_objects_id=@_id AND  
				major_ver_num=(Select max(major_ver_num) from eb_objects_ver where eb_objects_id=@_id)) AND
                COALESCE(working_mode, 'F') <> 'T'
				AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id); 
	END;
-- multiple workingcopies
	ELSE
	BEGIN
		SELECT 
				@idv = EO.id, @namev = EO.obj_name, @typev = EO.obj_type, @status = EOS.status, @description = EO.obj_desc,
				@json_lc = EOV.obj_json, @changelog = EOV.obj_changelog, @commitat = EOV.commit_ts, @refidv = EOV.refid, 
				@ver_num = EOV.version_num, @work_mode = EOV.working_mode, @commitby = EU.firstname, @major_ver = EOV.major_ver_num, 
				@minor_ver = EOV.minor_ver_num, @patch_ver = EOV.patch_ver_num, @tags = EO.obj_tags, @dispnamev = EO.display_name, 
				@is_log = COALESCE(EO.is_logenabled,'F')
			
			FROM 
				eb_objects EO, eb_objects_ver EOV
			LEFT JOIN
				eb_users EU
				ON 
					EOV.commit_uid=EU.id
			LEFT JOIN
				eb_objects_status EOS
				ON 
					EOS.eb_obj_ver_id = EOV.id		
			WHERE 
				EO.id = @_id AND EOV.eb_objects_id = EO.id AND working_mode='T'
		AND EOV.id = (SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = @_id AND working_mode='T')
		AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS, eb_objects_ver EOV WHERE EOS.eb_obj_ver_id = (
		SELECT MAX(EOV.id) FROM eb_objects_ver EOV WHERE EOV.eb_objects_id = @_id AND working_mode='T') AND EOV.working_mode='T');
	END

	SELECT @out_idv = @idv, @out_namev = @namev, @out_typev = @typev, @out_status = @status, @out_description = @description, 
		   @out_changelog =	@changelog, @out_commitat = @commitat, @out_commitby = @commitby, @out_refidv = @refidv, 
		   @out_ver_num = @ver_num, @out_work_mode = COALESCE(@work_mode,'F'), @out_workingcopies = @workingcopies, 
		   @out_json_wc = @json_wc, @out_json_lc = @json_lc, @out_major_ver = @major_ver, @out_minor_ver = @minor_ver, 
		   @out_patch_ver = @patch_ver, @out_tags = @tags, @out_app_id = @app_id, @out_dispnamev = @dispnamev, @out_is_log = @is_log;
END
GO


