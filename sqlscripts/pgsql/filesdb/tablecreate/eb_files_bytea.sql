-- Table: public.eb_files_bytea

-- DROP TABLE public.eb_files_bytea;

CREATE TABLE public.eb_files_bytea
(
    id serial,
    filename text,
    bytea bytea,
    meta json,
    filecategory integer,
    CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_files_id_idx

-- DROP INDEX public.eb_files_id_idx;

CREATE INDEX eb_files_bytea_id_idx
    ON public.eb_files_bytea USING btree
    (id)
    TABLESPACE pg_default;