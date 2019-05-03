CREATE TABLE eb_roles
(
  id integer NOT NULL auto_increment,
  role_name varchar(25) NOT NULL,
  eb_del1 boolean,
  applicationname text,
  applicationid integer,
  description text,
  eb_del char(1) DEFAULT 'F',
  is_anonymous char,
  CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
  CONSTRAINT eb_rolename_unique UNIQUE (role_name),
  CONSTRAINT eb_roles_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_roles_idx
ON eb_roles(id) 
USING btree;

CREATE INDEX eb_roles_name_idx
ON eb_roles(role_name) 
USING btree;

CREATE INDEX eb_roles_appid_idx
ON eb_roles(applicationid) 
USING btree;

alter table eb_roles auto_increment = 101;