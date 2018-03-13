DECLARE
	eb_del varchar(10); 
BEGIN

	eb_del := 'F';

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_role2permission_id_seq START WITH 1';
	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_role2permission
	(
    		id integer NOT NULL,
    		role_id integer,
    		eb_del char DEFAULT '''|| eb_del ||''',
    		permissionname varchar(20),
    		createdby integer,
    		createdat timestamp,
    		obj_id integer,
    		op_id integer,
    		revokedby integer,
    		revokedat timestamp,
    		CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_role2permission_trigger
	BEFORE INSERT ON eb_role2permission
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_role2permission_id_seq.NEXTVAL;
	END';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2permission_eb_del_idx ON eb_role2permission (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2permission_role_id_idx ON eb_role2permission (role_id)';
END;