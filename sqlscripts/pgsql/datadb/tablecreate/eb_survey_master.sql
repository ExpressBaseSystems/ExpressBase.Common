CREATE SEQUENCE public.eb_survey_master_id_seq
    INCREMENT 1
    START 6
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_survey_master_id_seq
    OWNER TO postgres;

-- Table: public.eb_survey_master

-- DROP TABLE public.eb_survey_master;

CREATE TABLE public.eb_survey_master
(
    id integer NOT NULL DEFAULT nextval('eb_survey_master_id_seq'::regclass),
    surveyid integer,
    userid integer,
    anonid integer,
    eb_createdate timestamp without time zone
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_survey_master
    OWNER to postgres;

-- Index: eb_survey_master_id_idx

-- DROP INDEX public.eb_survey_master_id_idx;

CREATE INDEX eb_survey_master_id_idx
    ON public.eb_survey_master USING btree
    (id)
    TABLESPACE pg_default;