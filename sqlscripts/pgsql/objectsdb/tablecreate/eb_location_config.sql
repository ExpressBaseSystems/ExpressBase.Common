CREATE SEQUENCE public.eb_location_config_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_location_config_id_seq
    OWNER TO postgres;

-- Table: public.eb_location_config

-- DROP TABLE public.eb_location_config;

CREATE TABLE public.eb_location_config
(
    id integer NOT NULL DEFAULT nextval('eb_location_config_id_seq'::regclass),
    keys text COLLATE pg_catalog."default",
    isrequired "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_locationsconfig_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_location_config
    OWNER to postgres;

-- Index: eb_locationsconfigid_idx

-- DROP INDEX public.eb_locationsconfigid_idx;

CREATE INDEX eb_locationsconfigid_idx
    ON public.eb_location_config USING btree
    (id)
    TABLESPACE pg_default;

