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
            IF SQLCODE = -8002 THEN
                RETURN 0;
            ELSE
              raise_application_error(-20001,'An error was encountered - '||SQLCODE||' -ERROR- '||SQLERRM);
            END IF;
END;