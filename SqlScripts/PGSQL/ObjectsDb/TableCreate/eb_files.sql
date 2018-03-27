--SEQUENCE public.eb_files_id_seq

CREATE SEQUENCE public.eb_files_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_files_id_seq
    OWNER TO postgres;

-- Table: public.eb_files

-- DROP TABLE public.eb_files;

CREATE TABLE public.eb_files
(
    id integer NOT NULL DEFAULT nextval('eb_files_id_seq'::regclass),
    userid integer NOT NULL,
    objid text COLLATE pg_catalog."default" NOT NULL,
    length bigint,
    tags text COLLATE pg_catalog."default",
    bucketname text COLLATE pg_catalog."default",
    filetype text COLLATE pg_catalog."default",
    uploaddatetime timestamp without time zone,
    eb_del1 boolean NOT NULL DEFAULT false,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_files_pkey PRIMARY KEY (id),
    CONSTRAINT eb_files_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_files
    OWNER to postgres;

-- Index: eb_files_eb_del_idx

-- DROP INDEX public.eb_files_eb_del_idx;

CREATE INDEX eb_files_eb_del_idx
    ON public.eb_files USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_files_id_idx

-- DROP INDEX public.eb_files_id_idx;

CREATE INDEX eb_files_id_idx
    ON public.eb_files USING btree
    (id)
    TABLESPACE pg_default;