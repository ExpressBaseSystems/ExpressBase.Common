DECLARE
	eb_del varchar(10);
BEGIN

	eb_del := 'F'; 

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_objects_ver_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_objects_ver
	(
    		id NUMBER NOT NULL,
    		eb_objects_id NUMBER,
    		obj_changelog VARCHAR(300),
    		commit_uid NUMBER,
   		commit_ts TIMESTAMP,
    		obj_json VARCHAR(900),
    		refid VARCHAR(200),
    		version_num VARCHAR(15),
    		major_ver_num NUMBER,
    		minor_ver_num NUMBER,
    		patch_ver_num NUMBER,
    		working_mode CHAR DEFAULT '''|| eb_del ||''',
    		status_id NUMBER,
    		CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id)
	)';


	EXECUTE IMMEDIATE 'CREATE INDEX eb_object_ver_eb_object_id_idx ON eb_objects_ver (eb_objects_id)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_objects_ver_status_id_idx ON eb_objects_ver (status_id)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_objects_ver_trigger BEFORE INSERT ON eb_objects_ver FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_objects_ver_id_seq.NEXTVAL; END;';
END;