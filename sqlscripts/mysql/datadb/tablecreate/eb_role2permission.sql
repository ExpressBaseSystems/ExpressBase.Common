CREATE TABLE eb_role2permission
(
  id integer auto_increment,
  role_id integer,  
  permissionname text,
  createdby integer,
  createdat datetime,
  obj_id integer,
  op_id integer,
  revokedby integer,
  revokedat datetime,
  eb_del char(1) DEFAULT 'F',
  CONSTRAINT eb_role2permission_pkey PRIMARY KEY (id),
  CONSTRAINT eb_role2permission_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);

CREATE INDEX eb_role2permission_id_idx
ON eb_role2permission(id);


CREATE INDEX eb_role2permission_eb_del_idx
ON eb_role2permission(eb_del);


CREATE INDEX eb_role2permission_role_id_idx
ON eb_role2permission(role_id);
