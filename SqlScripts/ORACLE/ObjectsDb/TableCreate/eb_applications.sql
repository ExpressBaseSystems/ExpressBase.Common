DECLARE
	eb_del varchar(10);
BEGIN

	eb_del := 'F'; 

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_applications_id_seq START WITH 1';
	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_applications
	(
    		id NUMBER NOT NULL,
    		applicationname VARCHAR(30),
    		application_type NUMBER,
    		description VARCHAR(200),
    		eb_del char DEFAULT '''|| eb_del ||''',
    		app_icon VARCHAR(20),
    		CONSTRAINT eb_applications_pkey PRIMARY KEY (id)
	)';


	EXECUTE IMMEDIATE 'CREATE INDEX eb_applications_eb_del_idx ON eb_applications (eb_del)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_applications_trigger BEFORE INSERT ON eb_applications FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_applications_id_seq.NEXTVAL; END;';
END;