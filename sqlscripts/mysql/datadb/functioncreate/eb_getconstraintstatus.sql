CREATE DEFINER=`josevin`@`%` FUNCTION `eb_getconstraintstatus`(in_userid integer,
    in_ip text) RETURNS int(11)
BEGIN
-- DECLARE arrip TEXT[];
DECLARE ipfound BOOL;
DECLARE countdtc INTEGER;
DECLARE dtemp INTEGER;
DECLARE ttemp INTEGER;

-- IP CONSTRAINT
drop temporary table if exists arrip;
create temporary table arrip(value text);
	IF in_ip IS NOT NULL THEN
		insert into arrip(value)
			SELECT ip FROM eb_constraints_ip 
			WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
				WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F';
		IF (select count(value) from arrip) <> 0 THEN 
    		SELECT in_ip = ANY (select value from arrip) INTO ipfound;
			IF NOT ipfound THEN
				RETURN 201; 
			END IF;
		END IF;
	END IF;
    
    -- DATETIME CONSTRAINT
	set countdtc = 0;
	select (SELECT COUNT(*) FROM eb_constraints_datetime
	WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
		WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F') INTO countdtc;
    
    IF countdtc > 0 THEN
		select (SELECT COUNT(*) FROM eb_constraints_datetime
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' AND type = 1 AND 
		start_datetime < CURRENT_TIMESTAMP() AND end_datetime > CURRENT_TIMESTAMP()) INTO dtemp;
        
        select (SELECT COUNT(*) FROM eb_constraints_datetime
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' AND type = 2 AND 
		start_datetime < CURRENT_TIMESTAMP() AND
		end_datetime > CURRENT_TIMESTAMP() AND 
		(days_coded & POW(2, DAYOFWEEK(CURRENT_TIMESTAMP())))> 0 )INTO ttemp;
		
		IF NOT(dtemp > 0 OR ttemp > 0) THEN
			RETURN 202;
		END IF;	
		
	END IF;
RETURN 100;
END