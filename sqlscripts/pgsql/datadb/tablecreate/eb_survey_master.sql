-- Table: public.eb_survey_master

-- DROP TABLE public.eb_survey_master;

CREATE TABLE eb_survey_master
(
    id serial,
    surveyid integer,
    userid integer,
    anonid integer,
    eb_createdate timestamp without time zone,
    CONSTRAINT eb_survey_master_pkey PRIMARY KEY (id)
);


-- Index: eb_survey_master_id_idx

-- DROP INDEX public.eb_survey_master_id_idx;

CREATE INDEX eb_survey_master_id_idx
    ON eb_survey_master(id);