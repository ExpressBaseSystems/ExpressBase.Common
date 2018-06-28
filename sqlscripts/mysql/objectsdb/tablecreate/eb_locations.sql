-- Table: public.eb_locations

-- DROP TABLE eb_locations;

CREATE TABLE eb_locations
(
    id integer NOT NULL AUTO_INCREMENT,
    shortname text,
    longname text,
    image text,
    meta_json text,
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);

-- Index: eb_locationsid_idx

-- ALTER TABLE eb_locations DROP INDEX eb_locationsid_idx;

CREATE INDEX eb_locationsid_idx
    ON eb_locations(id);
