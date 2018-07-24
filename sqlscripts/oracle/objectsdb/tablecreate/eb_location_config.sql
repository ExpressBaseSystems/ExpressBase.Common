DECLARE
	isrequired varchar(10);  
BEGIN

	isrequired := 'F'; 

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_location_config_id_seq START WITH 1';
	EXECUTE IMMEDIATE 'CREATE TABLE eb_location_config
	(
            id NUMBER,
            keys CLOB,
    		isrequired char DEFAULT '''|| isrequired ||''',
			keytype VARCHAR2(20),
			eb_del CHAR,
    		CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
	)';
	
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_location_config_trigger BEFORE INSERT ON eb_location_config FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_location_config_id_seq.NEXTVAL; END;';
END;