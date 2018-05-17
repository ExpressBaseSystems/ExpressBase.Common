BEGIN

	EXECUTE IMMEDIATE 'CREATE SEQUENCE eb_objects_relations_id_seq START WITH 1';

	EXECUTE IMMEDIATE 'CREATE TABLE eb_objects_relations
	(
		dominant VARCHAR(500),
		dependant VARCHAR(500),
		id NUMBER NOT NULL,
		eb_del CHAR,
		removed_by NUMBER,
		removed_at TIMESTAMP,
		CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id)
	)';


	EXECUTE IMMEDIATE 'CREATE INDEX eb_object_relation_eb_del_idx ON eb_objects_relations (eb_del)';
	EXECUTE IMMEDIATE 'CREATE OR REPLACE TRIGGER eb_objects_relations_trigger BEFORE INSERT ON eb_objects_relations FOR EACH ROW BEGIN ' || ':' || 'new.id:=eb_objects_relations_id_seq.NEXTVAL; END;';
END;