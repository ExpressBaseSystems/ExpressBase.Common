BEGIN
	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_roles_id_seq START WITH 100';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_roles
	(
    		id integer NOT NULL,
    		role_name varchar(20),
    		eb_del char,
    		applicationname varchar(50),
    		applicationid integer,
    		description varchar(200),
    		CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
    		CONSTRAINT eb_rolename_unique UNIQUE (role_name)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_roles_trigger
	BEFORE INSERT ON eb_roles
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_roles_id_seq.NEXTVAL;
	END';
	
	EXECUTE IMMEDIATE 'CREATE INDEX eb_roles_eb_del_idx ON eb_roles (eb_del)';
END;