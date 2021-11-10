CREATE OR ALTER       PROCEDURE eb_authenticate_unified
	@uname varchar(max),
	@password varchar(max),
	@social varchar(max),
	@wc varchar(max),
	@ipaddress varchar(max),
	@deviceinfo varchar(max),
	@_userid int OUTPUT,
	@_status_id int OUTPUT,
	@_email varchar(max) OUTPUT,
	@_fullname varchar(max) OUTPUT,
	@_roles_a varchar(max) OUTPUT,
	@_rolename_a varchar(max) OUTPUT,
	@_permissions varchar(max) OUTPUT,
	@_preferencesjson varchar(max) OUTPUT,
	@_constraints_a varchar(max) OUTPUT,
	@_signin_id int OUTPUT
AS
BEGIN
	DECLARE @_userid1 int; DECLARE @_status_id1 int; DECLARE @_email1 varchar(max); DECLARE @_fullname1 varchar(max);
	DECLARE @_roles_a1 varchar(max); DECLARE @_rolename_a1 varchar(max); DECLARE @_permissions1 varchar(max);
	DECLARE @_preferencesjson1 varchar(max); DECLARE @_constraints_a1 varchar(max); 

	DECLARE @_signin_id1 int = 0; DECLARE @_temp1 int;

	IF @uname IS NOT NULL AND @password IS NOT NULL AND @social IS NULL
	BEGIN
		SELECT 
			@_userid1 = id, @_email1 = email, @_fullname1 = fullname, @_preferencesjson1 = preferencesjson 
		FROM 
			eb_users 
		WHERE 
			email = @uname AND pwd = @password AND statusid = 0;
		IF @_userid1 IS NULL
		BEGIN
			SELECT @_userid1 = id, @_status_id1 = statusid FROM eb_users WHERE email = @uname AND pwd = @password;
			IF @_userid1 IS NULL
			BEGIN
				SELECT @_userid1 = eb_users.id FROM eb_users WHERE eb_users.email = @uname AND statusid = 0;
				IF @_userid1 > 0
				BEGIN
					INSERT INTO eb_signin_log(user_id, ip_address, device_info, signin_at, is_attempt_failed)
					VALUES(@_userid1, @ipaddress, @deviceinfo, CURRENT_TIMESTAMP AT TIME ZONE 'UTC', 'T');	
					SELECT @_temp1 = MAX(id) FROM eb_signin_log WHERE user_id = @_userid1 AND is_attempt_failed = 'F';
					IF @_temp1 IS NULL 
						SELECT @_signin_id1 = COUNT(*) FROM eb_signin_log WHERE user_id = @_userid1 AND is_attempt_failed = 'T';
					ELSE
						SELECT @_signin_id1 = COUNT(*) FROM eb_signin_log WHERE user_id = @_userid1 AND is_attempt_failed = 'T' AND id > @_temp1;
				END;
			END;
			SET @_userid1 = 0;
		END;
	END;
	-- SSO
	IF @uname IS NOT NULL AND @password IS NULL AND @social IS NULL 
    BEGIN
		SELECT @_userid1 = id, @_email1 = email, @_fullname1 = fullname, @_preferencesjson1 = preferencesjson FROM eb_users 
		WHERE email = @uname AND statusid = 0;
		IF @_userid1 IS NULL 	
			SELECT @_status_id1 = statusid FROM eb_users WHERE email = @uname;
    END;
	-- SOCIAL
    IF @uname IS NULL AND @password IS NULL AND @social IS NOT NULL 
	BEGIN
        SELECT @_userid1 = id, @_email1 = email, @_fullname1 = fullname, @_preferencesjson1 = preferencesjson FROM eb_users 
		WHERE fbid = @social AND statusid = 0;
		IF @_userid1 IS NULL 	
			SELECT @_status_id1 = statusid FROM eb_users WHERE fbid = @social;
    END;
	IF @_userid1 > 0
	BEGIN
		DECLARE @roles varchar(max); DECLARE @role_name varchar(max); 
		EXEC eb_getroles @userid = @_userid1, @wc = @wc,@roles = @roles OUTPUT,@role_name = @role_name OUTPUT;
		EXEC  eb_getpermissions @roles = @_roles_a1, @permission = @_permissions1 OUTPUT;

		DROP TABLE IF EXISTS #_role_ids;
		CREATE TABLE #_role_ids (value int);
		INSERT INTO #_role_ids
			SELECT * FROM [dbo].[eb_str_to_tbl_util](@_roles_a1,',');

		DROP TABLE IF EXISTS #_ug_ids;
		CREATE TABLE #_ug_ids (value int);
		INSERT INTO #_ug_ids
			SELECT groupid FROM eb_user2usergroup WHERE userid = @_userid1 AND eb_del = 'F';

		SELECT 
			@_constraints_a1 = CAST(m.id as varchar(max)) + ';' + CAST(m.key_id as varchar(max)) + ';' + CAST(m.key_type as varchar(max)) + ';' 
			+ CAST(l.id as varchar(max)) + ';' + CAST(l.c_operation as varchar(max)) + ';' + CAST(l.c_type as varchar(max)) + ';' 
			+ CAST(l.c_value as varchar(max)) + '$' 
		FROM 
			eb_constraints_master m, eb_constraints_line l
		WHERE 
			m.id = l.master_id AND eb_del = 'F' AND
			((key_type = 1 AND m.key_id = @_userid1) OR
			(key_type = 2 AND m.key_id IN (SELECT value FROM #_ug_ids)) OR
			(key_type = 3 AND m.key_id IN (SELECT value FROM #_role_ids)));

		INSERT INTO eb_signin_log(user_id, ip_address, device_info, signin_at)
			VALUES(@_userid1, @ipaddress, @deviceinfo, CURRENT_TIMESTAMP AT TIME ZONE 'UTC');
		SELECT @_signin_id = SCOPE_IDENTITY();
	END;

	IF @_userid1 IS NULL 
		SET @_userid1 = 0;
	IF @_status_id1 IS NULL 
		SET @_status_id1 = 0;
	SELECT @_userid = @_userid1, @_status_id = @_status_id1, @_email = @_email1, @_fullname = @_fullname1, @_roles_a = @_roles_a1, @_rolename_a = @_rolename_a1, @_permissions = @_permissions1, @_preferencesjson = @_preferencesjson1, @_constraints_a = @_constraints_a1, @_signin_id = @_signin_id1; 
END;