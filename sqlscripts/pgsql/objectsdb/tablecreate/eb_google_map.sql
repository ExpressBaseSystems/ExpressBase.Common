-- Table: public.eb_google_map

-- DROP TABLE public.eb_google_map;

CREATE TABLE public.eb_google_map
(
    id serial,
    lattitude text ,
    longitude text,
    name text,
    CONSTRAINT eb_google_map_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_google_map
    OWNER to postgres;

-- Index: eb_google_map_idx

-- DROP INDEX public.eb_google_map_idx;

CREATE INDEX eb_google_map_idx
    ON public.eb_google_map USING btree
    (id)
    TABLESPACE pg_default;

