CREATE FUNCTION eb_getconstraintstatus(in_userid integer,in_ip text) RETURNS int(11)
BEGIN
DECLARE ipfound BOOL;
DECLARE countdtc INTEGER;
DECLARE dtemp INTEGER;
DECLARE ttemp INTEGER;
declare arrip1 text;
declare c integer;

-- IP CONSTRAINT
DROP TEMPORARY TABLE IF EXISTS arrip;
	CREATE TEMPORARY TABLE IF NOT EXISTS arrip(id int auto_increment primary key, value integer);
    
	IF in_ip IS NOT NULL THEN
    
 insert into arrip(value)
		SELECT ip  FROM eb_constraints_ip 
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' ;
           
       
       select count(id)into c from arrip ;
		IF c <> 0 THEN 
    		SELECT in_ip = ANY (select `value` from arrip) INTO ipfound;
			IF NOT ipfound THEN
				return 201; -- into out_r; 
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
			return 202;
		END IF;	
		
	END IF;
    
return 100 ;
END