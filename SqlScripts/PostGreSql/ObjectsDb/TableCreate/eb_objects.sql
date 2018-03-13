CREATE SEQUENCE public.eb_objects_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_objects_id_seq
    OWNER TO postgres;

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