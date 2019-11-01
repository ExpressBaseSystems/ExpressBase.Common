-- Table: public.eb_files_ref

-- DROP TABLE public.eb_files_ref;

CREATE TABLE eb_files_ref
(
    id serial,
    userid integer NOT NULL,
	filename text,    
    tags text,
    filetype text,
    uploadts timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    filecategory integer,
    context text,   
    CONSTRAINT eb_files_ref_pkey PRIMARY KEY (id),
    CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
);


-- Table: public.eb_files_ref_variations

-- DROP TABLE public.eb_files_ref_variations;

CREATE TABLE eb_files_ref_variations
(
    id serial,
    eb_files_ref_id integer NOT NULL,
    filestore_sid text,
    length bigint,
    is_image "char",
    imagequality_id integer,
    img_manp_ser_con_id integer,
    filedb_con_id integer,
    CONSTRAINT eb_files_ref_variations_pkey PRIMARY KEY (id)
);



