CREATE DEFINER=`josevin`@`%` PROCEDURE `eb_revokedbaccess2user`(username text,
    dbname text)
BEGIN
DECLARE dbs text;
declare done boolean;
declare s varchar(200);
declare s1 varchar(200);
declare cur1 cursor for select SCHEMA_NAME from INFORMATION_SCHEMA.SCHEMATA;
DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = TRUE;   
open cur1;
read_loop: loop
      FETCH cur1 INTO dbs;
     
      IF done THEN
      LEAVE read_loop;
    END IF;
    Select @S = 'REVOKE ALTER, ALTER ROUTINE, CREATE, CREATE ROUTINE, CREATE TABLESPACE, CREATE TEMPORARY TABLES,
      CREATE USER, CREATE VIEW, DELETE, DROP, EVENT, EXECUTE, FILE, INDEX, INSERT, LOCK TABLES, PROCESS,
      REFERENCES, RELOAD, REPLICATION CLIENT, REPLICATION SLAVE, SELECT, SHOW DATABASES, SHOW VIEW,
      SHUTDOWN, SUPER, TRIGGER, UPDATE ON ' + dbs +'FROM' + username;
    
     execute s;

  	END loop;
    close cur1;
  
     select s1=' GRANT ALL ON'+dbname+'TO'+username+'WITH GRANT OPTION';
     execute s1;

     FLUSH PRIVILEGES;
   
END