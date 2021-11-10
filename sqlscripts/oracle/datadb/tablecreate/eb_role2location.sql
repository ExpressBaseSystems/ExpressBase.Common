DECLARE
	eb_del varchar(10);  
BEGIN

	eb_del := 'F'; 

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_role2location_id_seq START WITH 1';
	EXECUTE IMMEDIATE 'CREATE TABLE eb_role2location
	(
   	 	id number,
    	roleid number,
    	locationid number,
    	eb_del char DEFAULT '''|| eb_del ||''',
    	eb_createdby number,
    	eb_createdat timestamp,
    	eb_revokedby number,
    	eb_revokedat timestamp,
    	CONSTRAINT eb_role2location_pkey PRIMARY KEY (id)
	)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2location_roleid_idx ON eb_role2location (roleid)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_role2location_locid_idx ON eb_role2location (locationid)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_role2location_trigger BEFORE INSERT ON eb_role2location FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_role2location_id_seq.NEXTVAL; END;';
END;