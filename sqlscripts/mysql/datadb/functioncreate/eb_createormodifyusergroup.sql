CREATE PROCEDURE eb_createormodifyusergroup(IN userid integer,
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

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS users;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value integer);
	CALL STR_TO_TBL(users);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS users SELECT `value` FROM temp_array_table;
 
    DROP TEMPORARY TABLE IF EXISTS ipdel;
	CALL STR_TO_TBL(ipconstrold);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS ipdel SELECT `value` FROM temp_array_table;    
   
   DROP TEMPORARY TABLE IF EXISTS dtdel;
  	CALL STR_TO_TBL(dtconstrold);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS dtdel SELECT `value` FROM temp_array_table;    
     
	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
	DROP temporary TABLE IF EXISTS ipnew;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value TEXT);
	CALL STR_TO_TBL_GRP(ipconstrnw);  -- fill to temp_array_table
	CREATE temporary TABLE IF NOT EXISTS ipnew(id int auto_increment primary key,value text) SELECT `value` FROM temp_array_table;    
 
    DROP TABLE IF EXISTS dtnew;
	CALL STR_TO_TBL_GRP(dtconstrnw);  -- fill to temp_array_table
	CREATE temporary TABLE IF NOT EXISTS dtnew(id int auto_increment primary key,value text) SELECT `value` FROM temp_array_table;    
   
    IF id > 0 THEN
   
	UPDATE eb_usergroup eu SET eu.name=name, eu.description=description WHERE eu.id=id;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT `value`,id,userid,NOW() FROM 
   		(SELECT `value` FROM users WHERE `value` NOT IN 
			(SELECT eu2g2.userid from eb_user2usergroup eu2g2 WHERE eu2g2.groupid = id AND eu2g2.eb_del = 'F')) AS userid;
	UPDATE eb_user2usergroup eu2g SET eu2g.eb_del = 'T',eu2g.revokedby = userid,eu2g.revokedat =NOW() WHERE eu2g.groupid = id 
		AND eu2g.eb_del = 'F' AND eu2g.userid IN(
		SELECT * FROM (SELECT eu2g1.userid FROM eb_user2usergroup eu2g1 WHERE eu2g1.groupid = id AND eu2g1.eb_del = 'F' and eu2g1.userid not in 
	 (select `value` from users))as a);
	-- SET SQL_SAFE_UPDATES=0;
	UPDATE eb_constraints_ip eci SET eci.eb_del = 'T', eci.eb_revoked_by = userid, eci.eb_revoked_at = NOW()
		WHERE eci.usergroup_id = id AND eci.eb_del = 'F' AND eci.id IN(select `value` from ipdel);
		-- SET SQL_SAFE_UPDATES=0;
	UPDATE eb_constraints_datetime ecd SET ecd.eb_del = 'T', ecd.eb_revoked_by = userid, ecd.eb_revoked_at = NOW()
		WHERE ecd.usergroup_id = id AND ecd.eb_del = 'F' AND ecd.id IN(SELECT `value` from dtdel);

ELSE

	INSERT INTO eb_usergroup (name,description,eb_del) VALUES (name,description,'F') ;
    select last_insert_id() INTO gid;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT `value`, gid,userid,NOW() 
    	FROM (select `value` from users) AS userid;

END IF;
if(ipconstrnw !="") then

	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
	DROP TEMPORARY TABLE IF EXISTS nwip_temp;
		SELECT i1.`value` FROM ipnew i1 WHERE i1.id=1 INTO @tmp_nwip;
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value text);
	CALL STR_TO_TBL(@tmp_nwip);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwip_temp(id integer auto_increment primary key, value text) 
		SELECT `value` FROM temp_array_table;

	DROP TEMPORARY TABLE IF EXISTS nwdesc_temp;
	SELECT i1.`value` FROM ipnew i1 WHERE i1.id=2 INTO @tmp_nwips;
	CALL STR_TO_TBL(@tmp_nwips);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwdesc_temp(id integer auto_increment primary key, value text) 
		SELECT `value` FROM temp_array_table;

INSERT INTO eb_constraints_ip(usergroup_id, ip, description, eb_created_by, eb_created_at, eb_del)
	select gid, n.nwip, n.nwdesc, userid, NOW(), 'F' from (
    select i1.`value` as nwip,i2.`value` as nwdesc from nwip_temp i1,nwdesc_temp i2 WHERE i1.id = i2.id)as n;
    
end if;   

if(dtconstrnw !="") then
	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
	DROP TEMPORARY TABLE IF EXISTS nwtitle_temp;
	CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table(value text);
	SELECT d1.`value` FROM dtnew d1 WHERE d1.id=1 into @tmp_nwtitle;
	CALL STR_TO_TBL(@tmp_nwtitle);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwtitle_temp(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_array_table;

DROP TEMPORARY TABLE IF EXISTS nwdescd_temp;
	SELECT d1.`value` FROM dtnew d1 WHERE d1.id=2 into @tmp_nwdescd;
	CALL STR_TO_TBL(@tmp_nwdescd);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwdescd_temp(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_array_table;

DROP TEMPORARY TABLE IF EXISTS nwtype_temp;
	SELECT d1.`value` FROM dtnew d1 WHERE d1.id=3 into @tmp_nwtype;
	CALL STR_TO_TBL(@tmp_nwtype);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwtype_temp(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_array_table;

DROP TEMPORARY TABLE IF EXISTS nwdays_temp;
	SELECT d1.`value` FROM dtnew d1 WHERE d1.id=6 into @tmp_nwdays;
	CALL STR_TO_TBL(@tmp_nwdays);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwdays_temp(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_array_table;

DROP TEMPORARY TABLE IF EXISTS nwstart_temp;
	SELECT d1.`value` FROM dtnew d1 WHERE d1.id=4 into @tmp_nwstart;
	CALL STR_TO_TBL(@tmp_nwstart);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwstart_temp(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_array_table;
    
DROP TEMPORARY TABLE IF EXISTS nwend_temp;
	SELECT d1.`value` FROM dtnew d1 WHERE d1.id=5 into @tmp_nwend;
	CALL STR_TO_TBL(@tmp_nwend);
	CREATE TEMPORARY TABLE IF NOT EXISTS nwend_temp(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_array_table; 
 
INSERT INTO eb_constraints_datetime(usergroup_id, title, description, type, start_datetime, end_datetime, days_coded, eb_created_by, eb_created_at, eb_del)
	SELECT gid, d.nwtitle, d.nwdescd, d.nwtype, d.nwstart, d.nwend, d.nwdays, userid, NOW(), 'F' FROM(
    SELECT d1.`value` as nwtitle,d2.`value` as nwdescd,convert(d3.`value`,unsigned int) as nwtype,
    convert(d4.`value`,datetime) as nwstart,convert(d5.`value`,datetime) as nwend,convert(d6.`value`,unsigned int) as nwdays
    FROM nwtitle_temp d1,nwdescd_temp d2,nwtype_temp d3,nwstart_temp d4,nwend_temp d5,nwdays_temp d6
    WHERE d1.id = d2.id AND d1.id = d3.id AND d1.id = d4.id AND d1.id = d5.id AND d1.id = d6.id 
    AND d2.id = d3.id AND d2.id = d4.id AND d2.id = d5.id AND d2.id = d6.id 
    AND d3.id = d4.id AND d3.id = d5.id AND d3.id = d6.id 
    AND d4.id = d5.id AND d4.id = d6.id 
    AND d5.id = d6.id
    )as d; 
end if;	
 SELECT gid into out_gid;

END