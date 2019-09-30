-- FUNCTION: public.eb_security_constraints(integer, integer, text, text)

-- DROP FUNCTION public.eb_security_constraints(integer, integer, text, text);

CREATE OR REPLACE FUNCTION public.eb_security_constraints(
	_userid integer,
	_keyid integer,
	_add_data text,
	_delete_ids text)
    RETURNS TABLE(add_no integer, del_no integer) 
    LANGUAGE 'plpgsql'
   
AS $BODY$

DECLARE 
add_no INTEGER;
del_no INTEGER;
add_con TEXT[];
del_all INTEGER[];
temp1 INTEGER;
temp2 TEXT[];
cline TEXT;
cmaster TEXT;

BEGIN
add_no := 0;
del_no := 0;
del_all := STRING_TO_ARRAY(_delete_ids, ',');

UPDATE eb_constraints_master SET eb_del = 'T', eb_lastmodified_by = _userid, eb_lastmodified_at = CURRENT_TIMESTAMP AT TIME ZONE 'UTC' 
	WHERE eb_del = 'F' AND id IN(SELECT UNNEST(del_all));
GET DIAGNOSTICS del_no = ROW_COUNT;

FOREACH cmaster IN ARRAY STRING_TO_ARRAY(_add_data, '$$') LOOP
	add_con := STRING_TO_ARRAY(cmaster, '$');
	
	INSERT INTO eb_constraints_master(key_id, key_type, description, eb_created_by, eb_created_at)
		VALUES(_keyid::INTEGER, add_con[1]::INTEGER, add_con[2], _userid, CURRENT_TIMESTAMP AT TIME ZONE 'UTC') RETURNING id INTO temp1;
	add_no := add_no + 1;
	
	FOREACH cline IN ARRAY STRING_TO_ARRAY(add_con[3], ';;') LOOP
		temp2 := STRING_TO_ARRAY(cline, ';');
		
		INSERT INTO eb_constraints_line(master_id, c_operation, c_type, c_value)
			VALUES(temp1, temp2[1]::INTEGER, temp2[2]::INTEGER, temp2[3]::INTEGER);
	
	END LOOP;
END LOOP;
  
RETURN QUERY SELECT add_no, del_no;
END;

$BODY$;

