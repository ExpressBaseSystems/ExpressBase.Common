-- Table: public.eb_locations

-- DROP TABLE public.eb_locations;

CREATE TABLE public.eb_locations
(
    id serial,
    shortname text COLLATE pg_catalog."default" DEFAULT 'default'::text,
    longname text COLLATE pg_catalog."default" DEFAULT 'default'::text,
    image text COLLATE pg_catalog."default",
    meta_json text COLLATE pg_catalog."default",
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_locationsid_idx

-- DROP INDEX public.eb_locationsid_idx;

CREATE INDEX eb_locationsid_idx
    ON public.eb_locations USING btree
    (id)
    TABLESPACE pg_default;
