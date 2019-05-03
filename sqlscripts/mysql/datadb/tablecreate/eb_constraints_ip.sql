CREATE TABLE eb_constraints_ip
(
  id integer NOT NULL auto_increment,
  usergroup_id integer,
  ip varchar(25),
  description text,
  eb_del char(1) DEFAULT 'F',
  eb_created_by integer,
  eb_created_at timestamp DEFAULT  CURRENT_TIMESTAMP,
  eb_revoked_by integer,
  eb_revoked_at timestamp DEFAULT  CURRENT_TIMESTAMP,
  CONSTRAINT eb_constraints_ip_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_constraints_ip_idx
ON eb_constraints_ip(id) 
USING btree;


CREATE INDEX eb_constraints_ip_ip_idx
ON eb_constraints_ip(ip) 
USING btree;