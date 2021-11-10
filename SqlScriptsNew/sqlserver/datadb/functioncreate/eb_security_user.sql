CREATE OR ALTER PROCEDURE eb_security_user
	@_userid int,
	@_id int,
	@_fullname varchar(max),
	@_nickname varchar(max),
	@_email varchar(max),
	@_pwd varchar(max),
	@_dob date,
	@_sex varchar(max),
	@_alternateemail varchar(max),
	@_phnoprimary varchar(max),
	@_phnosecondary varchar(max),
	@_landline varchar(max),
	@_phextension varchar(max),
	@_fbid varchar(max),
	@_fbname varchar(max),
	@_roles_temp varchar(max),
	@_group_temp varchar(max),
	@_statusid int,
	@_hide varchar(max),
	@_anonymoususerid int,
	@_preferences varchar(max),
	@_constraints_add varchar(max),
	@_constraints_del varchar(max)
AS
BEGIN
	DECLARE @uid int = @_id;
	DECLARE @_keyid int;
	DECLARE @_add_data varchar(max);
	DECLARE @_delete_ids varchar(max);
	DECLARE @add_no varchar(max);
	DECLARE @del_no varchar(max);

	DROP TABLE IF EXISTS _roles;
	CREATE TABLE _roles (value int);
	INSERT INTO _roles
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@_roles_temp,',');

	DROP TABLE IF EXISTS _group;
	CREATE TABLE _group (value int);
	INSERT INTO _group
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@_group_temp,',');

	IF @_id > 1 
	BEGIN
		IF @_statusid > 99  
		BEGIN
			SET @_statusid = @_statusid - 100;
		END;
		ELSE
		BEGIN
			INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (@_id, @_statusid, @_userid, CURRENT_TIMESTAMP);
		END;

		UPDATE eb_users SET fullname= @_fullname, nickname=@_nickname, email=@_email, dob=@_dob, sex=@_sex, alternateemail=@_alternateemail, phnoprimary=@_phnoprimary, phnosecondary=@_phnosecondary, landline=@_landline, phextension=@_phextension, fbid=@_fbid, fbname=@_fbname, statusid=@_statusid, hide=@_hide, preferencesjson=@_preferences WHERE id = @_id;
		
		INSERT INTO eb_role2user(role_id,user_id,createdby,createdat)
			SELECT 
				value,@_id,@_userid,CURRENT_TIMESTAMP 
			FROM
			(
				SELECT value FROM _roles WHERE value 
				NOT IN (SELECT role_id from eb_role2user WHERE user_id = @_id AND eb_del = 'F')
			)roleid;

		UPDATE 
			eb_role2user 
		SET 
			eb_del = 'T',revokedby = @_userid,revokedat =CURRENT_TIMESTAMP 
		WHERE 
			user_id = @_id AND eb_del = 'F' AND role_id IN( SELECT * FROM(
				SELECT role_id FROM eb_role2user WHERE user_id =@_id AND eb_del = 'F' AND role_id NOT IN( 
		SELECT value FROM _roles))AS q1) ;

		INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT 
					@_id,value,@_userid,CURRENT_TIMESTAMP 
				FROM 
					(SELECT value FROM _group WHERE value NOT IN
							(SELECT groupid from eb_user2usergroup WHERE userid = @_id AND eb_del = 'F')) AS groupid;
		UPDATE 
			eb_user2usergroup 
		SET 
			eb_del = 'T',revokedby = @_userid,revokedat =CURRENT_TIMESTAMP 
		WHERE 
			userid = @_id AND eb_del = 'F' AND groupid IN(SELECT * FROM (
				SELECT groupid from eb_user2usergroup WHERE userid = @_id AND eb_del = 'F' AND groupid NOT IN (
					SELECT value FROM _group))as q2);
	END;
	ELSE
	BEGIN
		INSERT INTO eb_users (fullname, nickname, email, pwd, dob, sex, alternateemail, phnoprimary, phnosecondary, landline, phextension, fbid, fbname, createdby, createdat, statusid, hide, preferencesjson) 
		VALUES (@_fullname, @_nickname, @_email, @_pwd, @_dob, @_sex, @_alternateemail, @_phnoprimary, @_phnosecondary, @_landline, @_phextension, @_fbid, @_fbname, CAST(@_userid AS varchar(3)) , CAST(CURRENT_TIMESTAMP as varchar(max)), @_statusid, @_hide, @_preferences);
		SET @uid = SCOPE_IDENTITY();
		
		INSERT INTO eb_role2user (role_id,user_id,createdby,createdat) 
			SELECT 
				value, @uid,@_userid,CURRENT_TIMESTAMP 
			FROM (SELECT value FROM _roles) AS roleid;

		INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) 
			SELECT 
				@uid, value,@_userid,CURRENT_TIMESTAMP 
			FROM (SELECT value FROM _group) AS groupid;

		IF @_id > 0 
		BEGIN
			UPDATE eb_usersanonymous SET modifiedby = @_userid, modifiedat = CURRENT_TIMESTAMP, ebuserid = @uid
				WHERE id = @_anonymoususerid;
		END;
		INSERT INTO eb_userstatus(userid, statusid, createdby, createdat) VALUES (@uid, @_statusid, @_userid, CURRENT_TIMESTAMP);
	END;

	SET @_keyid = @uid;
	SET @_add_data = @_constraints_add;
	SET @_delete_ids	= @_constraints_del;	

	EXEC eb_security_constraints @_userid, @_keyid, @_add_data, @_delete_ids, @add_no OUTPUT, @del_no OUTPUT;
 RETURN @uid;
END
