CREATE TABLE eb_constraints_datetime
(
  id integer NOT NULL auto_increment,
  usergroup_id integer,
  type integer,
  start_datetime timestamp DEFAULT  CURRENT_TIMESTAMP,
  end_datetime timestamp DEFAULT  CURRENT_TIMESTAMP,
  days_coded integer,
  eb_del char(1) DEFAULT 'F',
  eb_created_by integer,
  eb_created_at timestamp DEFAULT  CURRENT_TIMESTAMP,
  eb_revoked_by integer,
  eb_revoked_at timestamp DEFAULT  CURRENT_TIMESTAMP,
  title text,
  description text,
  CONSTRAINT eb_constraints_datetime_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_constraints_datetime_idx
ON eb_constraints_datetime(id) 
USING btree;