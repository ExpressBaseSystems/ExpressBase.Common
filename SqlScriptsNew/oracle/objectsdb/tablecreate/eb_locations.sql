BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_locations_id_seq START WITH 1';


	EXECUTE IMMEDIATE 'CREATE TABLE eb_locations
	(
		id NUMBER NOT NULL,
		shortname CLOB,
		longname CLOB,
		image CLOB,
		meta_json CLOB,
		CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_locations_trigger BEFORE INSERT ON eb_locations FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_locations_id_seq.NEXTVAL;END;';
END;