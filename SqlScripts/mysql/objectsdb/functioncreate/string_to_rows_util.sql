CREATE PROCEDURE string_to_rows(fullstr TEXT)
BEGIN
DECLARE a INT DEFAULT 0 ;
DECLARE str VARCHAR(255);

DROP TEMPORARY TABLE IF EXISTS tmp_array_table;
CREATE TEMPORARY TABLE IF NOT EXISTS tmp_array_table(value TEXT);
    
IF fullstr IS NULL THEN SET fullstr = ''; END IF;

      simple_loop: LOOP
         SET a=a+1;
         SET str := (SELECT split_str(fullstr,',',a));
         IF str='' THEN
            LEAVE simple_loop;
         END IF;
         -- Do Inserts into temp table here with str going into the row         
         INSERT INTO tmp_array_table(value) values (TRIM((SELECT split_str(fullstr,',',a))));
   END LOOP simple_loop;
     SELECT DISTINCT value FROM  tmp_array_table;
END