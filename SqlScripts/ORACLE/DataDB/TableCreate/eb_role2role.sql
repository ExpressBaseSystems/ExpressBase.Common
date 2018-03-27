DECLARE
	eb_del := 'F';
BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_role2role_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_role2role
	(
   	 	id number,
    		role1_id number,
    		role2_id number,
    		eb_del char DEFAULT '''|| eb_del ||''',
    		createdby number,
    		createdat timestamp,
    		revokedby number,
    		revokedat timestamp,
    		CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_role2role_trigger
	BEFORE INSERT ON eb_role2role
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_role2role_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2role_eb_del_idx ON eb_role2role (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2role_role1_id_idx ON eb_role2role (role1_id)';
END;