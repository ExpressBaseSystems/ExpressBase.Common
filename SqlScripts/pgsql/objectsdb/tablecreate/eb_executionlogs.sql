-- Table: public.eb_executionlogs

-- DROP TABLE public.eb_executionlogs;

CREATE TABLE public.eb_executionlogs
(
    id serial, -- INTEGER NOT NULL DEFAULT nextval('executionlogs_id_seq'::regclass),
    rows character varying COLLATE pg_catalog."default",
    exec_time integer,
    created_by integer,
    created_at timestamp without time zone,
    refid text COLLATE pg_catalog."default",
    params json,
	CONSTRAINT eb_executionlogs_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_executionlogs
    OWNER to postgres;


-- ALTER SEQUENCE executionlogs_id_seq INCREMENT 1 RESTART 2 MINVALUE 1 MAXVALUE 9223372036854775807 CACHE 1;