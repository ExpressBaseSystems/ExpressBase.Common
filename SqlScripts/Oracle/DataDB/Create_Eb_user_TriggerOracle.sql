CREATE OR REPLACE TRIGGER eb_role2role_trigger
BEFORE INSERT 
ON eb_role2role
FOR EACH ROW
BEGIN
:NEW.id:=eb_role2role_id_seq.NEXTVAL;
END;


CREATE OR REPLACE TRIGGER eb_role2permission_trigger
BEFORE INSERT 
ON eb_role2permission
FOR EACH ROW
BEGIN
:NEW.id:=eb_role2permission_id_seq.NEXTVAL;
END;


CREATE OR REPLACE TRIGGER eb_role2user_trigger
BEFORE INSERT 
ON eb_role2user
FOR EACH ROW
BEGIN
:NEW.id:=eb_role2user_id_seq.NEXTVAL;
END;


CREATE OR REPLACE TRIGGER eb_roles_trigger
BEFORE INSERT 
ON eb_roles
FOR EACH ROW
BEGIN
:NEW.id:=eb_roles_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_user2usergroup_trigger
BEFORE INSERT 
ON eb_user2usergroup
FOR EACH ROW
BEGIN
:NEW.id:=eb_user2usergroup_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_usergroup_trigger
BEFORE INSERT 
ON eb_usergroup
FOR EACH ROW
BEGIN
:NEW.id:=eb_usergroup_id_seq.NEXTVAL;
END;

CREATE OR REPLACE TRIGGER eb_users_trigger
BEFORE INSERT 
ON eb_users
FOR EACH ROW
BEGIN
:NEW.id:=eb_users_id_seq.NEXTVAL;
END;