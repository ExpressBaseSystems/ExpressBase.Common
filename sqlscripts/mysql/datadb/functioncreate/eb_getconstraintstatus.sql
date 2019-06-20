CREATE FUNCTION eb_getconstraintstatus(in_userid INTEGER, in_ip TEXT) RETURNS int(11)
    READS SQL DATA
    DETERMINISTIC
BEGIN
DECLARE ipfound BOOL;
DECLARE countdtc INTEGER;
DECLARE dtemp INTEGER;
DECLARE ttemp INTEGER;
DECLARE arrip1 TEXT;
DECLARE c INTEGER;

-- IP CONSTRAINT
DROP TEMPORARY TABLE IF EXISTS arrip;
	CREATE TEMPORARY TABLE IF NOT EXISTS arrip(id INTEGER AUTO_INCREMENT PRIMARY KEY, value INTEGER);
    
	IF in_ip IS NOT NULL THEN
    
 INSERT INTO arrip(value)
		SELECT ip  FROM eb_constraints_ip 
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' ;           
       
       SELECT COUNT(id) INTO c FROM arrip ;
		IF c <> 0 THEN 
    		SELECT in_ip = ANY (SELECT `value` FROM arrip) INTO ipfound;
			IF NOT ipfound THEN
				RETURN 201; -- into out_r; 
			END IF;
		END IF;
	END IF;
    
    -- DATETIME CONSTRAINT
	SET countdtc = 0;
	SELECT (SELECT COUNT(*) FROM eb_constraints_datetime
	WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
		WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F') INTO countdtc;
    
    IF countdtc > 0 THEN
		SELECT (SELECT COUNT(*) FROM eb_constraints_datetime
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' AND type = 1 AND 
		start_datetime < CURRENT_TIMESTAMP() AND end_datetime > CURRENT_TIMESTAMP()) INTO dtemp;
        
        SELECT (SELECT COUNT(*) FROM eb_constraints_datetime
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' AND type = 2 AND 
		CONVERT(start_datetime, TIME) < CONVERT(CURRENT_TIMESTAMP(), TIME) AND
		CONVERT(end_datetime, TIME) > CONVERT(CURRENT_TIMESTAMP(), TIME) AND 
		(days_coded & POW(2, DAYOFWEEK(CURRENT_TIMESTAMP())))> 0 )INTO ttemp;
		
		IF NOT(dtemp > 0 OR ttemp > 0) THEN
			RETURN 202;
		END IF;	
		
	END IF;
    
RETURN 100 ;
END