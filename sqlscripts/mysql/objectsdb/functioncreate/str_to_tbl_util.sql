CREATE PROCEDURE STR_TO_TBL(fullstr text)
BEGIN
DECLARE a INT Default 0 ;
      DECLARE str VARCHAR(255);
        
	  TRUNCATE TABLE temp_array_table;
      
      simple_loop: LOOP
         SET a=a+1;
         SET str := (SELECT split_str(fullstr,',',a));
         IF str='' THEN
            LEAVE simple_loop;
         END IF;
         -- Do Inserts into temp table here with str going into the row
         
         INSERT INTO temp_array_table(value) values (TRIM((SELECT split_str(fullstr,',',a))));
   END LOOP simple_loop;
      
END