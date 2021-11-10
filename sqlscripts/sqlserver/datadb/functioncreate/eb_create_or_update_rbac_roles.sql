CREATE OR ALTER PROCEDURE eb_create_or_update_rbac_roles

	@roleid int,
	@applicationid int,
	@userid int,
	@role_name varchar(max),
	@description varchar(max),
	@isanonym varchar(max),
	@users varchar(max),
	@dependantroles varchar(max),
	@permissions varchar(max),
	@locations varchar(max)

AS
BEGIN
	DECLARE @rid INTEGER, @r1 INTEGER,@r2 INTEGER,@r3 INTEGER,
			@_users varchar(max),
			@_dependantroles varchar(max);

	EXEC @rid = eb_create_or_update_role @applicationid,@role_name,@description,@isanonym,@userid,@permissions,@roleid;

	IF @isanonym = 'T' 
	BEGIN
		SET @_users = '1';
		SET @_dependantroles = '';
	END 
	EXEC @r1 = eb_create_or_update_role2user @rid, @userid, @users;

	EXEC @r2 = eb_create_or_update_role2role @rid, @userid, @dependantroles;

	EXEC @r3 = eb_create_or_update_role2loc @rid, @userid, @locations;
	
RETURN 0;
END;