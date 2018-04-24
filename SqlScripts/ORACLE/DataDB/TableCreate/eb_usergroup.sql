BEGIN
	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_usergroup_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_usergroup
	(
    		id number NOT NULL,
    		name varchar(30),
    		description varchar(200),
    		eb_del char,
    		CONSTRAINT eb_usergroup_pkey PRIMARY KEY (id)
	)';


	EXECUTE IMMEDIATE 'CREATE INDEX eb_usergroup_eb_del_idx ON eb_usergroup (eb_del)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_usergroup_trigger BEFORE INSERT ON eb_usergroup FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_usergroup_id_seq.NEXTVAL; END;';
END;