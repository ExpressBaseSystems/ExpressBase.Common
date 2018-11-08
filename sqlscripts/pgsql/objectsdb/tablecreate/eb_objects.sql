-- Table: public.eb_objects

-- DROP TABLE public.eb_objects;

CREATE TABLE public.eb_objects
(
    id serial,
    obj_name text COLLATE pg_catalog."default",
    obj_type integer,
    obj_cur_status integer,
    obj_desc text COLLATE pg_catalog."default",
    applicationid integer,
    obj_tags text COLLATE pg_catalog."default",
    owner_uid integer,
    owner_ts timestamp without time zone,
	display_name text COLLATE pg_catalog."default",
    CONSTRAINT eb_objects_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects
    OWNER to postgres;

-- Index: eb_objects_applicationid_idx

-- DROP INDEX public.eb_objects_applicationid_idx;

CREATE INDEX eb_objects_applicationid_idx
    ON public.eb_objects USING btree
    (applicationid)
    TABLESPACE pg_default;

-- Index: eb_objects_id_idx

-- DROP INDEX public.eb_objects_id_idx;

CREATE UNIQUE INDEX eb_objects_id_idx
    ON public.eb_objects USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_objects_type_idx

-- DROP INDEX public.eb_objects_type_idx;

CREATE INDEX eb_objects_type_idx
    ON public.eb_objects USING btree
    (obj_type)
    TABLESPACE pg_default;