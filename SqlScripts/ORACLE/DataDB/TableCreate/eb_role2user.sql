DECLARE
	eb_del varchar(10);  
BEGIN

	eb_del := 'F'; 

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_role2user_id_seq START WITH 1';
	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_role2user
	(
    		id number NOT NULL,
   		role_id number,
    		user_id number,
    		eb_del char DEFAULT '''|| eb_del ||''',
    		createdby number,
    		createdat timestamp,
    		revokedby number,
    		revokedat timestamp,
    		CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_role2user_trigger
	BEFORE INSERT ON eb_role2user
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_role2user_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2user_eb_del_idx ON eb_role2user (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2user_role_id_idx ON eb_role2user (role_id)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2user_user_id_idx ON eb_role2user (user_id)';
END;