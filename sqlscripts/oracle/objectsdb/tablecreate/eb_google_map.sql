
BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_google_map_seq START WITH 1';
	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_google_map
	(
    		id NUMBER NOT NULL,
    		lattitude CLOB,
    		longitude CLOB,
    		name CLOB,
    		CONSTRAINT eb_google_map_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_google_map_trigger BEFORE INSERT ON eb_google_map FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_google_map_seq.NEXTVAL; END;';
END;