CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_create_or_update_role2loc`(_roleid integer,
_userid integer,
_locations text)
BEGIN
drop temporary table if exists temp_array_table;
drop temporary table if exists location_tmp;

CREATE TEMPORARY TABLE temp_array_table(value integer);
	CALL STR_TO_TBL(_locations);  
	CREATE TEMPORARY TABLE IF NOT EXISTS location_tmp SELECT `value` FROM temp_array_table;

UPDATE eb_role2location SET eb_del = 'T', eb_revokedat = NOW(), eb_revokedby = _userid 
	WHERE roleid = _roleid AND eb_del = 'F' AND locationid IN(select * from (SELECT locationid FROM eb_role2location WHERE roleid = _roleid AND eb_del = 'F')as q)
       and locationid not in(select * from location_tmp) ;
       
  INSERT INTO eb_role2location(locationid, roleid, eb_createdby, eb_createdat) 
    SELECT `value`, _roleid, _userid, NOW() FROM (SELECT `value` from location_tmp
        where `value` not in (SELECT locationid FROM eb_role2location WHERE roleid = _roleid AND eb_del = 'F' ) ) as a ;
     
END