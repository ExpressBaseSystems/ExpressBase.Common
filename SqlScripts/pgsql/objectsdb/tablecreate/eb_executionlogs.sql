-- Table: public.eb_executionlogs

-- DROP TABLE public.eb_executionlogs;

CREATE TABLE public.eb_executionlogs
(
    id serial,
    rows character varying COLLATE pg_catalog."default",
    exec_time integer,
    created_by integer,
    created_at timestamp without time zone,
    refid text COLLATE pg_catalog."default",
    params json
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_executionlogs
    OWNER to postgres;