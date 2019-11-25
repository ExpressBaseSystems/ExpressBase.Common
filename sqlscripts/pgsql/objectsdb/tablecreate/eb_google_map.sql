-- Table: public.eb_google_map

-- DROP TABLE public.eb_google_map;

CREATE TABLE eb_google_map
(
    id serial,
    lattitude text ,
    longitude text,
    name text,
    CONSTRAINT eb_google_map_pkey PRIMARY KEY (id)
);


-- Index: eb_google_map_idx

-- DROP INDEX public.eb_google_map_idx;

CREATE INDEX eb_google_map_id_idx
    ON eb_google_map(id);

