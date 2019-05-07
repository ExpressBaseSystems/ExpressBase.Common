CREATE PROCEDURE string_to_rows(fullstr text)
BEGIN
DECLARE a INT Default 0 ;
      DECLARE str VARCHAR(255);
      DROP TEMPORARY TABLE IF EXISTS temp_array_table1;
        CREATE TEMPORARY TABLE IF NOT EXISTS temp_array_table1(value text);
	
      simple_loop: LOOP
         SET a=a+1;
         SET str := (SELECT split_str(fullstr,',',a));
         IF str='' THEN
            LEAVE simple_loop;
         END IF;
         -- Do Inserts into temp table here with str going into the row
         
         INSERT INTO temp_array_table1(value) values (TRIM((SELECT split_str(fullstr,',',a))));
   END LOOP simple_loop;
     select distinct value from  temp_array_table1;
END