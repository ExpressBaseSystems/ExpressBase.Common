CREATE OR ALTER PROCEDURE eb_objects_exploreobject
	@_id integer,
	@idval integer out,
	@nameval varchar(max) out,
	@typeval integer out,
	@statusval integer out,
	@descriptionval varchar(max) out,
	@changelogval varchar(max) out,
	@commitatval varchar(max) out, 
	@commitbyval varchar(max) out,
	@refidval varchar(max) out, 
	@ver_numval varchar(max) out,
	@work_modeval char out,
	@workingcopiesval varchar(max) out,
	@json_wcval nvarchar(max) out,
	@json_lcval nvarchar(max) out,
	@major_verval integer out,
	@minor_verval integer out,
	@patch_verval integer out,
	@tagsval varchar(max) out,
	@app_idval varchar(max) out,
	@lastversionrefidval varchar(max) out,
	@lastversionnumberval varchar(max) out,
	@lastversioncommit_tsval varchar(max) out,
	@lastversion_statusval INTEGER out,
	@lastversioncommit_byname varchar(max) out,
	@lastversioncommit_byid INTEGER out,
	@liveversionrefidval varchar(max) out,
	@liveversionnumberval varchar(max) out,
	@liveversioncommit_tsval varchar(max) out,
	@liveversion_statusval INTEGER out,
	@liveversioncommit_byname varchar(max) out,
	@liveversioncommit_byid INTEGER out,
	@owner_uidVal INTEGER out,
	@owner_tsVal varchar(max) out,
	@owner_nameVal varchar(max) out,
	@dispnameval varchar(max) out,
	@is_logv varchar(max) out

AS
BEGIN
	
	SET NOCOUNT ON;
	DECLARE	@temp_workingcopiesval varchar(max), @temp_json_wcval nvarchar(max), @temp_json_lcval nvarchar(max), @temp_idval integer, 
			@temp_nameval varchar(max), @temp_typeval integer, @temp_statusval integer, @temp_descriptionval varchar(max), 
			@temp_changelogval varchar(max), @temp_commitatval varchar(max), @temp_commitbyval varchar(max), @temp_refidval varchar(max), 
			@temp_ver_numval varchar(max), @temp_work_modeval char,	@temp_major_verval integer, @temp_minor_verval integer, 
			@temp_patch_verval integer, @temp_tagsval varchar(max),	@temp_app_idval varchar(max), @temp_lastversionrefidval varchar(max), 
			@temp_lastversionnumberval varchar(max), @temp_lastversioncommit_tsval varchar(max), @temp_lastversion_statusval integer, 
			@temp_lastversioncommit_byname varchar(max), @temp_lastversioncommit_byid integer, @temp_liveversionrefidval varchar(max), 
			@temp_liveversionnumberval varchar(max), @temp_liveversioncommit_tsval varchar(max), @temp_liveversion_statusval integer, 
			@temp_liveversioncommit_byname varchar(max), @temp_liveversioncommit_byid integer, @temp_owner_uidVal integer,
			@temp_owner_tsVal varchar(max), @temp_owner_nameVal varchar(max),@temp_dispnameval varchar(max), @temp_is_logv varchar(max);

--Live version details
	SELECT @temp_liveversionnumberval = EOV.version_num, @temp_liveversionrefidval =  EOV.refid, 
			@temp_liveversioncommit_tsval = EOV.commit_ts, @temp_liveversion_statusval = EOS.status, 
			@temp_liveversioncommit_byid = EOV.commit_uid, @temp_liveversioncommit_byname = EU.firstname		
	FROM
		eb_objects_ver EOV, eb_objects_status EOS, eb_objects EO, eb_users EU
	WHERE
		EO.id = @_id AND EOV.eb_objects_id = @_id AND EOS.status = 3 AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id;

--Latest commited vaersion details
	SELECT TOP 1
			@temp_lastversionnumberval = EOV.version_num, @temp_lastversionrefidval = EOV.refid, 
			@temp_lastversioncommit_tsval = EOV.commit_ts, @temp_lastversion_statusval = EOS.status, 
			@temp_lastversioncommit_byname = EU.firstname,  @temp_lastversioncommit_byid = EOV.commit_uid			
	FROM
		eb_objects_ver EOV, eb_objects_status EOS, eb_users EU
	WHERE
		EOV.eb_objects_id = @_id AND EOS.eb_obj_ver_id = EOV.id AND EOV.commit_uid = EU.id AND COALESCE(EOV.working_mode,'F') = 'F'
    ORDER BY commit_ts DESC;
	
-- Owner details
	SELECT  
		@temp_owner_uidVal = EO.owner_uid, @temp_owner_tsVal = EO.owner_ts, @temp_owner_nameVal = EU.firstname
	FROM 
		eb_objects EO, eb_users EU
	WHERE 
		EO.id = @_id AND EU.id = EO.owner_uid;

	EXEC eb_objects_getversiontoopen @_id, @temp_idval output, @temp_nameval output, @temp_typeval output, @temp_statusval output, 
			@temp_descriptionval output, @temp_changelogval output, @temp_commitatval output, @temp_commitbyval output, 
			@temp_refidval output, @temp_ver_numval output, @temp_work_modeval output, @temp_workingcopiesval output, 
			@temp_json_wcval output, @temp_json_lcval output, @temp_major_verval output, @temp_minor_verval output, 
			@temp_patch_verval output, @temp_tagsval output, @temp_app_idval output, @temp_dispnameval output, @temp_is_logv output;

	SELECT @idval = @temp_idval, @nameval = @temp_nameval, @typeval = @temp_typeval, @statusval = @temp_statusval, 
			@descriptionval = @temp_descriptionval, @changelogval = @temp_changelogval, @commitatval = @temp_commitatval, 
			@commitbyval = @temp_commitbyval, @refidval = @temp_refidval, @ver_numval = @temp_ver_numval, 
			@work_modeval = @temp_work_modeval, @workingcopiesval = @temp_workingcopiesval, @json_wcval = @temp_json_wcval, 
			@json_lcval = @temp_json_lcval, @major_verval = @temp_major_verval, @minor_verval = @temp_minor_verval, 
			@patch_verval = @temp_patch_verval,	@tagsval = @temp_tagsval, @app_idval = @temp_app_idval, 
			@lastversionrefidval = @temp_lastversionrefidval, @lastversionnumberval = @temp_lastversionnumberval, 
			@lastversioncommit_tsval = @temp_lastversioncommit_tsval, @lastversion_statusval = @temp_lastversion_statusval, 
			@lastversioncommit_byname = @temp_lastversioncommit_byname, @lastversioncommit_byid = @temp_lastversioncommit_byid,
			@liveversionrefidval = @temp_liveversionrefidval, @liveversionnumberval = @temp_liveversionnumberval, 
			@liveversioncommit_tsval = @temp_liveversioncommit_tsval, @liveversion_statusval = @temp_liveversion_statusval, 
			@liveversioncommit_byname = @temp_liveversioncommit_byname, @liveversioncommit_byid = @temp_liveversioncommit_byid,
			@owner_uidVal = @temp_owner_uidVal, @owner_tsVal = @temp_owner_tsVal, @owner_nameVal = @temp_owner_nameVal, 
			@dispnameval = @temp_nameval, @is_logv = @temp_is_logv;
	
END
GO


