-- Table: public.eb_files_ref

-- DROP TABLE public.eb_files_ref;

CREATE TABLE public.eb_files_ref
(
    id serial,
    userid integer NOT NULL,
    filestore_id text COLLATE pg_catalog."default" NOT NULL,
    length bigint,
    tags text COLLATE pg_catalog."default",
    filetype text COLLATE pg_catalog."default",
    uploadts timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    filecategory integer,
    filename text COLLATE pg_catalog."default",
    CONSTRAINT eb_files_ref_pkey PRIMARY KEY (id),
    CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_files_ref
    OWNER to postgres;
-- Index: eb_files_ref_eb_del_idx

-- DROP INDEX public.eb_files_ref_eb_del_idx;

CREATE INDEX eb_files_ref_eb_del_idx
    ON public.eb_files_ref USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_files_ref_id_idx

-- DROP INDEX public.eb_files_ref_id_idx;

CREATE INDEX eb_files_ref_id_idx
    ON public.eb_files_ref USING btree
    (id)
    TABLESPACE pg_default;