DECLARE
	eb_del varchar(10); 
BEGIN
	eb_del := 'F';
	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_files_id_seq START WITH 1';

	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_files
	(
    		id number NOT NULL,
    		userid number ,
    		objid varchar2(100),
    		length number,
    		tags varchar2(100),
			bucketname varchar2(30),
			filetype varchar2(30),
			uploaddatetime timestamp,
			eb_del char DEFAULT '''|| eb_del ||''',  		
    		CONSTRAINT eb_files_id_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_files_eb_del_idx ON eb_files (eb_del)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_files_trigger BEFORE INSERT ON eb_files FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_files_id_seq.NEXTVAL; END;';
END;
    