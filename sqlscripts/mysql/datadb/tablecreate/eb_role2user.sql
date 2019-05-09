CREATE TABLE eb_role2user
(
  id integer NOT NULL auto_increment,
  role_id integer,
  user_id integer,
  eb_del1 boolean DEFAULT false,
  createdby integer,
  createdat timestamp DEFAULT CURRENT_TIMESTAMP,
  revokedby integer,
  revokedat timestamp DEFAULT CURRENT_TIMESTAMP,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id),
  CONSTRAINT eb_role2user_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_role2user_eb_del_idx
ON eb_role2user(eb_del)
USING btree;

CREATE UNIQUE INDEX eb_role2user_id_idx
ON eb_role2user(id)
USING btree;
  
CREATE INDEX eb_role2user_role_id_idx
ON eb_role2user(role_id)
USING btree;
  
CREATE INDEX eb_role2user_user_id_idx
ON eb_role2user(user_id)
USING btree;