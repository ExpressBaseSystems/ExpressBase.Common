DECLARE
	eb_del varchar(10);  
	d_format varchar(20);
	timezone varchar(20);
	numformat varchar(20);

BEGIN
	eb_del := 'F'; 
  	d_format := 'DD/MM/YYYY';
  	timezone := 'UTC+05:30';
  	numformat := '0,000.00';

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_users_id_seq START WITH 1';
	
	EXECUTE IMMEDIATE 'CREATE TABLE eb_users
	(
    		id number NOT NULL,
    		email varchar(50),
    		pwd varchar(20),
    		eb_del char DEFAULT '''|| eb_del ||''',
    		firstname varchar(20),
    		lastname varchar(20),
    		middlename varchar(20),
    		dob date,
    		phnoprimary varchar(20),
    		phnosecondary varchar(20),
    		landline varchar(20),
    		extension varchar(20),
    		locale varchar(30),
    		alternateemail varchar(50),
    		dateformat varchar(20) DEFAULT '''|| d_format ||''',
    		timezone varchar(20) DEFAULT '''|| timezone ||''',
    		numformat varchar(20) DEFAULT ''' || numformat ||''',
    		timezoneabbre varchar(20),
   		timezonefull varchar(20),
    		profileimg varchar(20),
    		slackjson varchar(50),
    		u_token varchar(25),
    		socialid varchar(30),
    		prolink varchar(50),
    		loginattempts number DEFAULT 1,
    		company varchar(50),
    		employees varchar(30),
    		designation varchar(30),
    		country varchar(30),
    		CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    		CONSTRAINT socialid_unique_key UNIQUE (socialid)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_users_trigger
	BEFORE INSERT ON eb_users
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_users_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_eb_del_idx ON eb_users (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_email_idx ON eb_users (email)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_pwd_idx ON eb_users(pwd)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_statusid_idx ON eb_users (statusid)';
END;