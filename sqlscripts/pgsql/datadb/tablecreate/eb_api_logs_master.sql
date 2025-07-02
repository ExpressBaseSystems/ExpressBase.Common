-- Table: public.eb_api_logs_master

-- DROP TABLE IF EXISTS public.eb_api_logs_master;

CREATE TABLE eb_api_logs_master
(
    id serial,
    name text,
    version text,
    refid text,
    type integer,
    params json,
    status text,
    message text,
    result json,
    eb_created_by integer,
    eb_created_at timestamp without time zone,
    eb_updated_at timestamp without time zone,
    CONSTRAINT eb_api_logs_master_pkey PRIMARY KEY (id)
);

-- Index: eb_api_logs_master_id_idx

-- DROP INDEX IF EXISTS public.eb_api_logs_master_id_idx;

CREATE INDEX eb_api_logs_master_id_idx
    ON eb_api_logs_master(id);