CREATE OR REPLACE TRIGGER eb_objects_trigger
BEFORE INSERT 
ON eb_objects
FOR EACH ROW
BEGIN
:NEW.id:=eb_objects_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_objects_relations_trigger
BEFORE INSERT 
ON eb_objects_relations
FOR EACH ROW
BEGIN
:NEW.id:=eb_objects_relations_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_applications_trigger
BEFORE INSERT 
ON eb_applications
FOR EACH ROW
BEGIN
:NEW.id:=eb_applications_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_objects2application_trigger
BEFORE INSERT 
ON eb_objects2application
FOR EACH ROW
BEGIN
:NEW.id:=eb_objects2application_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_objects_status_trigger
BEFORE INSERT 
ON eb_objects_status
FOR EACH ROW
BEGIN
:NEW.id:=eb_objects_status_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_objects_ver_trigger
BEFORE INSERT 
ON eb_objects_ver
FOR EACH ROW
BEGIN
:NEW.id:=eb_objects_ver_id_seq.NEXTVAL;
END;