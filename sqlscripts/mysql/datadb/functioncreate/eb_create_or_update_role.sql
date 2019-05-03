CREATE PROCEDURE eb_create_or_update_role(in applicationid integer,
    in role_name text,
    in description text,
    in is_anonym text,
    in createdby integer,
    in permissions_str text,
    in role_id integer,
    out out_rid integer)
BEGIN
DECLARE rid INTEGER; 
DECLARE errornum INTEGER;
-- DECLARE CONTINUE HANDLER FOR SQLSTATE '23505' select 0; 

if role_id=0 then set role_id=null; end if;

drop temporary table if exists eb_create_or_update_role_tmp;
drop temporary table if exists temp_array_table;
drop temporary table if exists permissions_tmp;
 
CREATE TEMPORARY TABLE temp_array_table(value TEXT);
	CALL STR_TO_TBL(permissions_str);  
	CREATE TEMPORARY TABLE IF NOT EXISTS permissions_tmp SELECT `value` FROM temp_array_table;

set errornum = 0;

IF role_id is null THEN   
        INSERT INTO eb_roles (role_name,applicationid,description,is_anonymous) VALUES (role_name,applicationid,description,is_anonym);
        select last_insert_id() from eb_roles INTO rid;
    ELSE
        UPDATE eb_roles er SET er.role_name= role_name, er.applicationid= applicationid, er.description = description, er.is_anonymous = is_anonym WHERE er.id = role_id;
      set  rid = role_id;
    END IF;

    UPDATE eb_role2permission er2p
    SET 
        er2p.eb_del = 'T',er2p.revokedat = NOW(),er2p.revokedby = createdby 
    WHERE 
        er2p.role_id = role_id AND er2p.eb_del = 'F' AND er2p.permissionname IN(
         select * from(select er2p1.permissionname from eb_role2permission er2p1 WHERE er2p1.role_id = role_id AND er2p1.eb_del = 'F' and  er2p1.permissionname
        not in (select `value` from  permissions_tmp))as a);
            
INSERT INTO eb_role2permission 
        (permissionname, role_id, createdby, createdat, op_id, obj_id) 
    SELECT 
         `value`, rid, createdby, NOW(), 
        cast( SPLIT_STR(`value`,'-',4) as unsigned int),
        cast( SPLIT_STR(`value`,'-',3) as unsigned int)
    FROM ( (select `value` from permissions_tmp where `value` not in 
    (select er2p2.permissionname from eb_role2permission er2p2 WHERE er2p2.role_id = role_id AND er2p2.eb_del = 'F')) )as a;
        
select rid into out_rid;
-- EXCEPTION WHEN unique_violation THEN errornum := 23505;
END