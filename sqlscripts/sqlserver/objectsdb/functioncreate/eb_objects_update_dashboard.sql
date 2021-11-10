CREATE OR ALTER PROCEDURE eb_objects_update_dashboard
	@_refid varchar(max),
	@namev varchar(max) output,
	@status integer output,
	@ver_num varchar(max) output,
	@work_mode char output, 
	@workingcopies varchar(max) output,
	@major_ver integer output,
	@minor_ver integer output,
	@patch_ver integer output,
	@tags varchar(max) output, 
	@app_id varchar(max) output,
	@lastversionrefidval varchar(max) output,
	@lastversionnumberval varchar(max) output,
	@lastversioncommit_tsval varchar(max) output,
	@lastversion_statusval integer output,
	@lastversioncommit_byname varchar(max) output,
	@lastversioncommit_byid integer output,
	@liveversionrefidval varchar(max) output,
	@liveversionnumberval varchar(max) output, 
	@liveversioncommit_tsval varchar(max) output, 
	@liveversion_statusval integer output, 
	@liveversioncommit_byname varchar(max) output, 
	@liveversioncommit_byid integer output, 
	@owner_uidval integer output, 
	@owner_tsval varchar(max) output, 
	@owner_nameval varchar(max) output
AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE @temp_workingcopies varchar(max), @temp_id integer, @temp_namev varchar(max), @temp_status integer,	
			@temp_description varchar(max), @temp_changelog varchar(max), @temp_ver_num varchar(max), @temp_work_mode char,
			@temp_major_ver integer, @temp_minor_ver integer, @temp_patch_ver integer, @temp_tags varchar(max), @temp_app_id varchar(max),
			@temp_lastversionrefidval varchar(max), @temp_lastversionnumberval varchar(max), @temp_lastversioncommit_tsval varchar(max),
			@temp_lastversion_statusval integer, @temp_lastversioncommit_byname varchar(max), @temp_lastversioncommit_byid integer,
			@temp_liveversionrefidval varchar(max),	@temp_liveversionnumberval varchar(max), @temp_liveversioncommit_tsval varchar(max),
			@temp_liveversion_statusval integer, @temp_liveversioncommit_byname varchar(max), @temp_liveversioncommit_byid integer,
			@temp_owner_uidVal integer, @temp_owner_tsVal varchar(max), @temp_owner_nameVal varchar(max);

	SET @temp_workingcopies = NULL;

	SELECT @temp_id = eb_objects_id  FROM eb_objects_ver WHERE refid = @_refid;

	SELECT 
			@temp_app_id = STRING_AGG(EA.applicationname,',') 
		FROM 
			eb_objects2application E2O ,eb_applications EA 
		WHERE 
			obj_id = @temp_id and E2O.eb_del = 'F' and EA.id = E2O.app_id;

	SELECT 
			@temp_workingcopies = STRING_AGG(concat('{"',version_num ,'":"', refid , '"}'),',')  
		FROM 
			eb_objects_ver 
		WHERE 
			eb_objects_id=@temp_id AND working_mode='T';
--Live version details
	SELECT
			@temp_liveversionnumberval = EOV.version_num, @temp_liveversionrefidval = EOV.refid, 
			@temp_liveversioncommit_tsval = EOV.commit_ts, @temp_liveversion_statusval = EOS.status, 
			@temp_liveversioncommit_byid = EOV.commit_uid, @temp_liveversioncommit_byname = EU.firstname 
		FROM
			eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
		WHERE
			EO.id = @temp_id AND EOV.eb_objects_id = @temp_id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id 
			AND EOV.commit_uid = EU.id;
--Latest commited vaersion details
	SELECT TOP 1
			@temp_lastversionnumberval = EOV.version_num, @temp_lastversionrefidval = EOV.refid, 
			@temp_lastversioncommit_tsval = EOV.commit_ts, @temp_lastversion_statusval = EOS.status, 
			@temp_lastversioncommit_byname = EU.firstname,  @temp_lastversioncommit_byid = EOV.commit_uid     
		FROM
			eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
		WHERE
			EOV.eb_objects_id = @temp_id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id 
			AND COALESCE(EOV.working_mode,'F') = 'F'
		ORDER BY 
			commit_ts DESC;
-- Owner details
	SELECT  
			@temp_owner_uidVal = EO.owner_uid, @temp_owner_tsVal = EO.owner_ts, @temp_owner_nameVal = EU.firstname
		FROM 
			eb_objects EO, eb_users EU
		WHERE 
			EO.id = @temp_id AND EU.id = EO.owner_uid;

	SELECT 
			@temp_namev = EO.obj_name, @temp_status = EOS.status, @temp_ver_num = EOV.version_num, @temp_work_mode = EOV.working_mode,
		    @temp_major_ver = EOV.major_ver_num, @temp_minor_ver = EOV.minor_ver_num, @temp_patch_ver = EOV.patch_ver_num, 
			@temp_tags = EO.obj_tags	
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
			EOV.refid = @_refid AND EOV.eb_objects_id = EO.id
			AND EOS.id = (SELECT MAX(EOS.id) FROM eb_objects_status EOS WHERE EOS.eb_obj_ver_id = EOV.id);

	SELECT @namev = @temp_namev, @status = @temp_status, @ver_num = @temp_ver_num, @work_mode = COALESCE(@temp_work_mode,'F'), 
		   @workingcopies = @temp_workingcopies, @major_ver = @temp_major_ver, @minor_ver = @temp_minor_ver, @patch_ver = @temp_patch_ver,
		   @tags = @temp_tags, @app_id = @temp_app_id, @lastversionrefidval = @temp_lastversionrefidval, 
		   @lastversionnumberval = @temp_lastversionnumberval, @lastversioncommit_tsval = @temp_lastversioncommit_tsval, 
		   @lastversion_statusval = @temp_lastversion_statusval, @lastversioncommit_byname = @temp_lastversioncommit_byname,
		   @lastversioncommit_byid = @temp_lastversioncommit_byid, @liveversionrefidval = @temp_liveversionrefidval, 
		   @liveversionnumberval = @temp_liveversionnumberval, @liveversioncommit_tsval = @temp_liveversioncommit_tsval, 
		   @liveversion_statusval = @temp_liveversion_statusval, @liveversioncommit_byname = @temp_liveversioncommit_byname,
		   @liveversioncommit_byid = @temp_liveversioncommit_byid, @owner_uidval = @temp_owner_uidVal, @owner_tsval = @temp_owner_tsVal, 
		   @owner_nameval = @temp_owner_nameVal;
END
GO


