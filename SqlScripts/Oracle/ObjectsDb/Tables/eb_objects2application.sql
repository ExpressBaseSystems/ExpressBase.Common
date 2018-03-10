DECLARE
	eb_del varchar(10);
BEGIN
	eb_del := 'F';

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_objects2application_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_objects2application
	(
    		app_id NUMBER,
    		id NUMBER NOT NULL,
    		obj_id NUMBER,
    		eb_del CHAR DEFAULT '''|| eb_del ||''',
    		removed_by NUMBER,
   		 removed_at TIMESTAMP,
		CONSTRAINT eb_objects2application_pkey PRIMARY KEY (id)
	)';
	
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_objects2application_trigger
	BEFORE INSERT ON eb_objects2application
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_objects2application_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_object2app_app_id_idx ON eb_objects2application (app_id)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_object2app_eb_del_idx ON eb_objects2application (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_object2app_obj_id_idx ON eb_objects2application (obj_id)';
END;