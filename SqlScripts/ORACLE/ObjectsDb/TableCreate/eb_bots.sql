DECLARE
	eb_del varchar(10); 
BEGIN
	eb_del := 'F';

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_bots_id_seq START WITH 1';

	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_bots
	(
    		id number NOT NULL,
    		name varchar2(20),
    		url varchar2(20),
    		welcome_msg varchar2(100),
    		botid varchar2(20),
			modified_by number,
			solution_id number,
			created_at timestamp,
			modified_at timestamp,
			created_by number,
			app_id number,
			fullname varchar2(20),
    		eb_del char DEFAULT '''|| eb_del ||''',  		
    		CONSTRAINT eb_bots_id_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_bots_trigger
	BEFORE INSERT ON eb_bots
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_bots_id_seq.NEXTVAL;
	END';
	
	EXECUTE IMMEDIATE 'CREATE INDEX eb_bots_eb_del_idx ON eb_bots (eb_del)';
END;