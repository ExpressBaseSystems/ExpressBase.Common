-- Table: public.eb_google_map

-- DROP TABLE eb_google_map;

CREATE TABLE eb_google_map
(
    id integer NOT NULL AUTO_INCREMENT,
    lattitude text ,
    longitude text,
    name text,
    CONSTRAINT eb_google_map_pkey PRIMARY KEY (id)
);

-- Index: eb_google_map_idx

-- ALTER TABLE eb_google_map DROP INDEX eb_google_map_idx;

CREATE INDEX eb_google_map_idx
    ON eb_google_map(id);