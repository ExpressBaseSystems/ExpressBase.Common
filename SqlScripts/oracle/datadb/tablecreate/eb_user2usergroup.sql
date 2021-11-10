DECLARE
	eb_del varchar(10);
BEGIN
	eb_del := 'F';

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_user2usergroup_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_user2usergroup
	(
   		id number NOT NULL,
    		userid number,
    		groupid number,
    		eb_del char DEFAULT '''|| eb_del ||''',
    		createdby number,
    		createdat timestamp,
    		revokedby number,
    		revokedat timestamp,
    		CONSTRAINT eb_user2usergroup_pkey PRIMARY KEY (id)
	)';


	EXECUTE IMMEDIATE 'CREATE INDEX eb_user2usergroup_eb_del_idx ON eb_user2usergroup (eb_del)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_user2usergroup_groupid_idx ON eb_user2usergroup  (groupid)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_user2usergroup_userid_idx ON eb_user2usergroup (userid)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_user2usergroup_trigger BEFORE INSERT ON eb_user2usergroup FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_user2usergroup_id_seq.NEXTVAL; END;';
END;