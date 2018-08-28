CREATE OR REPLACE FUNCTION eb_currval(seq CLOB)
    RETURN NUMBER 
        IS
    PRAGMA AUTONOMOUS_TRANSACTION;
    curval NUMBER; 
BEGIN
    
     execute immediate '
       select ' || dbms_assert.sql_object_name(seq) || '.CURRVAL
         from dual'
         into curval;    
    COMMIT; 
      RETURN curval;
    EXCEPTION 
        WHEN OTHERS THEN
            RETURN 0;
END;

