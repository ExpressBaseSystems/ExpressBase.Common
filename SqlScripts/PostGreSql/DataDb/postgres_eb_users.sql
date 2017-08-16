CREATE SEQUENCE IF NOT EXISTS eb_users_id_seq START 1;
--Table: public.eb_users

CREATE TABLE IF NOT EXISTS public.eb_users
(
    id integer NOT NULL DEFAULT nextval('eb_users_id_seq'::regclass),
    email text COLLATE pg_catalog."default",
    pwd text COLLATE pg_catalog."default",
    eb_del boolean DEFAULT false,
    firstname text COLLATE pg_catalog."default",
    lastname text COLLATE pg_catalog."default",
    middlename text COLLATE pg_catalog."default",
    dob date,
    phnoprimary text COLLATE pg_catalog."default",
    phnosecondary text COLLATE pg_catalog."default",
    landline text COLLATE pg_catalog."default",
    extension text COLLATE pg_catalog."default",
    locale text COLLATE pg_catalog."default",
    alternateemail text COLLATE pg_catalog."default",
    profileimg bytea,
    dateformat text COLLATE pg_catalog."default" DEFAULT 'DD/MM/YYYY'::text,
    timezone text COLLATE pg_catalog."default" DEFAULT 'UTC+05:30'::text,
    numformat text COLLATE pg_catalog."default" DEFAULT '0,000.00'::text,
    timezoneabbre text COLLATE pg_catalog."default",
    timezonefull text COLLATE pg_catalog."default",
    fullname text COLLATE pg_catalog."default",
    CONSTRAINT eb_users_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_users
    OWNER to postgres;

-- Index: eb_users_id_idx

-- DROP INDEX public.eb_users_id_idx;

CREATE UNIQUE INDEX eb_users_id_idx
    ON public.eb_users USING btree
    (id)
    TABLESPACE pg_default;

CREATE SEQUENCE IF NOT EXISTS eb_role2user_id_seq START 1;

-- Table: public.eb_role2user

CREATE TABLE IF NOT EXISTS public.eb_role2user
(
    id integer NOT NULL DEFAULT nextval('eb_role2user_id_seq'::regclass),
    role_id integer,
    user_id integer,
    eb_del boolean,
    CONSTRAINT eb_role2user_id_pkey PRIMARY KEY (id)
   
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_role2user
    OWNER to postgres;

-- Index: eb_role2user_id_idx

CREATE UNIQUE INDEX  eb_role2user_id_idx
    ON public.eb_role2user USING btree
    (id)
    TABLESPACE pg_default;