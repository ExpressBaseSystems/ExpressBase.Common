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

CREATE INDEX eb_audit_lines_id_idx 
	ON eb_audit_lines(id);

