CREATE PROCEDURE eb_create_or_update_role(in application_id integer,
    in role_name text,
    in role_desc text,
    in isanonym text,
    in userid integer,
    in permissions text,
    in roleid integer,
    out out_rid integer)
BEGIN
DECLARE rid INTEGER; 
DECLARE errornum INTEGER;
-- DECLARE CONTINUE HANDLER FOR SQLSTATE '23505' select 0; 

if roleid=0 then set roleid=null; end if;

drop temporary table if exists eb_create_or_update_role_tmp;
drop temporary table if exists temp_array_table;
drop temporary table if exists permissions_tmp;
 
CREATE TEMPORARY TABLE temp_array_table(value TEXT);
	CALL STR_TO_TBL(permissions);  
	CREATE TEMPORARY TABLE IF NOT EXISTS permissions_tmp SELECT `value` FROM temp_array_table;

set errornum = 0;

IF roleid = null THEN   
        INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous) VALUES (role_name,application_id,role_desc,isanonym);
        select last_insert_id() INTO rid;
    ELSE
        UPDATE eb_roles SET role_name= role_name, applicationid= application_id, description = role_desc, is_anonymous = isanonym WHERE id = roleid;
      set  rid = roleid;
    END IF;

    UPDATE eb_role2permission 
    SET 
        eb_del = 'T',revokedat = NOW(),revokedby = userid 
    WHERE 
        role_id = roleid AND eb_del = 'F' AND permissionname IN(
         select * from(select permissionname from eb_role2permission WHERE role_id = roleid AND eb_del = 'F' and  permissionname
        not in (select `value` from  permissions_tmp))as a);
            
INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
         `value`, rid, userid, NOW(), 
        cast( SPLIT_STR(`value`,'-',4) as unsigned int),
        cast( SPLIT_STR(`value`,'-',3) as unsigned int)
    FROM ( (select `value` from permissions_tmp where `value` not in 
    (select permissionname from eb_role2permission WHERE role_id = roleid AND eb_del = 'F')) )as a;
    
    -- (select `value` as permissionname from permissions_tmp where permissionname not in 
  --  (select permissionname from eb_role2permission WHERE role_id = roleid AND eb_del = 'F')
  --   )as p ;
 
select rid into out_rid;
-- EXCEPTION WHEN unique_violation THEN errornum := 23505;
END