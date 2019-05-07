-- Table: public.eb_audit_master

-- DROP TABLE public.eb_audit_master;

CREATE TABLE public.eb_audit_master
(
    id serial,
    formid text COLLATE pg_catalog."default",
    eb_createdby integer,
    eb_createdat timestamp without time zone,
	dataid integer,
	CONSTRAINT eb_audit_masters_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_audit_master
    OWNER to postgres;
	

-- Index: eb_audit_master_id_idx

-- DROP INDEX public.eb_audit_master_id_idx;

CREATE INDEX eb_audit_master_id_idx
    ON public.eb_audit_master USING btree
    (id)
    TABLESPACE pg_default;