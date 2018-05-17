CREATE SEQUENCE public.eb_tenantaccount_id_seq
    INCREMENT 1
    START 83
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_tenantaccount_id_seq
    OWNER TO postgres;


-- Table: public.eb_tenantaccount

-- DROP TABLE public.eb_tenantaccount;

CREATE TABLE public.eb_tenantaccount
(
    id integer NOT NULL DEFAULT nextval('eb_tenantaccount_id_seq'::regclass),
    accountname text COLLATE pg_catalog."default",
    solution_id text COLLATE pg_catalog."default",
    address text COLLATE pg_catalog."default",
    phone text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    website text COLLATE pg_catalog."default",
    tier text COLLATE pg_catalog."default",
    tenantname text COLLATE pg_catalog."default",
    tenantid integer,
    profilelogo text COLLATE pg_catalog."default",
    createdat timestamp without time zone,
    validtill timestamp without time zone,
    dbconfigtype integer,
    CONSTRAINT eb_tenantaccount_pkey PRIMARY KEY (id),
    CONSTRAINT cid_unique UNIQUE (solution_id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_tenantaccount
    OWNER to postgres;


CREATE INDEX eb_tenantaccount_indx
    ON public.eb_tenantaccount USING btree
    (id)
    TABLESPACE pg_default;