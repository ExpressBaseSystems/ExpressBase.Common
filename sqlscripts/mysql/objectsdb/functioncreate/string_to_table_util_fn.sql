-- HELPER FUNCTION FOR STR_TO_TBL to get Nth charecter
-- DROP FUNCTION  IF EXISTS SPLIT_STR;

DELIMITER $$

CREATE FUNCTION SPLIT_STR(
	  x VARCHAR(255),
	  delim VARCHAR(12),
	  pos INT	)
RETURNS VARCHAR(255)
DETERMINISTIC
BEGIN
	RETURN REPLACE(SUBSTRING(SUBSTRING_INDEX(x, delim, pos),
		   LENGTH(SUBSTRING_INDEX(x, delim, pos -1)) + 1),
		   delim, '');
END$$

-- CONVERTS ',' SEPERATED STRING TO TEMPORARY TABLE(temp_array_table)
-- DROP PROCEDURE IF EXISTS  STR_TO_TBL;     

DROP PROCEDURE IF EXISTS STR_TO_TBL;
DELIMITER $$       
CREATE PROCEDURE STR_TO_TBL(fullstr TEXT)
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
         INSERT INTO temp_array_table values (TRIM((SELECT split_str(fullstr,',',a))));
   END LOOP simple_loop;
   -- SELECT value FROM temp_array_table;
END $$