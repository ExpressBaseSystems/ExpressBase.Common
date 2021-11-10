-- Table: public.eb_audit_master

-- DROP TABLE public.eb_audit_master;

CREATE TABLE eb_audit_master
(
    id serial,
    formid text,
    dataid integer,
    actiontype integer,
    signin_log_id integer,
    eb_createdby integer,
    eb_createdat timestamp without time zone,    
    CONSTRAINT eb_audit_master_pkey PRIMARY KEY (id)
);


-- Index: eb_audit_master_id_idx

-- DROP INDEX public.eb_audit_master_id_idx;

CREATE INDEX eb_audit_master_id_idx
    ON eb_audit_master(id);