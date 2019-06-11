CREATE PROCEDURE STR_TO_TBL_GRP(fullstr TEXT)
BEGIN
DECLARE a INT DEFAULT 0 ;
DECLARE str VARCHAR(255);

TRUNCATE TABLE temp_array_table;
      SET @delim='$$';
      simple_loop: LOOP
         SET a=a+1;
         SET str := (SELECT split_str(fullstr,@delim,a));
         IF str='' THEN
            LEAVE simple_loop;
         END IF;
         -- Do Inserts into temp table here with str going into the row
         
         INSERT INTO temp_array_table(value) VALUES (TRIM((SELECT split_str(fullstr,'$$',a))));
   END LOOP simple_loop;
     
END