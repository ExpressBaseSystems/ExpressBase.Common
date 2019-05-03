-- Table: public.eb_audit_lines

-- DROP TABLE public.eb_audit_lines;

CREATE TABLE public.eb_audit_lines
(
    id serial primary key,
    masterid integer,
    fieldname text COLLATE pg_catalog."default",
    oldvalue text COLLATE pg_catalog."default",
    newvalue text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_audit_lines
    OWNER to postgres;
	
-- Index: eb_audit_lines_id_idx

-- DROP INDEX public.eb_audit_lines_id_idx;

CREATE INDEX eb_audit_lines_id_idx
    ON public.eb_audit_lines USING btree
    (id)
    TABLESPACE pg_default;

