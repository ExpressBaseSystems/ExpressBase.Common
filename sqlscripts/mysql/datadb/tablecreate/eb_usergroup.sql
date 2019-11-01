CREATE TABLE eb_usergroup
(
  id integer NOT NULL auto_increment,
  name varchar(50),
  description text, 
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_usergroup_pkey PRIMARY KEY (id),
  CONSTRAINT eb_usergroup_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_usergroup_idx
ON eb_usergroup(id) 
USING btree;

CREATE INDEX eb_usergroup_name_idx
ON eb_usergroup(name) 
USING btree;

