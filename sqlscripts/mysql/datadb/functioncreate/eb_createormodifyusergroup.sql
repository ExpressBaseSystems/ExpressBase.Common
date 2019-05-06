﻿CREATE PROCEDURE eb_createormodifyusergroup(IN userid integer,
    IN id integer,
    IN name text,
    IN description text,
    IN users text,
    IN ipconstrnw text,
    IN ipconstrold text,
    IN dtconstrnw text,
    IN dtconstrold text,
    OUT out_gid integer)
BEGIN
DECLARE gid integer;
declare nwip text;
declare nwdesc text;
declare nwtitle text;
declare nwdesc1 text;
declare nwtype int;
declare nwstart datetime default now();
declare nwend datetime default now();
declare nwdays int;
 set gid=id;
drop temporary table if exists temp_array_table;
drop temporary table if exists users;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(id int auto_increment primary key, value integer);
	CALL STR_TO_TBL(users);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS users SELECT id,`value` FROM temp_array_table;
 
    drop temporary table if exists ipdel;
	CALL STR_TO_TBL(ipconstrold);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS ipdel SELECT `value` FROM temp_array_table;    
   
   drop temporary table if exists dtdel;
  	CALL STR_TO_TBL(dtconstrold);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS dtdel SELECT `value` FROM temp_array_table;    
     
	drop temporary table if exists temp_array_table;
	drop table if exists ipnew;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL_GRP(ipconstrnw);  -- fill to temp_array_table
	CREATE TABLE IF NOT EXISTS ipnew(id int auto_increment primary key,value text) SELECT `value` FROM temp_array_table;    
 
    drop table if exists dtnew;
	CALL STR_TO_TBL_GRP(dtconstrnw);  -- fill to temp_array_table
	CREATE TABLE IF NOT EXISTS dtnew(id int auto_increment primary key,value text) SELECT `value` FROM temp_array_table;    
   
    IF id > 0 THEN
   
	UPDATE eb_usergroup eu SET eu.name=name, eu.description=description WHERE eu.id=id;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT `value`,id,userid,NOW() FROM 
   		(select `value` from users where `value` not in 
			(SELECT eu2g2.userid from eb_user2usergroup eu2g2 WHERE eu2g2.groupid = id AND eu2g2.eb_del = 'F')) AS userid;
	UPDATE eb_user2usergroup eu2g SET eu2g.eb_del = 'T',eu2g.revokedby = userid,eu2g.revokedat =NOW() WHERE eu2g.groupid = id 
		AND eu2g.eb_del = 'F' AND eu2g.userid IN(
		select * from (SELECT eu2g1.userid from eb_user2usergroup eu2g1 WHERE eu2g1.groupid = id AND eu2g1.eb_del = 'F' and eu2g1.userid not in 
	 (select `value` from users))as a);
	-- SET SQL_SAFE_UPDATES=0;
	UPDATE eb_constraints_ip eci SET eci.eb_del = 'T', eci.eb_revoked_by = userid, eci.eb_revoked_at = NOW()
		WHERE eci.usergroup_id = id AND eci.eb_del = 'F' AND eci.id IN(select `value` from ipdel);
		-- SET SQL_SAFE_UPDATES=0;
	UPDATE eb_constraints_datetime ecd SET ecd.eb_del = 'T', ecd.eb_revoked_by = userid, ecd.eb_revoked_at = NOW()
		WHERE ecd.usergroup_id = id AND ecd.eb_del = 'F' AND ecd.id IN(SELECT `value` from dtdel);

ELSE

	INSERT INTO eb_usergroup (name,description,eb_del) VALUES (name,description,'F') ;
    select last_insert_id() from eb_usergroup INTO gid;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT `value`, gid,userid,NOW() 
    	FROM (select `value` from users) AS userid;

END IF;

INSERT INTO eb_constraints_ip(usergroup_id, ip, description, eb_created_by, eb_created_at, eb_del)
	select gid, a.nwip, a.nwdesc, userid, NOW(), 'F' from (
    select i1.`value` as nwip,i2.`value` as nwdesc from ipnew i1,ipnew i2 where i1.id=1 and i2.id=2)as a;

INSERT INTO eb_constraints_datetime(usergroup_id, title, description, type, start_datetime, end_datetime, days_coded, eb_created_by, eb_created_at, eb_del)
	select gid, b.nwtitle, b.nwdesc1, b.nwtype, b.nwstart, b.nwend, b.nwdays, userid, NOW(), 'F' from(
    select d1.`value` as nwtitle,d2.`value` as nwdesc1,convert(d3.`value`,unsigned int) as nwtype,
    convert(d4.`value`,datetime) as nwstart,convert(d5.`value`,datetime) as nwend,
    convert(d6.`value`,unsigned integer) as nwdays
    from dtnew d1,dtnew d2,dtnew d3,dtnew d4,dtnew d5,dtnew d6 where d1.id=1 and d2.id=2 and d3.id=3 and d4.id=4 
    and d5.id=5 and d6.id=6
    )as b; 
	
 SELECT gid into out_gid;

END