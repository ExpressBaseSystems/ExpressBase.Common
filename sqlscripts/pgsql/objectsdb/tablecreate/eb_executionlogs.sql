-- Table: public.eb_executionlogs

-- DROP TABLE public.eb_executionlogs;

CREATE TABLE eb_executionlogs
(
    id serial,
    rows text,
    exec_time integer,
    created_by integer,
    created_at timestamp without time zone,
    refid text,
    params json,
	CONSTRAINT eb_executionlogs_pkey PRIMARY KEY (id)
);

-- Index: eb_executionlogs_id_idx

-- DROP INDEX public.eb_executionlogs_id_idx;

CREATE INDEX eb_executionlogs_id_idx
    ON eb_executionlogs(id);