DECLARE
	eb_del varchar(10);  
BEGIN

	eb_del := 'F'; 

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_roles_id_seq START WITH 100';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_roles
	(
    		id number NOT NULL,
    		role_name varchar(20),
    		eb_del char DEFAULT '''|| eb_del ||''' ,
    		applicationname varchar(50),
    		applicationid number,
    		description varchar(200),
			is_anonymous char DEFAULT '''|| eb_del ||''',
    		CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
    		CONSTRAINT eb_rolename_unique UNIQUE (role_name)
	)';

	
	EXECUTE IMMEDIATE 'CREATE INDEX eb_roles_eb_del_idx ON eb_roles (eb_del)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_roles_trigger BEFORE INSERT ON eb_roles FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_roles_id_seq.NEXTVAL; END;';
END;