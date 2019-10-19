-- Table: public.eb_schedules

-- DROP TABLE public.eb_schedules;

CREATE TABLE public.eb_schedules
(
    id serial,
    task json,
    created_by integer,
    created_at timestamp without time zone,
    eb_del "char",
    jobkey text,
    triggerkey text,
    status numeric,
    obj_id numeric,
    name text,
	CONSTRAINT eb_schedules_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

	
ALTER SEQUENCE eb_schedules_id_seq INCREMENT 1 RESTART 2 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;
