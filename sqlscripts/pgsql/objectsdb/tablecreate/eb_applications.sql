-- Table: public.eb_applications

-- DROP TABLE public.eb_applications;

CREATE TABLE eb_applications
(
    id serial,
    applicationname text,
    description text,
    app_icon text,
    application_type integer,
    eb_del char(1) NOT NULL DEFAULT 'F',
	app_settings text,
    CONSTRAINT eb_applications_pkey PRIMARY KEY (id),
    CONSTRAINT eb_applications_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F')
);


-- Index: public.eb_applications_id_idx

-- DROP INDEX public.eb_applications_id_idx;

CREATE INDEX eb_applications_id_idx
    ON eb_applications(id);

-- Index: public.eb_applications_eb_del_idx

-- DROP INDEX public.eb_applications_eb_del_idx;

CREATE INDEX eb_applications_eb_del_idx
    ON eb_applications(eb_del);







