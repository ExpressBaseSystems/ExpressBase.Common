-- Table: public.eb_objects2application

-- DROP TABLE public.eb_objects2application;

CREATE TABLE eb_objects2application
(
	id serial,
    app_id integer,
    obj_id integer,
    removed_by integer,
    removed_at timestamp without time zone,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_objects2application_eb_del_check CHECK (eb_del = 'T' OR eb_del = 'F'),
	CONSTRAINT eb_objects2application_pkey PRIMARY KEY(id)
);


-- Index: eb_objects2application_app_id_idx

-- DROP INDEX public.eb_objects2application_app_id_idx;

CREATE INDEX eb_objects2application_app_id_idx
    ON eb_objects2application(app_id);

-- Index: eb_objects2application_eb_del_idx

-- DROP INDEX public.eb_objects2application_eb_del_idx;

CREATE INDEX eb_objects2application_eb_del_idx
    ON eb_objects2application(eb_del);

-- Index: eb_objects2application_id_idx

-- DROP INDEX public.eb_objects2application_id_idx;

CREATE INDEX eb_objects2application_id_idx
    ON eb_objects2application(id);

-- Index: eb_objects2application_obj_id_idx

-- DROP INDEX public.eb_objects2application_obj_id_idx;

CREATE INDEX eb_objects2application_obj_id_idx
    ON eb_objects2application(obj_id);