CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_createormodifyusergroup`(IN _userid integer,
    IN _id integer,
    IN _name text,
    IN _description text,
    IN _users text,
    IN _ipconstr_new text,
    IN _ipconstr_old text,
    IN _dtconstr_new text,
    IN _dtconstr_old text)
BEGIN
DECLARE gid integer;

drop temporary table if exists temp_array_table1;
drop temporary table if exists users;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table1(id int auto_increment, value integer);
	CALL STR_TO_TBL(_users);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS users SELECT `value` FROM temp_array_table1;
  
 
  drop temporary table if exists temp_array_table2;
drop temporary table if exists ipnew;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table2(id int auto_increment,value TEXT);
	CALL STR_TO_TBL(_ipconstr_new);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS ipnew SELECT `value` FROM temp_array_table2;    
 
 drop temporary table if exists temp_array_table3;
  drop temporary table if exists dtnew;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table3(id int auto_increment,value TEXT);
	CALL STR_TO_TBL(_dtconstr_new);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS dtnew SELECT `value` FROM temp_array_table3;    
 
drop temporary table if exists temp_array_table4;
 drop temporary table if exists ipdel;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table4(id int auto_increment,value integer);
	CALL STR_TO_TBL(_ipconstr_old);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS ipdel SELECT `value` FROM temp_array_table4;    
   
   drop temporary table if exists temp_array_table5;
 drop temporary table if exists dtdel;
CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table5(id int auto_increment,value integer);
	CALL STR_TO_TBL(_dtconstr_old);  -- fill to temp_array_table
	CREATE TEMPORARY TABLE IF NOT EXISTS dtdel SELECT `value` FROM temp_array_table5;    
  
set gid=_id;


    IF _id > 0 THEN
	UPDATE eb_usergroup SET name=_name, description=_description WHERE id=_id;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT `value`,_id,_userid,NOW() FROM 
   		(select `value` from users where `value` not in 
			(SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F')) AS userid;
	UPDATE eb_user2usergroup SET eb_del = 'T',revokedby = _userid,revokedat =NOW() WHERE groupid = _id AND eb_del = 'F' AND userid IN(
		SELECT userid from eb_user2usergroup WHERE groupid = _id AND eb_del = 'F' and userid not in 
	 (select `value` from users));
	
	UPDATE eb_constraints_ip SET eb_del = 'T', eb_revoked_by = _userid, eb_revoked_at = NOW()
		WHERE usergroup_id = _id AND eb_del = 'F' AND id IN(select `value` from ipdel);
		
	UPDATE eb_constraints_datetime SET eb_del = 'T', eb_revoked_by = _userid, eb_revoked_at = NOW()
		WHERE usergroup_id = _id AND eb_del = 'F' AND id IN(SELECT `value` from dtdel);

ELSE

	INSERT INTO eb_usergroup (name,description,eb_del) VALUES (_name,_description,'F') ;
    select last_insert_id() INTO gid;
	INSERT INTO eb_user2usergroup(userid,groupid,createdby,createdat) SELECT `value`, gid,_userid,NOW() 
    	FROM (select `value` from users) AS userid;

END IF;

INSERT INTO eb_constraints_ip(usergroup_id, ip, description, eb_created_by, eb_created_at, eb_del)
	SELECT gid, nwip, nwdesc, _userid, NOW(), 'F'
		FROM  ( (select `value` as nwip from ipnew where id=1) as nwip, (select `value` as nwdesc from ipnew where id=2)as nwdesc ) ;

INSERT INTO eb_constraints_datetime(usergroup_id, title, description, type, start_datetime, end_datetime, days_coded, eb_created_by, eb_created_at, eb_del)
	SELECT gid, nwtitle, nwdesc, nwtype, nwstart, nwend, nwdays, _userid, NOW(), 'F' 
		FROM ((select `value` as nwtitle from dtnew where id=1)as nwtitle,
					(select `value` as nwdesc from dtnew where id=2)as nwdesc,
					(select convert(`value`,unsigned int) as nwtype from dtnew where id=3)as nwtype,
					(select convert(`value`,datetime) as nwstart from dtnew where id=4)as nwstart,
					(select convert(`value`,datetime) as nwend from dtnew where id=5)as nwend,
					(select convert(`value`,unsigned integer) as nwdays from dtnew where id=6)as nwdays
					);

 SELECT gid;

END