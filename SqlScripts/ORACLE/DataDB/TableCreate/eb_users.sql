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
    		pwd varchar2(400),
    		eb_del char DEFAULT '''|| eb_del ||''',
    		firstname varchar(20),
    		lastname varchar(20),
    		middlename varchar(20),
    		dob date,
    		phnoprimary varchar(20),
    		phnosecondary varchar(20),
    		landline varchar(20),
    		phextension varchar(20),
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
			socialname varchar(30),
			nickname varchar(30),
			sex varchar(30),
			fullname varchar(30),
    		prolink varchar(50),
    		loginattempts number DEFAULT 1,    		
            statusid number DEFAULT 0,
			fbid varchar(30),
			fbname varchar(30),
			preferencesjson clob,
			createdby varchar(30),
			createdat varchar(30),
			hide varchar(30),
    		CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    		CONSTRAINT socialid_unique_key UNIQUE (socialid)
	)';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_eb_del_idx ON eb_users (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_email_idx ON eb_users (email)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_pwd_idx ON eb_users(pwd)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_users_statusid_idx ON eb_users (statusid)';
    EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_users_trigger BEFORE INSERT ON eb_users FOR EACH ROW BEGIN ' || ':' || 'new.id := eb_users_id_seq.NEXTVAL; END;';
END;
