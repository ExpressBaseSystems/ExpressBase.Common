-- ALTER SEQUENCE executionlogs_id_seq INCREMENT 1 RESTART 2 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;-- Table: public.eb_executionlogs

-- DROP TABLE public.eb_executionlogs;

CREATE TABLE public.eb_executionlogs
(
    id serial,
    rows text,
    exec_time integer,
    created_by integer,
    created_at timestamp without time zone,
    refid text,
    params json,
	CONSTRAINT eb_executionlogs_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

