-- Table: public.eb_location_config

-- DROP TABLE public.eb_location_config;

CREATE TABLE eb_location_config
(
    id serial,
    keys text,
    isrequired "char" NOT NULL DEFAULT 'F'::"char",
	keytype text,
    eb_del "char",
    CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
);


-- Index: eb_locationsconfigid_idx

-- DROP INDEX public.eb_locationsconfigid_idx;

CREATE INDEX eb_locationsconfigid_idx
    ON eb_location_config(id);

