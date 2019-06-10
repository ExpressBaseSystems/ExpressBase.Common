-- Table: public.eb_surveys

-- DROP TABLE public.eb_surveys;

CREATE TABLE public.eb_surveys
(
    id serial,
    name text COLLATE pg_catalog."default",
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    status integer,
    questions text COLLATE pg_catalog."default",
	CONSTRAINT eb_surveys_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_surveys
    OWNER to postgres;


-- Index: eb_surveys_id_idx

-- DROP INDEX public.eb_surveys_id_idx;

CREATE INDEX eb_surveys_id_idx
    ON public.eb_surveys USING btree
    (id)
    TABLESPACE pg_default;