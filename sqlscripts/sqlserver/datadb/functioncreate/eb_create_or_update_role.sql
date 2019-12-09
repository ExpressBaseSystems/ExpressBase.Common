CREATE OR ALTER     PROCEDURE eb_create_or_update_role
	@application_id int,
	@role_name varchar(max),
	@role_desc varchar(max),
	@isanonym varchar,
	@userid integer,
	@permissions varchar(max),
	@roleid int
	
AS
BEGIN
	DECLARE @rid int, @errornum int = 0;
	SET @errornum = 0;
	--SET NOCOUNT ON;
	IF @roleid = 0 
		BEGIN
			INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous) VALUES (@role_name,@application_id,@role_desc,@isanonym) ;
			SET @rid = SCOPE_IDENTITY();
		END;	
   ELSE
		BEGIN
        UPDATE eb_roles SET role_name= @role_name, applicationid= @application_id, description = @role_desc, is_anonymous = @isanonym WHERE id = @roleid;
        SET @rid = @roleid;
	END;
	
	DROP TABLE IF EXISTS #permissions_tmp;
	CREATE TABLE #permissions_tmp(value varchar(max));
	INSERT INTO #permissions_tmp 
		SELECT * FROM [dbo].[eb_str_to_tbl_util](@permissions,',');
	
	UPDATE eb_role2permission 
    SET 
        eb_del = 'T',revokedat = CURRENT_TIMESTAMP,revokedby = @userid 
    WHERE 
        role_id = @roleid AND eb_del = 'F' AND permissionname IN(
            SELECT permissionname FROM eb_role2permission WHERE role_id = @roleid AND eb_del = 'F'  
				AND permissionname NOT IN(  
					SELECT value FROM #permissions_tmp));
	
	INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
        s.value, @rid, @userid, CURRENT_TIMESTAMP,
		(select cast(PARSENAME(REPLACE(s.value,'-','.'),1)as int)),
		(select cast(PARSENAME(REPLACE(s.value,'-','.'),2)as int))       
    FROM (SELECT value FROM #permissions_tmp WHERE value NOT IN(
               SELECT permissionname FROM eb_role2permission WHERE role_id = @roleid AND eb_del = 'F'))as s;
  
 RETURN @rid;

END;