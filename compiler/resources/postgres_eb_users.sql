CREATE SEQUENCE IF NOT EXISTS eb_users_id_seq START 1;
--Table: public.eb_users

--DROP TABLE public.eb_users;

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
    locale text COLLATE pg_catalog."default" NOT NULL,
    alternateemail text COLLATE pg_catalog."default",
    profileimg bytea,
    dateformat text COLLATE pg_catalog."default" NOT NULL DEFAULT 'DD/MM/YYYY'::text,
    timezone text COLLATE pg_catalog."default" NOT NULL DEFAULT 'UTC+05:30'::text,
    numformat text COLLATE pg_catalog."default" NOT NULL DEFAULT '0,000.00'::text,
    timezoneabbre text COLLATE pg_catalog."default" NOT NULL,
    timezonefull text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT eb_users_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_users
    OWNER to postgres;

--Index: eb_users_id_idx

--DROP INDEX public.eb_users_id_idx;

CREATE UNIQUE INDEX eb_users_id_idx
    ON public.eb_users USING btree
    (id)
    TABLESPACE pg_default;CREATE SEQUENCE IF NOT EXISTS eb_users_id_seq START 1;
--Table: public.eb_users

--DROP TABLE public.eb_users;

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
    locale text COLLATE pg_catalog."default" NOT NULL,
    alternateemail text COLLATE pg_catalog."default",
    profileimg bytea,
    dateformat text COLLATE pg_catalog."default" NOT NULL DEFAULT 'DD/MM/YYYY'::text,
    timezone text COLLATE pg_catalog."default" NOT NULL DEFAULT 'UTC+05:30'::text,
    numformat text COLLATE pg_catalog."default" NOT NULL DEFAULT '0,000.00'::text,
    timezoneabbre text COLLATE pg_catalog."default" NOT NULL,
    timezonefull text COLLATE pg_catalog."default" NOT NULL,
    CONSTRAINT eb_users_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_users
    OWNER to postgres;

--Index: eb_users_id_idx

--DROP INDEX public.eb_users_id_idx;

CREATE UNIQUE INDEX eb_users_id_idx
    ON public.eb_users USING btree
    (id)
    TABLESPACE pg_default;