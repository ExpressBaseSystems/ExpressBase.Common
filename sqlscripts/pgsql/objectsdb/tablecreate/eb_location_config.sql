-- Table: public.eb_location_config

-- DROP TABLE public.eb_location_config;

CREATE TABLE eb_location_config
(
    id serial,
    keys text,
    isrequired char(1) DEFAULT 'F',
	keytype text,
    eb_del char(1) DEFAULT 'F',
    CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
);


-- Index: eb_locationsconfig_id_idx

-- DROP INDEX public.eb_locationsconfig_id_idx;

CREATE INDEX eb_locationsconfig_id_idx
    ON eb_location_config(id);

