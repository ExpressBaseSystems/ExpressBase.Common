-- Table: public.eb_location_config

-- DROP TABLE public.eb_location_config;

CREATE TABLE public.eb_location_config
(
    id serial primary key,
    keys text COLLATE pg_catalog."default",
    isrequired "char" NOT NULL DEFAULT 'F'::"char",
	keytype text COLLATE pg_catalog."default",
    eb_del "char",
    CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_location_config
    OWNER to postgres;

-- Index: eb_locationsconfigid_idx

-- DROP INDEX public.eb_locationsconfigid_idx;

CREATE INDEX eb_locationsconfigid_idx
    ON public.eb_location_config USING btree
    (id)
    TABLESPACE pg_default;

