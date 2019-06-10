-- Table: public.eb_usersanonymous

-- DROP TABLE public.eb_usersanonymous;

CREATE TABLE public.eb_usersanonymous
(
    id serial,
    fullname text COLLATE pg_catalog."default",
    socialid text COLLATE pg_catalog."default",
    email text COLLATE pg_catalog."default",
    sex text COLLATE pg_catalog."default",
    phoneno text COLLATE pg_catalog."default",
    firstvisit timestamp(4) without time zone,
    lastvisit timestamp(4) without time zone,
    appid integer,
    totalvisits integer DEFAULT 1,
    ebuserid integer DEFAULT 1,
    modifiedby integer,
    modifiedat timestamp without time zone,
    remarks text COLLATE pg_catalog."default",
    ipaddress text COLLATE pg_catalog."default",
    browser text COLLATE pg_catalog."default",
    city text COLLATE pg_catalog."default",
    region text COLLATE pg_catalog."default",
    country text COLLATE pg_catalog."default",
    latitude text COLLATE pg_catalog."default",
    longitude text COLLATE pg_catalog."default",
    timezone text COLLATE pg_catalog."default",
    iplocationjson text COLLATE pg_catalog."default",
    CONSTRAINT eb_usersprospective_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_usersanonymous
    OWNER to postgres;

-- Index: eb_usersanonymous_email_idx

-- DROP INDEX public.eb_usersanonymous_email_idx;

CREATE INDEX eb_usersanonymous_email_idx
    ON public.eb_usersanonymous USING btree
    (email COLLATE pg_catalog."default")
    TABLESPACE pg_default;

-- Index: eb_usersanonymous_id_idx

-- DROP INDEX public.eb_usersanonymous_id_idx;

CREATE INDEX eb_usersanonymous_id_idx
    ON public.eb_usersanonymous USING btree
    (id)
    TABLESPACE pg_default;

-- Index: eb_usersanonymous_socialid_idx

-- DROP INDEX public.eb_usersanonymous_socialid_idx;

CREATE INDEX eb_usersanonymous_socialid_idx
    ON public.eb_usersanonymous USING btree
    (socialid COLLATE pg_catalog."default")
    TABLESPACE pg_default;