-- Table: public.eb_bots

-- DROP TABLE public.eb_bots;

CREATE TABLE public.eb_bots
(
    id serial primary key,
    name text COLLATE pg_catalog."default",
    url text COLLATE pg_catalog."default",
    welcome_msg text COLLATE pg_catalog."default",
    botid text COLLATE pg_catalog."default",
    modified_by integer,
    solution_id integer,
    created_at timestamp without time zone,
    modified_at timestamp without time zone,
    created_by integer,
    app_id integer,
    fullname text COLLATE pg_catalog."default",
    CONSTRAINT eb_bots_pkey PRIMARY KEY (id),
    CONSTRAINT botid_uniquekey UNIQUE (botid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_bots
    OWNER to postgres;

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