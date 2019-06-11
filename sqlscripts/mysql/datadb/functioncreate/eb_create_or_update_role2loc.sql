CREATE PROCEDURE eb_create_or_update_role2loc(IN rid INTEGER,
IN createdby INTEGER,
IN locations_str TEXT
)
BEGIN
DECLARE a INTEGER;
DROP TEMPORARY TABLE IF EXISTS temp_array_table;
DROP TEMPORARY TABLE IF EXISTS location_tmp;

CREATE TEMPORARY TABLE temp_array_table(value INTEGER);
	CALL STR_TO_TBL(locations_str);  
	CREATE TEMPORARY TABLE IF NOT EXISTS location_tmp SELECT `value` FROM temp_array_table;

UPDATE eb_role2location er2l SET er2l.eb_del = 'T', er2l.eb_revokedat = NOW(), er2l.eb_revokedby = createdby 
	WHERE er2l.roleid = rid AND er2l.eb_del = 'F' AND er2l.locationid IN(
		SELECT * FROM (SELECT er2l1.locationid FROM eb_role2location er2l1 WHERE er2l1.roleid = rid AND er2l1.eb_del = 'F' AND er2l1.locationid NOT IN(
       SELECT `value` FROM location_tmp))AS t) ;
       
  INSERT INTO eb_role2location(locationid, roleid, eb_createdby, eb_createdat) 
    SELECT `value`, rid, createdby, NOW() FROM (SELECT `value` FROM location_tmp
        WHERE `value` NOT IN (SELECT er2l2.locationid FROM eb_role2location er2l2 WHERE er2l2.roleid = rid AND er2l2.eb_del = 'F' )) AS a ;
   
END