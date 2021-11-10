-- Table: public.eb_files_bytea

-- DROP TABLE public.eb_files_bytea;

CREATE TABLE eb_files_bytea
(
    id serial,
    filename text,
    bytea bytea,
    meta json,
    filecategory integer,
    CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
);


-- Index: eb_files_id_idx

-- DROP INDEX public.eb_files_id_idx;

CREATE INDEX eb_files_bytea_id_idx
    ON eb_files_bytea(id);