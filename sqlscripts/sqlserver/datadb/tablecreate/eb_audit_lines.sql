CREATE SEQUENCE eb_audit_lines_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_audit_lines
(
    id int default (NEXT VALUE FOR eb_audit_lines_id_seq) primary key,
    masterid int,
    fieldname varchar(max),
    oldvalue varchar(max),
    newvalue varchar(max),
	tablename varchar(max),
    idrelation varchar(max)   
);

CREATE INDEX eb_audit_lines_id_idx ON eb_audit_lines(id);

