DECLARE
	default_val NUMBER;
BEGIN
	
	default_val  :=1;	

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_userstatus_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_userstatus
	(
   		 id NUMBER NOT NULL,
    		createdby NUMBER,
    		createdat DATE,
    		userid NUMBER,
    		statusid NUMBER,
    		CONSTRAINT eb_userstatus_pkey PRIMARY KEY (id),
	)';

	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_userstatus_trigger
	BEFORE INSERT ON eb_userstatus
	FOR EACH ROW
	BEGIN
		:NEW.id:=eb_userstatus_id_seq.NEXTVAL;
	END';

	EXECUTE IMMEDIATE 'CREATE INDEX eb_userstatus_statusid_idx ON eb_userstatus(statusid)';
	EXECUTE IMMEDIATE 'CREATE INDEX eb_userstatus_userid_idx ON eb_userstatus(userid)';
	
END;