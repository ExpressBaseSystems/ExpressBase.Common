CREATE SEQUENCE public.eb_surveys_id_seq
    INCREMENT 1
    START 2
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_surveys_id_seq
    OWNER TO postgres;


-- Table: public.eb_surveys

-- DROP TABLE public.eb_surveys;

CREATE TABLE public.eb_surveys
(
    id integer NOT NULL DEFAULT nextval('eb_surveys_id_seq'::regclass),
    name text COLLATE pg_catalog."default",
    startdate timestamp without time zone,
    enddate timestamp without time zone,
    status integer,
    questions text COLLATE pg_catalog."default"
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