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
    eb_del "char" DEFAULT 'F'::"char",
    filecategory integer,
    context text,  
	context_sec text,
	lastmodifiedby integer,
	lastmodifiedat timestamp without time zone,
    CONSTRAINT eb_files_ref_pkey PRIMARY KEY (id),
    CONSTRAINT eb_files_ref_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


-- Index: eb_files_ref_id_idx

-- DROP INDEX public.eb_files_ref_id_idx;

CREATE INDEX eb_files_ref_id_idx
    ON eb_files_ref(id);

-- Index: eb_files_ref_userid_idx

-- DROP INDEX public.eb_files_ref_userid_idx;

CREATE INDEX eb_files_ref_userid_idx
    ON eb_files_ref(userid);