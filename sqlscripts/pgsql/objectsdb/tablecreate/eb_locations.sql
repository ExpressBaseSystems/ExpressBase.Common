CREATE SEQUENCE public.eb_locations_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_locations_id_seq
    OWNER TO postgres;

-- Table: public.eb_locations

-- DROP TABLE public.eb_locations;

CREATE TABLE public.eb_locations
(
    id integer NOT NULL DEFAULT nextval('eb_locations_id_seq'::regclass),
    shortname text COLLATE pg_catalog."default",
    longname text COLLATE pg_catalog."default",
    image text COLLATE pg_catalog."default",
    meta_json text COLLATE pg_catalog."default"
    CONSTRAINT eb_locations_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_locations
    OWNER to postgres;

-- Index: eb_locationsid_idx

-- DROP INDEX public.eb_locationsid_idx;

CREATE INDEX eb_locationsid_idx
    ON public.eb_locations USING btree
    (id)
    TABLESPACE pg_default;
