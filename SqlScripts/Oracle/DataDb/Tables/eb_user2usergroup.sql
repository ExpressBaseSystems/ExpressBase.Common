BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_user2usergroup_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_user2usergroup
	(
   		id integer NOT NULL,
    		userid integer,
    		groupid integer,
    		eb_del char DEFAULT '''|| eb_del ||''',
    		createdby integer,
    		createdat timestamp,
    		revokedby integer,
    		revokedat timestamp,
    		CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id)
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_user2usergroup_trigger
	BEFORE INSERT ON eb_user2usergroup
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_user2usergroup_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_user2usergroup_eb_del_idx ON eb_user2usergroup (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_user2usergroup_groupid_idx ON eb_user2usergroup  (groupid)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_user2usergroup_userid_idx ON eb_user2usergroup (userid)';
END;