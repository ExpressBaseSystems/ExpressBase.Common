DECLARE
	eb_del varchar(10); 
BEGIN
	eb_del := 'F';
	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_files_bytea_id_seq START WITH 1';

	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_files_bytea
	(
    		id number NOT NULL,
    		filename varchar2(30),
            		bytea blob,
    		tags varchar2(100),
			filetype varchar2(30),
    		CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_files_bytea_trigger BEFORE INSERT ON eb_files_bytea FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_files_bytea_id_seq.NEXTVAL; END;';
END;
    