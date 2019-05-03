-- Table: public.eb_appstore

-- DROP TABLE public.eb_appstore;

CREATE TABLE public.eb_appstore
(
    id serial primary key,-- integer NOT NULL DEFAULT nextval('eb_app_store_id_seq'::regclass),
    app_name text COLLATE "default".pg_catalog,
    status integer,
    user_tenant_acc_id text COLLATE "default".pg_catalog,
    cost integer,
    created_by integer,
    created_at timestamp without time zone,
    json json,
    eb_del boolean,
    currency text COLLATE "default".pg_catalog,
    CONSTRAINT eb_app_store_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_appstore
    OWNER to postgres;