-- Table: public.eb_files_ref

-- DROP TABLE public.eb_files_ref;

CREATE TABLE public.eb_files_ref
(
    id serial primary key,
    userid integer NOT NULL,
    --filestore_id text COLLATE pg_catalog."default",
    --length bigint,
    tags text COLLATE pg_catalog."default",
    filetype text COLLATE pg_catalog."default",
    uploadts timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    filecategory integer,
    filename text COLLATE pg_catalog."default",
    --img_manp_ser_id integer,
    CONSTRAINT eb_files_ref_pkey PRIMARY KEY (id),
    CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_files_ref
    OWNER to postgres;




-- Table: public.eb_files_ref_variations

-- DROP TABLE public.eb_files_ref_variations;

CREATE TABLE public.eb_files_ref_variations
(
    id serial primary key,
    eb_files_ref_id integer NOT NULL,
    filestore_sid text COLLATE pg_catalog."default",
    length bigint,
    is_image "char",
    imagequality_id integer,
    img_manp_ser_con_id integer,
    filedb_con_id integer,
    CONSTRAINT eb_files_ref_variations_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_files_ref_variations
    OWNER to postgres;

