-- Table: public.eb_users

-- DROP TABLE public.eb_users;

CREATE TABLE public.eb_users
(
    id serial,
    email text,
    pwd text,
    eb_del1 boolean DEFAULT false,
    firstname text,
    lastname text,
    middlename text,
    dob date,
    phnoprimary text,
    phnosecondary text,
    landline text,
    phextension text,
    locale text,
    alternateemail text,
    dateformat text COLLATE pg_catalog."default" DEFAULT 'DD/MM/YYYY'::text,
    timezone text COLLATE pg_catalog."default" DEFAULT 'UTC+05:30'::text,
    numformat text COLLATE pg_catalog."default" DEFAULT '0,000.00'::text,
    timezoneabbre text,
    timezonefull text,
    profileimg text,
    slackjson json,
    prolink text,
    loginattempts integer DEFAULT 1,
    socialid text,
    socialname text,
    fullname text,
    nickname text,
    sex text,
    fbid text,
    fbname text,
    preferencesjson text,
    createdby text,
    createdat text,
    statusid integer DEFAULT 0,
    hide text,
    eb_del "char" NOT NULL DEFAULT 'F'::"char",
    dprefid integer DEFAULT 0,
    CONSTRAINT eb_users_pkey PRIMARY KEY (id),
    CONSTRAINT eb_users_eb_del_check CHECK (eb_del = 'T'::"char" OR eb_del = 'F'::"char")
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


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