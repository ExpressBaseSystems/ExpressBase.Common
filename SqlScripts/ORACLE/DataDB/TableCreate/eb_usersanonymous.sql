DECLARE
	default_val NUMBER;
BEGIN
	
	default_val  :=1;	

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_usersanonymous_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_usersanonymous
	(
		id NUMBER NOT NULL,
    		fullname VARCHAR2(100),
    		socialid VARCHAR2(50),
    		email VARCHAR2(100),
    		sex VARCHAR2(20),
    		phoneno VARCHAR2(20),
    		firstvisit DATE,
    		lastvisit DATE,
    		appid NUMBER,
    		totalvisits NUMBER DEFAULT '''|| default_val ||''',
    		ebuserid NUMBER DEFAULT '''|| default_val ||''',
    		modifiedby NUMBER,
    		modifiedat DATE,
    		remarks VARCHAR2(50),
    		ipaddress VARCHAR2(50),
    		browser VARCHAR2(50),
    		CONSTRAINT eb_usersanonymous_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_usersanonymous_trigger
	BEFORE INSERT ON eb_usersanonymous
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_usersanonymous_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_usersanonymous_email_idx ON eb_usersanonymous (email)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_usersanonymous_socialid_idx ON eb_usersanonymous (socialid)';
	
END;