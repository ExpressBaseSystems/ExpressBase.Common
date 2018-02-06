
-- Table: public.eb_objects

-- DROP TABLE public.eb_objects;

CREATE TABLE public.eb_objects
(
    id integer NOT NULL DEFAULT nextval('eb_objects_id_seq'::regclass),
    obj_name text COLLATE pg_catalog."default",
    obj_type integer,
    obj_cur_status integer,
    obj_desc text COLLATE pg_catalog."default",
    applicationid integer,
    obj_tags text COLLATE pg_catalog."default",
    owner_uid integer,
    owner_ts timestamp without time zone,
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects
    OWNER to postgres;


-- Table: public.eb_objects_relations

-- DROP TABLE public.eb_objects_relations;

CREATE TABLE public.eb_objects_relations
(
    dominant text COLLATE pg_catalog."default",
    dependant text COLLATE pg_catalog."default",
    id integer NOT NULL DEFAULT nextval('eb_objects_relations_id_seq'::regclass),
    eb_del boolean,
    removed_by integer,
    removed_at timestamp without time zone,
    CONSTRAINT eb_objects_relations_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_relations
    OWNER to postgres;
	

-- Table: public.eb_objects_status

-- DROP TABLE public.eb_objects_status;

CREATE TABLE public.eb_objects_status
(
    id integer NOT NULL DEFAULT nextval('eb_objects_status_id_seq'::regclass),
    refid text COLLATE pg_catalog."default",
    status integer,
    uid integer,
    ts timestamp without time zone,
    eb_obj_ver_id integer,
    changelog text COLLATE pg_catalog."default",
    CONSTRAINT eb_objects_status_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_status
    OWNER to postgres;
	

-- Table: public.eb_objects_ver

-- DROP TABLE public.eb_objects_ver;

CREATE TABLE public.eb_objects_ver
(
    id integer NOT NULL DEFAULT nextval('eb_objects_ver_id_seq'::regclass),
    eb_objects_id integer,
    obj_changelog text COLLATE pg_catalog."default",
    commit_uid integer,
    commit_ts timestamp without time zone,
    obj_json json,
    refid text COLLATE pg_catalog."default",
    version_num text COLLATE pg_catalog."default",
    major_ver_num integer,
    minor_ver_num integer,
    patch_ver_num integer,
    working_mode boolean DEFAULT false,
    status_id integer,
    ver_num text COLLATE pg_catalog."default",
    CONSTRAINT eb_objects_ver_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects_ver
    OWNER to postgres;


-- Table: public.eb_applications

-- DROP TABLE public.eb_applications;

CREATE TABLE public.eb_applications
(
    id integer NOT NULL DEFAULT nextval('eb_applications_id_seq'::regclass),
    application_name text COLLATE pg_catalog."default",
    application_type text COLLATE pg_catalog."default",
    description text COLLATE pg_catalog."default",
    eb_del boolean DEFAULT false,
    app_icon text COLLATE pg_catalog."default",
    app_id text COLLATE pg_catalog."default",
    CONSTRAINT eb_applications_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_applications
    OWNER to postgres;

-- Table: public.eb_objects2application

-- DROP TABLE public.eb_objects2application;

CREATE TABLE public.eb_objects2application
(
    app_id integer,
    id integer NOT NULL DEFAULT nextval('eb_objects2application_id_seq'::regclass),
    obj_id integer,
    eb_del boolean DEFAULT false,
    removed_by integer,
    removed_at timestamp without time zone
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects2application
    OWNER to postgres;