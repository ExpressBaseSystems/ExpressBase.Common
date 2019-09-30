-- Table: public.eb_audit_lines

-- DROP TABLE public.eb_audit_lines;

CREATE TABLE public.eb_audit_lines
(
    id serial,
    masterid integer,
    fieldname text, 
    oldvalue text,
    newvalue text,
	tablename text,
    idrelation text,
	CONSTRAINT eb_audit_lines_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

	
-- Index: eb_audit_lines_id_idx

-- DROP INDEX public.eb_audit_lines_id_idx;

CREATE INDEX eb_audit_lines_id_idx
    ON public.eb_audit_lines USING btree
    (id)
    TABLESPACE pg_default;

