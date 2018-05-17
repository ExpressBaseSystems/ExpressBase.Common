CREATE SEQUENCE public.eb_userpreferences_id_seq
    INCREMENT 1
    START 1
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_userpreferences_id_seq
    OWNER TO postgres;

-- Table: public.eb_userpreferences

-- DROP TABLE public.eb_userpreferences;

CREATE TABLE public.eb_userpreferences
(
    id integer NOT NULL DEFAULT nextval('eb_userpreferences_id_seq'::regclass),
    locale text COLLATE pg_catalog."default",
    dateformat text COLLATE pg_catalog."default",
    numberformat text COLLATE pg_catalog."default",
    userid integer,
    cid text COLLATE pg_catalog."default",
    tenantid integer,
    CONSTRAINT eb_userpreferences_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_userpreferences
    OWNER to postgres;

CREATE INDEX eb_userpreferences_indx
    ON public.eb_userpreferences USING btree
    (id)
    TABLESPACE pg_default;