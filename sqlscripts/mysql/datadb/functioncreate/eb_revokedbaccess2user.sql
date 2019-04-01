CREATE PROCEDURE eb_revokedbaccess2user(in username text,
    in dbname text,
    out out_b boolean)
BEGIN
DECLARE dbs text;
declare done boolean;
declare s text;
declare s1 varchar(200);
declare cur1 cursor for select SCHEMA_NAME from INFORMATION_SCHEMA.SCHEMATA;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;   
open cur1;
read_loop: loop
      FETCH cur1 INTO dbs;
     
      IF done THEN
      LEAVE read_loop;
    END IF;
     REVOKE ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TABLESPACE, CREATE TEMPORARY TABLES,
      CREATE USER, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, PROCESS,
      REFERENCES, RELOAD, REPLICATION CLIENT, REPLICATION SLAVE, SELECT, SHOW DATABASES, SHOW VIEW,
      SHUTDOWN, SUPER, TRIGGER, UPDATE ON   dbs FROM  username;
    
   --  execute s;

  	END loop;
    close cur1;
  
     GRANT ALL privileges on dbname TO username WITH GRANT OPTION;
     -- execute s1;

     FLUSH PRIVILEGES;
   select true into out_b;
END