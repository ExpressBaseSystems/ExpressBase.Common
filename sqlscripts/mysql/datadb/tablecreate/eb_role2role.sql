CREATE TABLE eb_role2role
(
  id integer NOT NULL auto_increment,
  role1_id integer,
  role2_id integer,
  eb_del1 boolean DEFAULT false,
  createdby integer,
  createdat timestamp DEFAULT CURRENT_TIMESTAMP,
  revokedby integer,
  revokedat timestamp DEFAULT CURRENT_TIMESTAMP,
  eb_del char NOT NULL DEFAULT 'F',
  CONSTRAINT eb_role2role_id_pkey PRIMARY KEY (id),
  CONSTRAINT eb_role2role_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_role2role_eb_del_idx 
ON eb_role2role(eb_del)
USING btree;

CREATE UNIQUE INDEX eb_role2role_id_idx
ON eb_role2role (id)
USING btree;

CREATE INDEX eb_role2role_role1_id_idx
ON eb_role2role(role1_id)
USING btree;