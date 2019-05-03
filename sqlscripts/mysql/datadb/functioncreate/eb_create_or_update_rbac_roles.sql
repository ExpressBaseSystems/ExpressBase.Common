CREATE PROCEDURE eb_create_or_update_rbac_roles(in role_id integer,
    in applicationid integer,
    in createdby integer,
    in role_name text,
    in description text,
    in is_anonym text,
    in users text,
    in dependants text,
    in permission text,
    in locations text,
    out out_r integer)
BEGIN
DECLARE rid INTEGER;
declare a integer;
set rid = role_id;

call eb_create_or_update_role(applicationid, role_name, description, is_anonym, createdby, permission, role_id,@out_rid);
 select @out_rid into rid;

IF is_anonym = "T" THEN
	set users = "1";
	set dependants = "";
END IF;

 call eb_create_or_update_role2user(rid, createdby, users);

 call eb_create_or_update_role2role(rid, createdby, dependants);

 call eb_create_or_update_role2loc(rid, createdby, locations);

set a=0;
select a into out_r ;
END