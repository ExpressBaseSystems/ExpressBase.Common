-- Table: public.eb_applications

-- DROP TABLE public.eb_applications;

CREATE TABLE public.eb_applications
(
    id serial,
    applicationname text,
    description text,
    app_icon text,
    application_type integer,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
	app_settings text,
    CONSTRAINT eb_applications_pkey PRIMARY KEY (id),
    CONSTRAINT eb_applications_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: public.eb_applications_id_idx

-- DROP INDEX public.eb_applications_id_idx;

CREATE INDEX eb_applications_id_idx
    ON public.eb_applications USING btree
       (id)
    TABLESPACE pg_default;

-- Index: public.eb_applications_eb_del_idx

-- DROP INDEX public.eb_applications_eb_del_idx;

CREATE INDEX eb_applications_eb_del_idx
    ON public.eb_applications USING btree
       (eb_del)
    TABLESPACE pg_default;



