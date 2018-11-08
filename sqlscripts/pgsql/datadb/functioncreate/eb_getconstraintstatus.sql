-- FUNCTION: public.eb_getconstraintstatus(integer, text)

-- DROP FUNCTION public.eb_getconstraintstatus(integer, text);

CREATE OR REPLACE FUNCTION public.eb_getconstraintstatus(
	in_userid integer,
	in_ip text)
    RETURNS integer
    LANGUAGE 'plpgsql'

    COST 100
    VOLATILE 
AS $BODY$

DECLARE 
arrip TEXT[];
ipfound BOOL;
countdtc INTEGER;
dtemp INTEGER;
ttemp INTEGER;
BEGIN
	--IP CONSTRAINT
	IF in_ip IS NOT NULL THEN
		SELECT ARRAY(SELECT ip FROM eb_constraints_ip 
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F')INTO arrip;
		IF ARRAY_LENGTH(arrip, 1) <> 0 THEN 
    		SELECT in_ip = ANY (arrip) INTO ipfound;
			IF NOT ipfound THEN
				RETURN 201; 
			END IF;
		END IF;
	END IF;
	
	--DATETIME CONSTRAINT
	countdtc := 0;
	SELECT COUNT(*) FROM eb_constraints_datetime
	WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
		WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' INTO countdtc;
	
	IF countdtc > 0 THEN
		SELECT COUNT(*) FROM eb_constraints_datetime
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' AND type = 1 AND 
		start_datetime < NOW() AND end_datetime > NOW() INTO dtemp;
		
		SELECT COUNT(*) FROM eb_constraints_datetime
		WHERE usergroup_id IN(SELECT groupid FROM eb_user2usergroup 
			WHERE userid = in_userid AND eb_del = 'F') AND eb_del = 'F' AND type = 2 AND 
		start_datetime::TIME < NOW()::TIME AND
		end_datetime::TIME > NOW()::TIME AND 
		days_coded & POW(2, EXTRACT(DOW FROM NOW()))::INTEGER > 0 INTO ttemp;
		
		IF NOT(dtemp > 0 OR ttemp > 0) THEN
			RETURN 202;
		END IF;	
	END IF;
	
	RETURN 100;
END;

$BODY$;

ALTER FUNCTION public.eb_getconstraintstatus(integer, text)
    OWNER TO postgres;