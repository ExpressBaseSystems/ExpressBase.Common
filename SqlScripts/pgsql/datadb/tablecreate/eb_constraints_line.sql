-- Table: public.eb_constraints_line

-- DROP TABLE public.eb_constraints_line;

CREATE TABLE public.eb_constraints_line
(
    id serial,
    master_id integer,
    c_type integer,
    c_operation integer,
    c_value text,
    CONSTRAINT eb_constraints_line_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_constraints_line
    OWNER to postgres;
	
	
-- Index: eb_constraints_line_id_idx

-- DROP INDEX public.eb_constraints_line_id_idx;

CREATE INDEX eb_constraints_line_id_idx
    ON public.eb_constraints_line USING btree
    (id)
    TABLESPACE pg_default;