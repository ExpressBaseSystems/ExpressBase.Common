CREATE OR ALTER PROCEDURE eb_objects_change_status
	@idv varchar(max),
	@statusv integer,
	@commit_uid integer,
	@changelogv varchar(max),
	@out_obj_ver_id integer output
AS
BEGIN
	
	SET NOCOUNT ON;

    DECLARE @inserted_obj_ver_id integer, @ob_id integer, @ck_status varchar(max), @tmp integer;

	SET @ob_id = (SELECT 
							DISTINCT eb_objects_id
						FROM
							eb_objects_ver
						WHERE
							refid=@idv);
	SET @tmp = (SELECT q.ver_id 
					FROM( 
						SELECT 
							eos.eb_obj_ver_id as ver_id, eos.status as t_status 
						FROM 
    						eb_objects_status eos 
						WHERE 
							eos.id IN (
								SELECT MAX(eos1.id) AS id1 FROM eb_objects_status eos1 
									WHERE eos1.eb_obj_ver_id IN(
										SELECT eov.id FROM eb_objects_ver eov 
											WHERE COALESCE(eov.eb_del,'F')='T' AND eov.eb_objects_id = @ob_id ) 
										GROUP BY eos1.eb_obj_ver_id )
							)q WHERE t_status=3);
	IF ( @statusv = 3 AND @tmp <> 0)
	BEGIN
		SELECT @out_obj_ver_id = @tmp;  
	END
	ELSE
	BEGIN
		INSERT INTO
				eb_objects_status(eb_obj_ver_id)
			SELECT
					id
				FROM
					eb_objects_ver
				WHERE
					refid=@idv;
		SET @inserted_obj_ver_id = SCOPE_IDENTITY();

		UPDATE
				eb_objects_status 
			SET
				status = @statusv, uid = @commit_uid, ts = CURRENT_TIMESTAMP, changelog = @changelogv
			WHERE
				id = @inserted_obj_ver_id;
		SELECT @out_obj_ver_id = 0;
	END
END
GO


