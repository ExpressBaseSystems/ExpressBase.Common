CREATE SEQUENCE public.eb_google_map_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_google_map_seq
    OWNER TO postgres;

-- Table: public.eb_google_map

-- DROP TABLE public.eb_google_map;

CREATE TABLE public.eb_google_map
(
    id integer NOT NULL DEFAULT nextval('eb_google_map_seq'::regclass),
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

