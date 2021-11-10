CREATE TABLE eb_audit_master
(
    id integer auto_increment,
    formid text,
    dataid integer,
    actiontype integer,
    signin_log_id integer,
    eb_createdby integer,
    eb_createdat datetime,
    CONSTRAINT eb_audit_master_pkey PRIMARY KEY (id)
);

CREATE INDEX eb_audit_master_id_idx 
	ON eb_audit_master(id);