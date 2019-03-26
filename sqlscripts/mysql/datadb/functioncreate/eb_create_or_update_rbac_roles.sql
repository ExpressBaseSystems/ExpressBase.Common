CREATE PROCEDURE eb_create_or_update_rbac_roles(roleid integer,
    applicationid integer,
    userid integer,
    role_name text,
    description text,
    isanonym text,
    users text,
    dependantroles text,
    permissions text,
    locations text)
BEGIN
DECLARE rid INTEGER;
declare users_str text;
declare dependantroles_str text;
declare permissions_str text;
declare locations_str text;

set rid := roleid;

drop temporary table if exists temp_array_table;
CREATE TEMPORARY TABLE if not exists temp_array_table( value integer);
	CALL STR_TO_TBL(users);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _users SELECT `value` FROM temp_array_table;

drop temporary table if exists temp_array_table;
 CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value integer);
	CALL STR_TO_TBL(dependantroles);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _dependantroles SELECT `value` FROM temp_array_table;
  
  drop temporary table if exists temp_array_table;
   CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value integer);
	CALL STR_TO_TBL(permissions);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _permissions SELECT `value` FROM temp_array_table;
      
drop temporary table if exists temp_array_table;
 CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value integer);
	CALL STR_TO_TBL(locations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _locations SELECT `value` FROM temp_array_table;
 

select group_concat(`value`) from _permissions into permissions_str;
call eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, permissions_str, roleid);
select rid from eb_create_or_update_role_tmp into rid;
  
IF isanonym = 'T' THEN
	set users := '1';
	set dependantroles := '';
END IF;

select group_concat(`value`) from _users into users_str;
select eb_create_or_update_role2user(rid, userid, users_str);

select group_concat(`value`) from _dependantroles into dependantroles_str;
select eb_create_or_update_role2role(rid, userid, dependantroles_str);

select group_concat(`value`) from _locations into locations_str;
select	eb_create_or_update_role2loc(rid, userid, _locations);


select 0;
END

