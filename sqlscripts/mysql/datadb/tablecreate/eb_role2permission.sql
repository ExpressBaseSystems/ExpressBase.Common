-- DROP TABLE eb_role2permission;

CREATE TABLE eb_role2permission
(
  id integer NOT NULL auto_increment,
  role_id integer,
  eb_del1 boolean DEFAULT false,
  permissionname text,
  createdby integer,
  createdat timestamp DEFAULT CURRENT_TIMESTAMP,
  obj_id integer,
  op_id integer,
  revokedby integer,
  revokedat timestamp DEFAULT CURRENT_TIMESTAMP,
  permissionname_backup text,
  eb_del char NOT NULL DEFAULT 'F',
  CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id),
  CONSTRAINT eb_role2permission_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_role2permission_idx
ON eb_role2permission(id) 
USING btree;


CREATE INDEX eb_role2permission_eb_del_idx
ON eb_role2permission(eb_del) 
USING btree;


CREATE INDEX eb_role2permission_role_id_idx
ON eb_role2permission(role_id)
USING btree;
