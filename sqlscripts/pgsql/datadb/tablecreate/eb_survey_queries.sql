-- Table: public.eb_survey_queries

-- DROP TABLE public.eb_survey_queries;

CREATE TABLE public.eb_survey_queries
(
    id serial,
    query text,
    q_type integer,
	CONSTRAINT eb_survey_queries_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_survey_queries_id_idx

-- DROP INDEX public.eb_survey_queries_id_idx;

CREATE INDEX eb_survey_queries_id_idx
    ON public.eb_survey_queries USING btree
    (id)
    TABLESPACE pg_default;