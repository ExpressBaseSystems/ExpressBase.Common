-- Table: public.eb_bots

-- DROP TABLE public.eb_bots;

CREATE TABLE public.eb_bots
(
    id serial,
    name text,
    url text,
    welcome_msg text,
    botid text,
    modified_by integer,
    solution_id integer,
    created_at timestamp without time zone,
    modified_at timestamp without time zone,
    created_by integer,
    app_id integer,
    fullname text,
    CONSTRAINT eb_bots_pkey PRIMARY KEY (id),
    CONSTRAINT botid_uniquekey UNIQUE (botid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_bots_app_id_idx

-- DROP INDEX public.eb_bots_app_id_idx;

CREATE INDEX eb_bots_app_id_idx
    ON public.eb_bots USING btree
    (app_id)
    TABLESPACE pg_default;

-- Index: eb_bots_id_idx

-- DROP INDEX public.eb_bots_id_idx;

CREATE INDEX eb_bots_id_idx
    ON public.eb_bots USING btree
    (id)
    TABLESPACE pg_default;