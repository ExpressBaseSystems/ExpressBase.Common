CREATE TABLE eb_role2role
(
  id integer auto_increment,
  role1_id integer,
  role2_id integer,  
  createdby integer,
  createdat datetime,
  revokedby integer,
  revokedat datetime,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id),
  CONSTRAINT eb_role2role_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_role2role_eb_del_idx 
ON eb_role2role(eb_del);

CREATE INDEX eb_role2role_id_idx
ON eb_role2role (id);

CREATE INDEX eb_role2role_role1_id_idx
ON eb_role2role(role1_id);