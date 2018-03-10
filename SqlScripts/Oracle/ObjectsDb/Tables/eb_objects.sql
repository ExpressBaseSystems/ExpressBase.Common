BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_objects_id_seq START WITH 1';


	EXECUTE IMMEDIATE 'CREATE TABLE eb_objects
	(
		id NUMBER NOT NULL,
		obj_name VARCHAR(100),
		obj_type NUMBER,
		obj_cur_status NUMBER,
		obj_desc varchar(200),
		applicationid NUMBER,
		obj_tags varchar(30),
		owner_uid NUMBER,
		owner_ts timestamp,
		CONSTRAINT test PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_objects_trigger
	BEFORE INSERT ON eb_objects
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_objects_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_objects_type_idx ON eb_objects (obj_type)';
END;