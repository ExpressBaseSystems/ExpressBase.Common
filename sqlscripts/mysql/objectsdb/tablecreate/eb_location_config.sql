-- Table: public.eb_location_config

-- DROP TABLE eb_location_config;

CREATE TABLE eb_location_config
(
    id integer NOT NULL AUTO_INCREMENT,
    `keys` text,
    isrequired char NOT NULL DEFAULT 'F',
    CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
);

-- Index: eb_locationsconfigid_idx

-- ALTER TABLE eb_location_config DROP INDEX eb_locationsconfigid_idx;

CREATE INDEX eb_locationsconfigid_idx
    ON eb_location_config(id);