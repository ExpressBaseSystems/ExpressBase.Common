-- Table: public.eb_redis_logs 

-- DROP TABLE public.eb_redis_logs;

CREATE TABLE public.eb_redis_logs
(
    id serial,
    changed_by integer NOT NULL,
    operation integer,
    changed_at timestamp without time zone,
    prev_value text COLLATE pg_catalog."default",
    new_value text COLLATE pg_catalog."default",
    soln_id integer,
    key text COLLATE pg_catalog."default",
    CONSTRAINT eb_redis_logs_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;