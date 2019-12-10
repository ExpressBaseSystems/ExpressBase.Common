CREATE TABLE eb_role2user
(
  id integer auto_increment,
  role_id integer,
  user_id integer,
  createdby integer,
  createdat datetime,
  revokedby integer,
  revokedat datetime,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id),
  CONSTRAINT eb_role2user_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_role2user_eb_del_idx
ON eb_role2user(eb_del);

CREATE INDEX eb_role2user_id_idx
ON eb_role2user(id);
  
CREATE INDEX eb_role2user_role_id_idx
ON eb_role2user(role_id);
  
CREATE INDEX eb_role2user_user_id_idx
ON eb_role2user(user_id);