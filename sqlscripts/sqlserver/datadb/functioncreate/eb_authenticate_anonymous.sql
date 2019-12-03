CREATE OR ALTER   PROCEDURE eb_authenticate_anonymous
	@in_socialid varchar(max),
	@in_fullname varchar(max),
	@in_emailid varchar(max),
	@in_phone varchar(max),
	@in_user_ip varchar(max),
	@in_user_browser varchar(max),
	@in_city varchar(max),
	@in_region varchar(max),
	@in_country varchar(max),
	@in_latitude varchar(max),
	@in_longitude varchar(max),
	@in_timezone varchar(max),
	@in_iplocationjson varchar(max),
	@in_appid int,
	@in_wc varchar(max),
	@out_userid int OUTPUT, 
	@out_status_id int OUTPUT,
	@out_email varchar(max) OUTPUT, 
	@out_fullname varchar(max) OUTPUT,
	@out_roles_a varchar(max) OUTPUT,
	@out_rolename_a varchar(max) OUTPUT,
	@out_permissions varchar(max) OUTPUT,
	@out_preferencesjson varchar(max) OUTPUT,
	@out_constraints_a varchar(max) OUTPUT,
	@out_signin_id int OUTPUT
AS
BEGIN
	DECLARE @is_anon_auth_req bit = 0; DECLARE @out_userid1 int; DECLARE @out_status_id1 int; DECLARE @out_email1 varchar(max); DECLARE @out_fullname1 varchar(max);
	DECLARE @out_roles_a1 varchar(max); DECLARE @out_rolename_a1 varchar(max); DECLARE @out_permissions1 varchar(max); DECLARE @out_preferencesjson1 varchar(max); 
	DECLARE @out_constraints_a1 varchar(max); DECLARE @out_signin_id1 int; 

	DECLARE @per_tmp varchar(max); DECLARE @json_tmp varchar(max);


	IF @in_socialid IS NOT NULL 
	BEGIN
		EXEC eb_authenticate_unified @uname = '', @password = '', @social = @in_socialid, @wc = @in_wc, @ipaddress = @in_user_ip, @deviceinfo = '', @_userid = @out_userid1 OUTPUT, @_status_id = @out_status_id1 OUTPUT,
		@_email = @out_email1 OUTPUT,@_fullname = @out_fullname1 OUTPUT, @_roles_a = @out_roles_a1 OUTPUT, @_rolename_a = @out_rolename_a1 OUTPUT, @_permissions = @per_tmp OUTPUT, 
		@_preferencesjson = @json_tmp OUTPUT, @_constraints_a = @out_constraints_a1 OUTPUT, @_signin_id = @out_signin_id1 OUTPUT;
		
		IF @out_userid1 = 0 
		BEGIN
			SELECT @out_userid1 = A.id, @out_email1 = A.email, @out_fullname1 = A.fullname FROM eb_usersanonymous A WHERE A.socialid = @in_socialid AND appid = @in_appid AND ebuserid = 1;
			IF @out_userid1 IS NULL
			BEGIN
				INSERT INTO eb_usersanonymous (socialid, fullname, email, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson)
				VALUES (@in_socialid, @in_fullname, @in_emailid, CURRENT_TIMESTAMP AT TIME ZONE 'UTC', CURRENT_TIMESTAMP AT TIME ZONE 'UTC', @in_appid, @in_user_ip, @in_user_browser, @in_city, @in_region, @in_country, @in_latitude, @in_longitude, @in_timezone, @in_iplocationjson);
				SELECT @out_userid1 = SCOPE_IDENTITY();
			END;
			ELSE
				UPDATE eb_usersanonymous SET lastvisit = CURRENT_TIMESTAMP AT TIME ZONE 'UTC', totalvisits = totalvisits + 1, ipaddress = @in_user_ip, browser = @in_user_browser, city = @in_city, region = @in_region, country = @in_country, latitude = @in_latitude, longitude = @in_longitude, timezone = @in_timezone, iplocationjson = @in_iplocationjson WHERE id = @out_userid1;
			SET @is_anon_auth_req = 1;
		END;	
	END;
	ELSE
	BEGIN
		IF @in_emailid IS NOT NULL OR @in_phone IS NOT NULL
		BEGIN
			SELECT 
				@out_userid1 = A.id, @out_email1 = A.email, @out_fullname1 = A.fullname 
			FROM 
				eb_usersanonymous A
			WHERE 
				(A.email = @in_emailid OR A.phoneno = @in_phone) AND appid = @in_appid;
			IF @out_userid1 IS NULL
			BEGIN
				INSERT INTO eb_usersanonymous (email, phoneno, fullname, firstvisit, lastvisit, appid, ipaddress, browser, city, region, country, latitude, longitude, timezone, iplocationjson)
				VALUES (@in_emailid, @in_phone, @in_fullname, CURRENT_TIMESTAMP AT TIME ZONE 'UTC', CURRENT_TIMESTAMP AT TIME ZONE 'UTC', @in_appid, @in_user_ip, @in_user_browser, @in_city, @in_region, @in_country, @in_latitude, @in_longitude, @in_timezone, @in_iplocationjson);	
				SELECT @out_userid1 = SCOPE_IDENTITY();
			END;
			ELSE
			BEGIN
				IF @out_email1 IS NULL 
					UPDATE eb_usersanonymous SET email = @in_emailid, lastvisit = CURRENT_TIMESTAMP AT TIME ZONE 'UTC', totalvisits = totalvisits + 1, ipaddress = @in_user_ip, browser = @in_user_browser, city = @in_city, region = @in_region, country = @in_country, latitude = @in_latitude, longitude = @in_longitude, timezone = @in_timezone, iplocationjson = @in_iplocationjson WHERE phoneno = @in_phone;
				ELSE
					UPDATE eb_usersanonymous SET phoneno = @in_phone, lastvisit = CURRENT_TIMESTAMP AT TIME ZONE 'UTC', totalvisits = totalvisits + 1, ipaddress = @in_user_ip, browser = @in_user_browser, city = @in_city, region = @in_region, country = @in_country, latitude = @in_latitude, longitude = @in_longitude, timezone = @in_timezone, iplocationjson = @in_iplocationjson WHERE email = @in_emailid;
			END;
			SET @is_anon_auth_req = 1;
		END;
	END;
	IF @is_anon_auth_req = 1
	BEGIN
		EXEC eb_authenticate_unified @uname = 'anonymous@anonym.com', @password = '294de3557d9d00b3d2d8a1e6aab028cf', @social = '', @wc = @in_wc, @ipaddress = @in_user_ip, @deviceinfo = '', @_userid = @out_userid1 OUTPUT, @_status_id = @out_status_id1 OUTPUT,
		@_email = @out_email1 OUTPUT,@_fullname = @out_fullname1 OUTPUT, @_roles_a = @out_roles_a1 OUTPUT, @_rolename_a = @out_rolename_a1 OUTPUT, @_permissions = @out_permissions OUTPUT, 
		@_preferencesjson = @out_preferencesjson OUTPUT, @_constraints_a = @out_constraints_a1 OUTPUT, @_signin_id = @out_signin_id1 OUTPUT;
	END;
	SELECT @out_userid = @out_userid1, @out_status_id = @out_status_id1, @out_email = @out_email1, @out_fullname = @out_fullname1, @out_roles_a = @out_roles_a1, @out_rolename_a = @out_rolename_a1,
	@out_permissions = @out_permissions1, @out_preferencesjson1 = @out_preferencesjson1, @out_constraints_a = @out_constraints_a1, @out_signin_id = @out_signin_id1;
END;