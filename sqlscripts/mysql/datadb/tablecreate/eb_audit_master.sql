CREATE TABLE eb_audit_master
(
  id integer NOT NULL auto_increment,
  formid varchar(100),
  eb_createdby integer,
  eb_createdat timestamp,
  dataid integer,
  constraint eb_audit_master_pkey primary key(id)
);

create index eb_audit_master_idx on eb_audit_master(id) using btree;

create index eb_audit_master_formid_idx on eb_audit_master(formid) using btree;
