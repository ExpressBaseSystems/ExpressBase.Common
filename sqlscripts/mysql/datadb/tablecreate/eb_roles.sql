CREATE TABLE eb_roles
(
  id integer auto_increment,
  role_name varchar(320) NOT NULL,
  applicationname text,
  applicationid integer,
  description text,
  eb_del char(1) DEFAULT 'F',
  is_anonymous char(1) DEFAULT 'F',
  CONSTRAINT eb_roles_id_pkey PRIMARY KEY (id),
  CONSTRAINT eb_rolename_unique UNIQUE (role_name),
  CONSTRAINT eb_roles_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


ALTER TABLE eb_roles auto_increment = 101;

CREATE INDEX eb_roles_id_idx
ON eb_roles(id);


CREATE INDEX eb_roles_eb_del_idx
ON eb_roles(eb_del);


