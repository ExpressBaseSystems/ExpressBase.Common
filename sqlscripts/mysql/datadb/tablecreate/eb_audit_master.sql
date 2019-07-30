CREATE TABLE eb_audit_master
(
    id serial,
    formid text,
    dataid integer,
    actiontype integer,
    signin_log_id integer,
    eb_createdby integer,
    eb_createdat timestamp DEFAULT current_timestamp,
    CONSTRAINT eb_audit_master_pkey PRIMARY KEY (id)
)

create index eb_audit_master_idx on eb_audit_master(id) using btree;

create index eb_audit_master_formid_idx on eb_audit_master(formid) using btree;
