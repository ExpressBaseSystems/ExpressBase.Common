-- Table: public.eb_usersanonymous

-- DROP TABLE public.eb_usersanonymous;

CREATE TABLE public.eb_usersanonymous
(
    id serial,
    fullname text,
    socialid text,
    email text,
    sex text,
    phoneno text,
    firstvisit timestamp(4) without time zone,
    lastvisit timestamp(4) without time zone,
    appid integer,
    totalvisits integer DEFAULT 1,
    ebuserid integer DEFAULT 1,
    modifiedby integer,
    modifiedat timestamp without time zone,
    remarks text,
    ipaddress text,
    browser text,
    city text,
    region text,
    country text,
    latitude text,
    longitude text,
    timezone text,
    iplocationjson text,
    CONSTRAINT eb_usersprospective_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


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