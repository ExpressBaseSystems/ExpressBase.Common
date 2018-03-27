BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_objects_status_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_objects_status
	(
		id NUMBER NOT NULL,
		refid VARCHAR(20),
		status NUMBER,
		userid NUMBER,
		ts TIMESTAMP,
		eb_obj_ver_id NUMBER,
		changelog VARCHAR(20),
		CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_objects_status_trigger
	BEFORE INSERT ON eb_objects_status
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_objects_status_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_object_status_objver_id_idx ON eb_objects_status (eb_obj_ver_id)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_objects_status_refid_id_idx ON eb_objects_status (refid)';
END;

