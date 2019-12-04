CREATE SEQUENCE eb_audit_master_id_seq START WITH 1 INCREMENT BY 1;

CREATE TABLE eb_audit_master
(
    id int default(NEXT VALUE FOR eb_audit_master_id_seq) primary key,
    formid varchar(max),
	dataid int,
	actiontype int,
	signin_log_id int,
    eb_createdby int,
    eb_createdat datetime2(6)
);

CREATE INDEX eb_audit_master_id_idx ON eb_audit_master(id);