-- Table: public.eb_locations

-- DROP TABLE public.eb_locations;

CREATE TABLE eb_locations
(
    id serial,
    shortname text DEFAULT 'default',
    longname text  DEFAULT 'default',
    image text,
    meta_json text,
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
);


-- Index: eb_locationsid_idx

-- DROP INDEX public.eb_locationsid_idx;

CREATE INDEX eb_locationsid_idx
    ON eb_locations(id);
