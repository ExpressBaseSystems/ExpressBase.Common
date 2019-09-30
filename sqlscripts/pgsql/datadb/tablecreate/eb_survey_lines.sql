-- Table: public.eb_survey_lines

-- DROP TABLE public.eb_survey_lines;

CREATE TABLE public.eb_survey_lines
(
    id serial,
    masterid integer,
    questionid integer,
    eb_createdate timestamp without time zone,
    choiceids text,
    questype integer,
    answer text COLLATE pg_catalog."default",
	CONSTRAINT eb_survey_lines_pkey PRIMARY KEY (id)
)
WITH (
    OIDS = FALSE
)
TABLESPACE pg_default;


-- Index: eb_survey_lines_id_idx

-- DROP INDEX public.eb_survey_lines_id_idx;

CREATE INDEX eb_survey_lines_id_idx
    ON public.eb_survey_lines USING btree
    (id)
    TABLESPACE pg_default;