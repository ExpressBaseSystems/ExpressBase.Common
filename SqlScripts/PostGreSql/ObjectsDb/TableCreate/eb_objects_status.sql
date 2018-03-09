--SEQUENCE public.eb_objects_status_id_seq

CREATE SEQUENCE public.eb_objects_status_id_seq
    INCREMENT 1
    START 1074
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_objects_status_id_seq
    OWNER TO postgres;

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

-- Index: eb_objects_status_eb_obj_ver_id_idx

-- DROP INDEX public.eb_objects_status_eb_obj_ver_id_idx;

CREATE INDEX eb_objects_status_eb_obj_ver_id_idx
    ON public.eb_objects_status USING btree
    (eb_obj_ver_id)
    TABLESPACE pg_default;

-- Index: eb_objects_status_id_idx

-- DROP INDEX public.eb_objects_status_id_idx;

CREATE INDEX eb_objects_status_id_idx
    ON public.eb_objects_status USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_objects_status_refid_id_idx

-- DROP INDEX public.eb_objects_status_refid_id_idx;

CREATE INDEX eb_objects_status_refid_id_idx
    ON public.eb_objects_status USING btree
    (refid COLLATE pg_catalog."default")
    TABLESPACE pg_default;