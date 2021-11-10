CREATE OR ALTER PROCEDURE eb_security_usergroup
	@_userid int,
	@_id int,
	@_name varchar(max),
	@_description varchar(max),
	@_users varchar(max),
	@_constraints_add varchar(max),
	@_constraints_del varchar(max)

AS

BEGIN

	DECLARE @gid int = @_id; DECLARE @add_no int; DECLARE @del_no int;
	
	DROP TABLE IF EXISTS #users;
	CREATE TABLE #users(value int);
	INSERT INTO #users 
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@_users,',');

	IF @_id > 0 
	BEGIN
		UPDATE eb_usergroup SET name=@_name, description=@_description WHERE id=@_id;

		INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT value,@_id,@_userid,CURRENT_TIMESTAMP AT TIME ZONE 'UTC' FROM 
			(
				SELECT value FROM #users
				EXCEPT
				SELECT userid FROM eb_user2usergroup WHERE groupid = @_id AND eb_del = 'F'
			)userid
   		
		UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = @_userid,revokedat =CURRENT_TIMESTAMP AT TIME ZONE 'UTC'  WHERE groupid = @_id AND eb_del = 'F' 
		AND userid IN
		(
			SELECT userid from eb_user2usergroup WHERE groupid = @_id AND eb_del = 'F' 
			EXCEPT 
			SELECT value FROM #users
		);
	END;
	ELSE
	BEGIN
		INSERT INTO eb_usergroup (name,description,eb_del) VALUES (@_name,@_description,'F');
		SELECT @gid = SCOPE_IDENTITY();
		INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT value, @gid,@_userid,CURRENT_TIMESTAMP AT TIME ZONE 'UTC' FROM 
				(SELECT value FROM #users)userid;
	END;
	EXEC eb_security_constraints @_userid, @gid, @_constraints_add, @_constraints_del, @add_no OUTPUT, @del_no OUTPUT;
	SELECT @gid;
END;
