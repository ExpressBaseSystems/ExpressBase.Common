-- Table: public.eb_userpreferences

-- DROP TABLE public.eb_userpreferences;

CREATE TABLE public.eb_userpreferences
(
    id serial,
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