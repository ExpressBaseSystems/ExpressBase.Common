DROP PROCEDURE IF EXISTS eb_security_constraints;

CREATE PROCEDURE eb_security_constraints(IN _userid integer,
	IN _keyid integer,
	IN _add_data text,
	IN _delete_ids text,
    OUT out_add_no integer,
    OUT out_del_no integer)
BEGIN 
  
DECLARE add_no INTEGER;
DECLARE del_no INTEGER;
DECLARE add_con TEXT;
DECLARE temp1 INTEGER;
DECLARE tmp2 TEXT;
DECLARE cline TEXT;
DECLARE cmaster TEXT;
DECLARE i INTEGER;
DECLARE j INTEGER;
DECLARE cmaster_count INTEGER;
DECLARE cline_count INTEGER;

DECLARE cmaster_cur CURSOR FOR SELECT `value` FROM temp_cmaster;
DECLARE cline_cur CURSOR FOR SELECT `value` FROM temp_cline;

DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_del_all;
		CREATE TEMPORARY TABLE temp_array_table(value INTEGER);
		CALL STR_TO_TBL(_delete_ids);  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_del_all SELECT `value` FROM temp_array_table;
 SET add_no = 0;
SET del_no = 0;
set i=0;
SET SQL_SAFE_UPDATES = 0;
UPDATE 
		eb_constraints_master 
    SET 
		eb_del = 'T', eb_lastmodified_by = _userid, eb_lastmodified_at = UTC_TIMESTAMP()
	WHERE eb_del = 'F' AND id IN(
		SELECT 
				`value` 
			FROM 
				temp_del_all);
GET DIAGNOSTICS del_no = ROW_COUNT;
if(_add_data <> null OR _add_data <> "") then
       
	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_cmaster;
		CREATE TEMPORARY TABLE temp_array_table(value text);
		CALL STR_TO_TBL_CONSTRAINTS(_add_data,'$$');  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_cmaster SELECT `value` FROM temp_array_table;
	SELECT COUNT(*) FROM temp_cmaster INTO cmaster_count;

	OPEN cmaster_cur;
	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_add_c;
		CREATE TEMPORARY TABLE temp_array_table(value text);
		CREATE TEMPORARY TABLE temp_add_c(value text);
	cmaster_loop:
		LOOP
			set i = i + 1;
			FETCH cmaster_cur INTO add_con;
				CALL STR_TO_TBL_CONSTRAINTS(add_con,'$'); 
				INSERT INTO temp_add_c(value) SELECT `value` from temp_array_table;
			IF i = cmaster_count THEN 
				LEAVE cmaster_loop;
			END IF;
	END LOOP; 
	CLOSE cmaster_cur;

	DROP TEMPORARY TABLE IF EXISTS temp_add_con;
		CREATE TEMPORARY TABLE temp_add_con(id integer auto_increment primary key, value text)
		SELECT `value` FROM temp_add_c;
		SELECT CAST(`value` as unsigned integer) FROM temp_add_con WHERE id = 1  INTO @k_t;
		SELECT CAST(`value` as unsigned integer) FROM temp_add_con WHERE id = 2 INTO @des;
	INSERT INTO eb_constraints_master(key_id, key_type, description, eb_created_by, eb_created_at)
		VALUES(
			CAST(_keyid as unsigned integer), @k_t, @des, 
            _userid, utc_timestamp());
	SELECT LAST_INSERT_ID() INTO temp1;
	SET	add_no = add_no + 1; 
	SELECT `value` FROM temp_add_con WHERE id =3 INTO @add_con3;	
	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_cline;
		CREATE TEMPORARY TABLE temp_array_table(value text);        
		CALL STR_TO_TBL_CONSTRAINTS(@add_con3,';;');  
		CREATE TEMPORARY TABLE IF NOT EXISTS temp_cline SELECT `value` FROM temp_array_table;
	select count(*) from temp_cline into cline_count;
	SET j = 0;
	OPEN cline_cur;
	DROP TEMPORARY TABLE IF EXISTS temp_array_table;
		DROP TEMPORARY TABLE IF EXISTS temp_tmp2;
		CREATE TEMPORARY TABLE temp_array_table(value text);
		CREATE TEMPORARY TABLE temp_tmp2(value text);
	cline_loop:
		LOOP
			set j = j + 1;
			FETCH cline_cur INTO tmp2;
				CALL STR_TO_TBL_CONSTRAINTS(tmp2,';'); 
				INSERT INTO temp_tmp2(value) SELECT `value` from temp_array_table;
			IF j = cline_count THEN 
				LEAVE cline_loop;
			END IF;
		END LOOP; 
	CLOSE cline_cur;

	DROP TEMPORARY TABLE IF EXISTS temp_temp2;
	CREATE TEMPORARY TABLE temp_temp2(id integer auto_increment primary key, value text)
	SELECT `value` FROM temp_tmp2;
	SELECT CAST(`value` AS UNSIGNED INTEGER) FROM temp_temp2 WHERE id = 1 INTO @c_op;
	SELECT CAST(`value` AS UNSIGNED INTEGER) FROM temp_temp2 WHERE id = 2 INTO @c_t;
	SELECT CAST(`value` AS UNSIGNED INTEGER) FROM temp_temp2 WHERE id = 3 INTO @c_v;
	INSERT INTO eb_constraints_line(master_id, c_operation, c_type, c_value)
	VALUES(temp1, @c_op, @c_t, @c_v);
end if;     
SELECT add_no, del_no into out_add_no, out_del_no;
END