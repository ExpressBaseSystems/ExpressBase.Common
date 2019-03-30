CREATE PROCEDURE eb_create_or_update_rbac_roles(in roleid integer,
    in applicationid integer,
    in userid integer,
    in role_name text,
    in description text,
    in isanonym text,
    in users text,
    in dependantroles text,
    in permissions text,
    in locations text,
    out out_r integer)
BEGIN
DECLARE rid INTEGER;
declare users_str text;
declare dependantroles_str text;
declare permissions_str text;
declare locations_str text;
declare a integer;
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
   CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value text);
	CALL STR_TO_TBL(permissions);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _permissions SELECT `value` FROM temp_array_table;
      
drop temporary table if exists temp_array_table;
 CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table( value integer);
	CALL STR_TO_TBL(locations);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS _locations SELECT `value` FROM temp_array_table;
 

select group_concat(`value`) from _permissions into permissions_str;
call eb_create_or_update_role(applicationid, role_name, description, isanonym, userid, permissions_str, roleid,@out_rid);
select @out_rid into rid;
  
IF isanonym = 'T' THEN
	set users := '1';
	set dependantroles := '';
END IF;

select group_concat(`value`) from _users into users_str;
call eb_create_or_update_role2user(rid, userid, users_str,@r1);

select group_concat(`value`) from _dependantroles into dependantroles_str;
call eb_create_or_update_role2role(rid, userid, dependantroles_str,@r2);

select group_concat(`value`) from _locations into locations_str;
call eb_create_or_update_role2loc(rid, userid, locations_str,@r3);

set a=0;
select a into out_r ;
END