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
