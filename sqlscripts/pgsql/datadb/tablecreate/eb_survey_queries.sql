CREATE SEQUENCE public.eb_survey_queries_id_seq
    INCREMENT 1
    START 10
    MINVALUE 1
    MAXVALUE 9223372036854775807
    CACHE 1;

ALTER SEQUENCE public.eb_survey_queries_id_seq
    OWNER TO postgres;
	

-- Table: public.eb_survey_queries

-- DROP TABLE public.eb_survey_queries;

CREATE TABLE public.eb_survey_queries
(
    id integer NOT NULL DEFAULT nextval('eb_survey_queries_id_seq'::regclass),
    query text COLLATE pg_catalog."default",
    q_type integer
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;

ALTER TABLE public.eb_survey_queries
    OWNER to postgres;


-- Index: eb_survey_queries_id_idx

-- DROP INDEX public.eb_survey_queries_id_idx;

CREATE INDEX eb_survey_queries_id_idx
    ON public.eb_survey_queries USING btree
    (id)
    TABLESPACE pg_default;