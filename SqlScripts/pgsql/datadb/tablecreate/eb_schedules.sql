-- Table: public.eb_schedules

-- DROP TABLE public.eb_schedules;

CREATE TABLE public.eb_schedules
(
    id serial primary key,-- integer NOT NULL DEFAULT nextval('eb_schedules_id_seq'::regclass),
    task json,
    created_by integer,
    created_at timestamp without time zone,
    eb_del "char",
    jobkey text COLLATE pg_catalog."default",
    triggerkey text COLLATE pg_catalog."default",
    status numeric,
    obj_id numeric,
    name text COLLATE pg_catalog."default"
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_schedules
    OWNER to postgres;

	
ALTER SEQUENCE eb_schedules_id_seq INCREMENT 1 RESTART 2 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;
