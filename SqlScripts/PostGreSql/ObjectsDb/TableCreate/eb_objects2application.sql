--SEQUENCE public.eb_objects2application_id_seq

CREATE SEQUENCE public.eb_objects2application_id_seq
    INCREMENT 1
    START 485
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_objects2application_id_seq
    OWNER TO postgres;

-- Table: public.eb_objects2application

-- DROP TABLE public.eb_objects2application;

CREATE TABLE public.eb_objects2application
(
    app_id integer,
    id integer NOT NULL DEFAULT nextval('eb_objects2application_id_seq'::regclass),
    obj_id integer,
    eb_del1 boolean DEFAULT false,
    removed_by integer,
    removed_at timestamp without time zone,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_objects2application_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_objects2application
    OWNER to postgres;

-- Index: eb_objects2application_app_id_idx

-- DROP INDEX public.eb_objects2application_app_id_idx;

CREATE INDEX eb_objects2application_app_id_idx
    ON public.eb_objects2application USING btree
    (app_id)
    TABLESPACE pg_default;

-- Index: eb_objects2application_eb_del_idx

-- DROP INDEX public.eb_objects2application_eb_del_idx;

CREATE INDEX eb_objects2application_eb_del_idx
    ON public.eb_objects2application USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_objects2application_id_idx

-- DROP INDEX public.eb_objects2application_id_idx;

CREATE INDEX eb_objects2application_id_idx
    ON public.eb_objects2application USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_objects2application_obj_id_idx

-- DROP INDEX public.eb_objects2application_obj_id_idx;

CREATE INDEX eb_objects2application_obj_id_idx
    ON public.eb_objects2application USING btree
    (obj_id)
    TABLESPACE pg_default;