-- Table: public.eb_tenants

-- DROP TABLE public.eb_tenants;

CREATE TABLE public.eb_tenants
(
	id bigserial,
    cname text COLLATE pg_catalog."default",
    firstname text COLLATE pg_catalog."default",
    designation text COLLATE pg_catalog."default",
    company text COLLATE pg_catalog."default",
    phone text COLLATE pg_catalog."default",
    zipcode text COLLATE pg_catalog."default",
    language text COLLATE pg_catalog."default",
    password text COLLATE pg_catalog."default",
    employees text COLLATE pg_catalog."default",
    gender text COLLATE pg_catalog."default",
    birthday date,
    location text COLLATE pg_catalog."default",
    socialid text COLLATE pg_catalog."default",
    country text COLLATE pg_catalog."default",
    profileimg text COLLATE pg_catalog."default",
    prolink text COLLATE pg_catalog."default",
    u_token text COLLATE pg_catalog."default",
    isverified boolean DEFAULT false,
    isemailsent boolean,
    loginattempts integer DEFAULT 1,
    CONSTRAINT eb_clients_pkey PRIMARY KEY (id),
    CONSTRAINT socialkey UNIQUE (socialid)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_tenants
    OWNER to postgres;

CREATE INDEX eb_tenants_indx
    ON public.eb_tenants USING btree
    (id)
    TABLESPACE pg_default;
