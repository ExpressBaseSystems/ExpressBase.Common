DROP PROCEDURE IF EXISTS eb_str_to_tbl_util;

CREATE PROCEDURE eb_str_to_tbl_util(fullstr TEXT,dlim TEXT)
BEGIN

DECLARE a INT DEFAULT 0 ;
DECLARE str VARCHAR(255);
SET @dlim = dlim;
IF fullstr IS NULL THEN SET fullstr = ''; END IF;
TRUNCATE TABLE temp_array_table;
   
      simple_loop: LOOP
         SET a=a+1;
         SET str := (SELECT eb_split_str_util(fullstr,@dlim,a));
         IF str='' THEN
            LEAVE simple_loop;
         END IF;
         -- Do Inserts into temp table here with str going into the row
         
         INSERT INTO temp_array_table(value) values (TRIM((SELECT eb_split_str_util(fullstr,@dlim,a))));
   END LOOP simple_loop;
     
END