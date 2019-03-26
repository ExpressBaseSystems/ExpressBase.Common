CREATE TABLE eb_audit_lines
(
  id integer NOT NULL auto_increment,
  masterid integer,
  fieldname text,
  oldvalue text,
  newvalue text,
  tablename text,
  idrelation text,
  constraint eb_audit_lines_pkey primary key(id)
);

create index eb_audit_lines_idx on eb_audit_lines(id) using btree;

create index eb_audit_lines_masterid_idx on eb_audit_lines(masterid) using btree;
