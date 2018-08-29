--SEQUENCE public.eb_files_bytea_id_seq

CREATE SEQUENCE public.eb_files_bytea_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;


ALTER SEQUENCE public.eb_files_bytea_id_seq
    OWNER TO postgres;

-- Table: public.eb_files_bytea

-- DROP TABLE public.eb_files_bytea;

CREATE TABLE public.eb_files_bytea
(
    id integer NOT NULL DEFAULT nextval('eb_files_bytea_id_seq'::regclass),
    filename text COLLATE pg_catalog."default",
    bytea bytea,
    meta json,
    filecategory integer,
    CONSTRAINT eb_files_bytea_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_files_bytea
    OWNER to postgres;

-- Index: eb_files_id_idx

-- DROP INDEX public.eb_files_id_idx;

CREATE INDEX eb_files_bytea_id_idx
    ON public.eb_files_bytea USING btree
    (id)
    TABLESPACE pg_default;