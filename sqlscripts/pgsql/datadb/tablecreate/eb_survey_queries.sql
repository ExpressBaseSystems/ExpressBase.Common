-- Table: public.eb_survey_queries

-- DROP TABLE public.eb_survey_queries;

CREATE TABLE public.eb_survey_queries
(
    id serial,
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