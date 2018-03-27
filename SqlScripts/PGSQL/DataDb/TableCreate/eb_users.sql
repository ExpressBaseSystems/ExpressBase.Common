-- SEQUENCE public.eb_users_id_seq

CREATE SEQUENCE public.eb_users_id_seq
    INCREMENT 1
    START 2
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_users_id_seq
    OWNER TO postgres;


-- Table: public.eb_users

-- DROP TABLE public.eb_users;

CREATE TABLE public.eb_users
(
    id integer NOT NULL DEFAULT nextval('eb_users_id_seq'::regclass),
    email text COLLATE pg_catalog."default",
    pwd text COLLATE pg_catalog."default",
    eb_del1 boolean DEFAULT false,
    firstname text COLLATE pg_catalog."default",
    lastname text COLLATE pg_catalog."default",
    middlename text COLLATE pg_catalog."default",
    dob date,
    phnoprimary text COLLATE pg_catalog."default",
    phnosecondary text COLLATE pg_catalog."default",
    landline text COLLATE pg_catalog."default",
    phextension text COLLATE pg_catalog."default",
    locale text COLLATE pg_catalog."default",
    alternateemail text COLLATE pg_catalog."default",
    dateformat text COLLATE pg_catalog."default" DEFAULT 'DD/MM/YYYY'::text,
    timezone text COLLATE pg_catalog."default" DEFAULT 'UTC+05:30'::text,
    numformat text COLLATE pg_catalog."default" DEFAULT '0,000.00'::text,
    timezoneabbre text COLLATE pg_catalog."default",
    timezonefull text COLLATE pg_catalog."default",
    profileimg text COLLATE pg_catalog."default",
    slackjson json,
    prolink text COLLATE pg_catalog."default",
    loginattempts integer DEFAULT 1,
    socialid text COLLATE pg_catalog."default",
    socialname text COLLATE pg_catalog."default",
    fullname text COLLATE pg_catalog."default",
    nickname text COLLATE pg_catalog."default",
    sex text COLLATE pg_catalog."default",
    fbid text COLLATE pg_catalog."default",
    fbname text COLLATE pg_catalog."default",
    preferencesjson text COLLATE pg_catalog."default",
    createdby text COLLATE pg_catalog."default",
    createdat text COLLATE pg_catalog."default",
    statusid integer,
    hide text COLLATE pg_catalog."default",
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    CONSTRAINT eb_users_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_users
    OWNER to postgres;

-- Index: eb_users_eb_del_idx

-- DROP INDEX public.eb_users_eb_del_idx;

CREATE INDEX eb_users_eb_del_idx
    ON public.eb_users USING btree
    (eb_del)
    TABLESPACE pg_default;

-- Index: eb_users_email_idx

-- DROP INDEX public.eb_users_email_idx;

CREATE INDEX eb_users_email_idx
    ON public.eb_users USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: eb_users_id_idx

-- DROP INDEX public.eb_users_id_idx;

CREATE UNIQUE INDEX eb_users_id_idx
    ON public.eb_users USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_users_pwd_idx

-- DROP INDEX public.eb_users_pwd_idx;

CREATE INDEX eb_users_pwd_idx
    ON public.eb_users USING btree
    (pwd COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: eb_users_statusid_idx

-- DROP INDEX public.eb_users_statusid_idx;

CREATE INDEX eb_users_statusid_idx
    ON public.eb_users USING btree
    (statusid)
    TABLESPACE pg_default;